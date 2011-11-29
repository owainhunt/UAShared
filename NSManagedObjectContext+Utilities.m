//
//  NSManagedObject+Utilities.m
//  
//
//  Created by Owain Hunt on 26/11/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//

#import "NSManagedObjectContext+Utilities.h"

@implementation NSManagedObjectContext (Utilities)

- (id)managedObjectWithEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)dictionary
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
#pragma mark TODO Predicate (-managedObjectWithEntityName:fromDictionary:withPredicateKeys: ?)
    
    id managedObject;

    id (^createObjectOfType)(Class, NSDictionary *);
    createObjectOfType = ^(Class klass, NSDictionary *inputDictionary)
    {
        NSEntityDescription *entityDescriptionForNewObject = [NSEntityDescription entityForName:NSStringFromClass(klass) inManagedObjectContext:self];
        id aManagedObject = [klass performSelector:@selector(insertInManagedObjectContext:) withObject:self];
        
        for (NSString *attributeName in [[entityDescriptionForNewObject attributesByName] allKeys])
        {
            if ([[inputDictionary allKeys] containsObject:[attributeName toUnderscore]])
            {
                [aManagedObject setValue:[inputDictionary objectForKey:[attributeName toUnderscore]] forKey:attributeName];
            }
        }
        
        return aManagedObject;

    };
    
    
    if ([self countForFetchRequest:request error:nil] == 0)
    {        
        managedObject = createObjectOfType(NSClassFromString(entityName), dictionary);
        
        for (NSString *relationshipName in [[entityDescription relationshipsByName] allKeys]) 
        {
            if ([[dictionary allKeys] containsObject:[relationshipName toUnderscore]]) 
            {
                NSRelationshipDescription *relationshipDescription = [[entityDescription relationshipsByName] objectForKey:relationshipName];
                id managedObjectForRelationship = createObjectOfType(NSClassFromString([[relationshipDescription destinationEntity] name]), [dictionary objectForKey:relationshipName]);
                
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
