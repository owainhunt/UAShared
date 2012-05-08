//
//  NSManagedObject+Utilities.m
//  
//
//  Created by Owain Hunt on 26/11/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//

/** 
 
 Extends `NSManagedObjectContext` for the purpose of working with external data, for example a web service. 
 
 Relies on the remote and local (Core Data) data stores following a number of structural and naming conventions. 
 
 - The remote must use underscore case for its attributes; camel case must be used locally.
 - For remote attributes to be mirrored locally, the local attribute must use the same name as the remote attribute, adjusted for case. For example, `my_object_attribute` on the remote, and `myObjectAttribute` locally.
 - The value of remote attributes whose names would conflict with methods or properties on `NSObject` or `NSManagedObject` are stored locally with the prefix `remoteObject`. For example, `id` becomes `remoteObjectId` and `description` becomes `remoteObjectDescription`.

 */

#import "NSManagedObjectContext+Utilities.h"
#import "NSString+Utilities.h"
#import "NSArray+Utilities.h"

@interface NSManagedObjectContext (Private)

- (id)updateManagedObject:(NSManagedObject *)obj withDictionary:(NSDictionary *)dictionary;
- (id)updateRelationshipsOnManagedObject:(NSManagedObject *)obj withDictionary:(NSDictionary *)dictionary;

@end

@implementation NSManagedObjectContext (Utilities)

- (id)updateManagedObject:(NSManagedObject *)obj withDictionary:(NSDictionary *)dictionary
{
    NSDictionary *attributeMap = [[NSEntityDescription entityForName:NSStringFromClass([obj class]) inManagedObjectContext:self] attributeMap];
    NSArray *attributeNames = [[[NSEntityDescription entityForName:NSStringFromClass([obj class]) inManagedObjectContext:self] attributesByName] allKeys];
    for (NSString *attributeName in attributeNames)
    {
        if ([[attributeMap allKeys] containsObject:attributeName] && !([[dictionary objectForKey:[attributeMap objectForKey:attributeName]] isEqual:[NSNull null]]))
        {
            [obj setValue:[dictionary objectForKey:[attributeMap objectForKey:attributeName]] forKey:attributeName];
        }
        else if ([[dictionary allKeys] containsObject:[attributeName toUnderscore]])
        {
            if (![[dictionary objectForKey:[attributeName toUnderscore]] isEqual:[NSNull null]])
            {
                if ([[[[[NSEntityDescription entityForName:NSStringFromClass([obj class]) inManagedObjectContext:self] attributesByName] objectForKey:attributeName] attributeValueClassName] isEqualToString:NSStringFromClass([NSDate class])])
                {
                    [obj setValue:[[dictionary objectForKey:[attributeName toUnderscore]] dateFromISO8601String] forKey:attributeName];
                }
                else
                {
                    [obj setValue:[dictionary objectForKey:[attributeName toUnderscore]] forKey:attributeName];
                }
            }
        }
    }
    return obj;
}


- (id)updateRelationshipsOnManagedObject:(NSManagedObject *)obj withDictionary:(NSDictionary *)dictionary
{
    NSEntityDescription *entityDescription = [obj entity];
    for (NSString *relationshipName in [[entityDescription relationshipsByName] allKeys]) 
    {
        if ([[dictionary allKeys] containsObject:[relationshipName toUnderscore]] && (![[dictionary objectForKey:[relationshipName toUnderscore]] isEqual:[NSNull null]]))
        {
            NSRelationshipDescription *relationshipDescription = [[entityDescription relationshipsByName] objectForKey:relationshipName];
            
            if ([relationshipDescription isToMany])
            {
                for (NSDictionary *objDictionary in [dictionary objectForKey:relationshipName])
                {
                    id managedObjectForRelationship = [self managedObjectWithEntity:[relationshipDescription destinationEntity] dictionary:objDictionary primaryKey:nil];
                    if (!managedObjectForRelationship)
                    {
                        managedObjectForRelationship = [NSClassFromString([[relationshipDescription destinationEntity] name]) performSelector:@selector(insertInManagedObjectContext:) withObject:self];
                    }
                    
                    id updatedObject = [self updateManagedObject:managedObjectForRelationship withDictionary:objDictionary];
                    
                    NSMutableSet *relationshipSet = [[obj valueForKey:relationshipName] mutableCopy];
                    if (relationshipSet != nil)
                    {
                        [relationshipSet addObject:updatedObject];
                    }
                    else 
                    {
                        relationshipSet = [NSMutableSet setWithObject:updatedObject];
                    }
                    [obj setValue:relationshipSet forKey:relationshipName];
                }
            }
            else
            {
                //                    id managedObjectForRelationship = [self managedObjectWithEntity:[relationshipDescription destinationEntity] dictionary:dictionary primaryKey:[primaryKeys objectForKey:[[relationshipDescription destinationEntity] name]]];
                id managedObjectForRelationship = [self managedObjectWithEntity:[relationshipDescription destinationEntity] dictionary:[dictionary objectForKey:relationshipName] primaryKey:nil];
                
                if (!managedObjectForRelationship)
                {
                    managedObjectForRelationship = [NSClassFromString([[relationshipDescription destinationEntity] name]) performSelector:@selector(insertInManagedObjectContext:) withObject:self];
                }
                
                id updatedObject = [self updateManagedObject:managedObjectForRelationship withDictionary:[dictionary objectForKey:relationshipName]];
                
                [obj setValue:updatedObject forKey:relationshipName];   
            }
        }
    }
    return obj;
}


- (id)updateSecondLevelRelationshipsOnManagedObject:(NSManagedObject *)obj withDictionary:(NSDictionary *)dictionary
{
    NSEntityDescription *entityDescription = [obj entity];
    for (NSString *relationshipName in [[entityDescription relationshipsByName] allKeys]) 
    {
        if ([[dictionary allKeys] containsObject:[relationshipName toUnderscore]])
        {
            NSString *dictionaryKey = [relationshipName toUnderscore];
            if ([[[entityDescription attributeMap] allKeys] containsObject:relationshipName])
            {
                dictionaryKey = [[entityDescription attributeMap] objectForKey:relationshipName];
            }
            [self updateRelationshipsOnManagedObject:[obj valueForKey:relationshipName] withDictionary:[dictionary objectForKey:dictionaryKey]];
        }
    }
    
    return obj;
}

/**
 
 Returns a managed object, either newly created or retrieved from the data store based on `dictionary` and `entityName`.
 
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
    NSDictionary *attributeMap = [entityDescription attributeMap];
//    NSDictionary *primaryKeys = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"name", @"IHLabel", 
//                                 @"login", @"IHRepository",
//                                 @"owner.login", @"IHIssue",
//                                 nil];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    if (predicateKey && [dictionary objectForKey:[predicateKey toUnderscore]] != nil)
    {
        predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", predicateKey, [dictionary objectForKey:[predicateKey toUnderscore]]];
    }
    else if (predicateKey && [[attributeMap allKeys] containsObject:predicateKey])
    {
        predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", predicateKey, [dictionary objectForKey:[attributeMap objectForKey:predicateKey]]];
    }
    else if ([[[entityDescription attributesByName] allKeys] containsObject:@"remoteObjectID"])
    {
        predicate = [NSPredicate predicateWithFormat:@"remoteObjectID == %@", [dictionary objectForKey:@"id"]];
    }
    
    [request setPredicate:predicate];
    
    if ([self countForFetchRequest:request error:nil] == 0)
    {        
        NSLog(@"Creating NSManagedObject: %@", entityName);
        managedObject = [NSClassFromString(entityName) performSelector:@selector(insertInManagedObjectContext:) withObject:self];
    }
    else
    {
        NSLog(@"Retrieving NSManagedObject: %@", entityName);
        managedObject = [[self executeFetchRequest:request error:nil] objectAtIndex:0];
    }

    [self updateManagedObject:managedObject withDictionary:dictionary];
    [self updateRelationshipsOnManagedObject:managedObject withDictionary:dictionary];
    [self updateSecondLevelRelationshipsOnManagedObject:managedObject withDictionary:dictionary];
      
    return managedObject;
}


- (id)managedObjectWithEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)dictionary withPredicateKey:(NSString *)predicateKey parentObject:(NSManagedObject *)parentObject
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    NSString *relationshipForParent = [[[entityDescription relationshipsWithDestinationEntity:(NSEntityDescription *)[parentObject entity]] firstObject] name];
    
    id managedObject = [self managedObjectWithEntityName:entityName fromDictionary:dictionary withPredicateKey:predicateKey];
    [managedObject setValue:parentObject forKey:relationshipForParent];
    return managedObject;
}


/**
 
 Returns a managed object, if one exists, based on the given `entityDescription`, `dictionary` and `primaryKey`.
 Uses the object for the `primaryKey` in `dictionary` as a predicate key. If `primaryKey` is nil and `remoteObjectID` is an attribute on the given entity, this key is used instead. If neither case is true, no predicate is used.
 
 @param entityDescription The entity description of the object to be found.
 @param dictionary An NSDictionary representation of the object to be found.
 @param primaryKey The key to be used in a predicate to restrict the fetch request.
 
 @return A managed object, or nil if an object matching the criteria cannot be found.
 
 */

- (id)managedObjectWithEntity:(NSEntityDescription *)entityDescription dictionary:(NSDictionary *)dictionary primaryKey:(NSString *)primaryKey
{
    if (!dictionary)
        return nil;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:entityDescription];
    if (primaryKey)
    {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K LIKE %@", primaryKey, [dictionary objectForKey:[primaryKey toUnderscore]]]];        
    }
    else if ([[[entityDescription attributesByName] allKeys] containsObject:@"remoteObjectID"])
    {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"remoteObjectID == %@", [dictionary objectForKey:@"id"]]];
    }
    else if ([[entityDescription attributeMap] valueForKey:@"primaryKey"])
    {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@", [dictionary objectForKey:[[entityDescription attributeMap] valueForKey:@"primaryKey"]]]];
    }

    NSLog(@"Find %@: %@: %lu %@", [entityDescription name], [[fetchRequest predicate] predicateFormat], [self countForFetchRequest:fetchRequest error:nil], dictionary);
    return [self countForFetchRequest:fetchRequest error:nil] ? [[self executeFetchRequest:fetchRequest error:nil] firstObject] : nil;
}


@end
