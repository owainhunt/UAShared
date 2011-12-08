//
//  NSManagedObject+Utilities.m
//  
//
//  Created by Owain Hunt on 26/11/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//

#import "NSManagedObjectContext+Utilities.h"

@implementation NSManagedObjectContext (Utilities)

- (id)managedObjectWithEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)dictionary withPredicateKey:(NSString *)predicateKey
{
    id managedObject;

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    
    id (^updateManagedObjectWithDictionary)(id, NSDictionary *);
    updateManagedObjectWithDictionary = ^(id theObject, NSDictionary *inputDictionary)
    {
        NSArray *attributeNames = [[[NSEntityDescription entityForName:NSStringFromClass([theObject class]) inManagedObjectContext:self] attributesByName] allKeys];
        for (NSString *attributeName in attributeNames)
        {
            if ([attributeName isEqual:@"remoteObjectID"])
            {
                [theObject setValue:[inputDictionary objectForKey:@"id"] forKey:@"remoteObjectID"];
            }
            else if ([[inputDictionary allKeys] containsObject:[attributeName toUnderscore]])
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
        return theObject;
    };
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate;
    if (predicateKey && [dictionary objectForKey:[predicateKey toUnderscore]] != nil)
    {
        predicate = [NSPredicate predicateWithFormat:@"%@ LIKE %@", predicateKey, [dictionary objectForKey:[predicateKey toUnderscore]]];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"remoteObjectID == %@", [dictionary objectForKey:@"id"]];
    }
    
    [request setPredicate:predicate];
    
    if ([self countForFetchRequest:request error:nil] == 0)
    {        
        managedObject = [NSClassFromString(entityName) performSelector:@selector(insertInManagedObjectContext:) withObject:self];
        updateManagedObjectWithDictionary(managedObject, dictionary);
        
        for (NSString *relationshipName in [[entityDescription relationshipsByName] allKeys]) 
        {
            if ([[dictionary allKeys] containsObject:[relationshipName toUnderscore]]) 
            {
                NSRelationshipDescription *relationshipDescription = [[entityDescription relationshipsByName] objectForKey:relationshipName];
                id managedObjectForRelationship = [NSClassFromString([[relationshipDescription destinationEntity] name]) performSelector:@selector(insertInManagedObjectContext:) withObject:self];
                updateManagedObjectWithDictionary(managedObjectForRelationship, [dictionary objectForKey:relationshipName]);
                
                if ([relationshipDescription isToMany]) 
                {
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
                else
                {
                    [managedObject setValue:managedObjectForRelationship forKey:relationshipName];
                }
            }
        }
    }
    else
    {
        managedObject = [[self executeFetchRequest:request error:nil] objectAtIndex:0];
    }
    
    return managedObject;
}

@end
