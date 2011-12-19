//
//  NSManagedObject+Utilities.m
//  
//
//  Created by Owain Hunt on 26/11/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//

/** 
 Extends `NSManagedObjectContext` for the purpose of working with external data, for example a web service. 
 */

#import "NSManagedObjectContext+Utilities.h"

@implementation NSManagedObjectContext (Utilities)

/**
 
 Returns a managed object, either newly created or retrieved from the data store based on `dictionary` and `entityName`.
 
 Relies on the incoming dictionary and the attribute names of the given entity following a number of conventions. 
 
 For the sake of clarity, assume that the given `dictionary` has been parsed from JSON retrieved from a web service, and will henceforth be referred to as the 'remote' data.
 The data store and managed object model will be referred to as the 'local' data.
 
 - The remote must use underscore case for its attributes; camel case must be used locally.
 - For remote attributes to be mirrored locally, the local attribute must use the same name as the remote attribute, adjusted for case. For example, `my_object_attribute` on the remote, and `myObjectAttribute` locally.
 - The value of remote attributes whose names would conflict with methods or properties on `NSObject` or `NSManagedObject` are stored locally with the prefix `remoteObject`. For example, `id` becomes `remoteObjectId` and `description` becomes `remoteObjectDescription`.
 
 This method first sets up an `NSFetchRequest` using `entityName`. The `NSPredicate` for this fetch request uses either `predicateKey`, or the object for the `id` key in `dictionary` if `predicateKey` is not given.
 
 If this fetch request returns an object, it is updated with the values from `dictionary`, including handling any relationship attributes. If no object is returned, a new managed object is created, and given the values from `dictionary`.
 
 Finally, the updated or created managed object is returned.
 
 @returns A managed object, either newly created or retrieved from the data store based on the dictionary and entityName provided.
 
 @param entityName The name of an entity present in the Managed Object Model.
 @param dictionary An NSDictionary representation of a managed object.
 @param predicateKey An attribute on the entity given in entityName to be used to determine if the object represented by dictionary is present in the data store. In the absence of this parameter, the key 'id' will be used.
 
 */

- (id)managedObjectWithEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)dictionary withPredicateKey:(NSString *)predicateKey
{
    id managedObject;

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    NSDictionary *reservedWords = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"id",           @"remoteObjectID", 
                                   @"description",  @"remoteObjectDescription",
                                   nil];
    
    NSDictionary *primaryKeys = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"name", @"IHLabel", 
                                 nil];
    
    id (^updateManagedObjectWithDictionary)(id, NSDictionary *);
    updateManagedObjectWithDictionary = ^(id theObject, NSDictionary *inputDictionary)
    {
        NSArray *attributeNames = [[[NSEntityDescription entityForName:NSStringFromClass([theObject class]) inManagedObjectContext:self] attributesByName] allKeys];
        for (NSString *attributeName in attributeNames)
        {
            if ([[reservedWords allKeys] containsObject:attributeName])
            {
                [theObject setValue:[inputDictionary objectForKey:[reservedWords objectForKey:attributeName]] forKey:attributeName];
            }
            else if ([[inputDictionary allKeys] containsObject:[attributeName toUnderscore]])
            {
                if (![[inputDictionary objectForKey:[attributeName toUnderscore]] isEqual:[NSNull null]])
                {
                    if ([[[[[NSEntityDescription entityForName:NSStringFromClass([theObject class]) inManagedObjectContext:self] attributesByName] objectForKey:attributeName] attributeValueClassName] isEqualToString:NSStringFromClass([NSDate class])])
                    {
                        [theObject setValue:[[inputDictionary objectForKey:[attributeName toUnderscore]] dateFromISO8601String] forKey:attributeName];
                    }
                    else
                    {
                        [theObject setValue:[inputDictionary objectForKey:[attributeName toUnderscore]] forKey:attributeName];
                    }
                }
            }
        }
        return theObject;
    };
    
    id (^updateManagedObjectRelationships)(NSManagedObject *, NSEntityDescription *);
    updateManagedObjectRelationships = ^(NSManagedObject *managedObject, NSEntityDescription *entityDescription)
    {
        for (NSString *relationshipName in [[entityDescription relationshipsByName] allKeys]) 
        {
            if ([[dictionary allKeys] containsObject:[relationshipName toUnderscore]]) 
            {
                NSRelationshipDescription *relationshipDescription = [[entityDescription relationshipsByName] objectForKey:relationshipName];
                
                if ([relationshipDescription isToMany])
                {
                    for (NSDictionary *objDictionary in [dictionary objectForKey:relationshipName])
                    {
                        id managedObjectForRelationship = [self managedObjectWithEntity:[relationshipDescription destinationEntity] dictionary:dictionary primaryKey:[primaryKeys objectForKey:[[relationshipDescription destinationEntity] name]]];
                        
                        if (!managedObjectForRelationship)
                        {
                            managedObjectForRelationship = [NSClassFromString([[relationshipDescription destinationEntity] name]) performSelector:@selector(insertInManagedObjectContext:) withObject:self];
                        }
                        
                        updateManagedObjectWithDictionary(managedObjectForRelationship, objDictionary);
                        
                        NSMutableSet *relationshipSet = [[managedObject valueForKey:relationshipName] mutableCopy];
                        if (relationshipSet != nil)
                        {
                            [relationshipSet addObject:managedObjectForRelationship];
                        }
                        else 
                        {
                            relationshipSet = [NSMutableSet setWithObject:managedObjectForRelationship];
                        }
                        [managedObject setValue:relationshipSet forKey:relationshipName];
                    }
                }
                else
                {
                    id managedObjectForRelationship = [NSClassFromString([[relationshipDescription destinationEntity] name]) performSelector:@selector(insertInManagedObjectContext:) withObject:self];
                    updateManagedObjectWithDictionary(managedObjectForRelationship, [dictionary objectForKey:relationshipName]);
                    
                    [managedObject setValue:managedObjectForRelationship forKey:relationshipName];   
                }
            }
        }
        return managedObject;
    };

    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    if (predicateKey && [dictionary objectForKey:[predicateKey toUnderscore]] != nil)
    {
        predicate = [NSPredicate predicateWithFormat:@"%@ LIKE %@", predicateKey, [dictionary objectForKey:[predicateKey toUnderscore]]];
    }
    else if ([[[entityDescription attributesByName] allKeys] containsObject:@"remoteObjectID"])
    {
        predicate = [NSPredicate predicateWithFormat:@"remoteObjectID == %@", [dictionary objectForKey:@"id"]];
    }
    
    [request setPredicate:predicate];
    
    if ([self countForFetchRequest:request error:nil] == 0)
    {        
        NSLog(@"Creating new NSManagedObject: %@", entityName);
        managedObject = [NSClassFromString(entityName) performSelector:@selector(insertInManagedObjectContext:) withObject:self];
        updateManagedObjectWithDictionary(managedObject, dictionary);   
    }
    else
    {
        NSLog(@"NSManagedObject retrieved from data store: %@", entityName);
        managedObject = [[self executeFetchRequest:request error:nil] objectAtIndex:0];
    }
    
    updateManagedObjectRelationships(managedObject, entityDescription);
    
    return managedObject;
}


- (id)managedObjectWithEntity:(NSEntityDescription *)entityDescription dictionary:(NSDictionary *)dictionary primaryKey:(NSString *)primaryKey
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:entityDescription];
    if (primaryKey)
    {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%@ LIKE %@", primaryKey, [dictionary objectForKey:[primaryKey toUnderscore]]]];        
    }
    else if ([[[entityDescription attributesByName] allKeys] containsObject:@"remoteObjectID"])
    {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"remoteObjectID == %@", [dictionary objectForKey:@"id"]]];
    }

    return [self countForFetchRequest:fetchRequest error:nil] ? [[self executeFetchRequest:fetchRequest error:nil] firstObject] : nil;
}

@end
