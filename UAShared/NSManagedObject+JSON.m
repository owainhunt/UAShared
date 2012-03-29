//
//  NSManagedObject+JSON.m
//  UAShared
//
//  Created by Owain Hunt on 04/02/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import "NSManagedObject+JSON.h"
#import "NSManagedObject+URI.h"
#import "NSString+Utilities.h"
#import "NSDate+Utilities.h"

@implementation NSManagedObject (JSON)

/**
 
 Returns a JSON representation of a managed object, based on the rules set forth in the class discussion.
 
 @returns A JSON representation of the given managed object 
 @param managedObject A managed object.
 
 */

- (id)JSONRepresentation
{
    NSMutableDictionary *managedObjectAsDictionary = [NSMutableDictionary new];
    
    NSDictionary *reservedWords = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"id",           @"remoteObjectID", 
                                   @"description",  @"remoteObjectDescription",
                                   nil];
    
    
    NSMutableDictionary *(^attributesForManagedObject)(id, NSEntityDescription *);
    attributesForManagedObject = ^(id obj, NSEntityDescription *entity)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary new];
        NSArray *attributeNames = [[entity attributesByName] allKeys];
        
        for (NSString *attributeName in attributeNames)
        {
            NSAttributeDescription *attributeDescription = [[entity attributesByName] objectForKey:attributeName];
            NSString *attributeNameAsDictionaryKey;
            
            if ([[reservedWords allKeys] containsObject:attributeName])
            {
                attributeNameAsDictionaryKey = [reservedWords objectForKey:attributeName];
            }
            else 
            {
                attributeNameAsDictionaryKey = [attributeName toUnderscore];
            }
            
            switch ([attributeDescription attributeType]) 
            {
                case NSDateAttributeType:
                    [dictionary setValue:[[self valueForKey:attributeName] ISO8601StringFromDate] forKey:attributeNameAsDictionaryKey];
                    break;
                    
                default:
                    [dictionary setValue:[self valueForKey:attributeName] forKey:attributeNameAsDictionaryKey];
                    break;
            }
            
        }
        
        return dictionary;
    };   
    
    managedObjectAsDictionary = attributesForManagedObject(self, [self entity]);
    
    for (NSString *relationshipName in [[self entity] relationshipsByName])
    {
        NSString *relationshipNameAsDictionaryKey;
        
        if ([[reservedWords allKeys] containsObject:relationshipName])
        {
            relationshipNameAsDictionaryKey = [reservedWords objectForKey:relationshipName];
        }
        else 
        {
            relationshipNameAsDictionaryKey = [relationshipName toUnderscore];
        }
        
        NSRelationshipDescription *relationship = [[[self entity] relationshipsByName] objectForKey:relationshipName];
        if ([relationship isToMany])
        {
            NSMutableArray *relationshipObjects = [NSMutableArray array];
            for (id obj in [self valueForKey:relationshipName])
            {
                [relationshipObjects addObject:attributesForManagedObject(obj, [obj entity])];
            }
            
            [managedObjectAsDictionary setValue:relationshipObjects forKey:relationshipNameAsDictionaryKey];
        }
        else
        {
            [managedObjectAsDictionary setValue:attributesForManagedObject([self valueForKey:relationshipName], [relationship destinationEntity]) forKey:relationshipNameAsDictionaryKey];
        }
    }
    [managedObjectAsDictionary setValue:[self encodedURIPath] forKey:@"identifier_string"];
    
    return [NSJSONSerialization dataWithJSONObject:managedObjectAsDictionary options:NSJSONWritingPrettyPrinted error:nil];
}

@end
