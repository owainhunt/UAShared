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
    NSString *classPrefix = @"UAPOS";
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
#pragma mark TODO Predicate (-managedObjectWithEntityName:fromDictionary:withPredicateKeys: ?)
    
    __block NSMutableArray *arrayKeys = [NSMutableArray array];
    __block NSMutableArray *dictionaryKeys = [NSMutableArray array];
    id managedObject;

    id (^createObjectOfType)(Class klass, NSDictionary *inputDictionary);
    createObjectOfType = ^(Class klass, NSDictionary *inputDictionary)
    {
        id aManagedObject = [klass performSelector:@selector(insertInManagedObjectContext:) withObject:self];
        for (NSString *key in [[aManagedObject class] propertyKeys])
        {
            if ([[inputDictionary allKeys] containsObject:[key toUnderscore]])
            {
                if([[inputDictionary objectForKey:[key toUnderscore]] isKindOfClass:[NSArray class]])
                {
                    [arrayKeys addObject:key];
                }
                else if ([[inputDictionary objectForKey:[key toUnderscore]] isKindOfClass:[NSDictionary class]])
                {
                    [dictionaryKeys addObject:key];
                }
                else
                {
                    [aManagedObject setValue:[inputDictionary objectForKey:[key toUnderscore]] forKey:key];
                }
            }
        }
        
        return aManagedObject;

    };
    
    
    if ([self countForFetchRequest:request error:nil] == 0)
    {        
        managedObject = createObjectOfType(NSClassFromString(entityName), dictionary);
        /*
        // Loop over dictionaryKeys and create/find MO for each object
        for (NSString *dictionaryKey in dictionaryKeys) {
            NSString *derivedEntityName = [NSString stringWithFormat:@"%@%@", classPrefix, [dictionaryKey substringToIndex:[dictionaryKey length]-1]];
            NSFetchRequest *aRequest = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:derivedEntityName inManagedObjectContext:self]];
            id aManagedObject;
            
            if ([self countForFetchRequest:aRequest error:nil] == 0)
            {
                aManagedObject = createObjectOfType(NSClassFromString(entityName), [dictionary objectForKey:dictionaryKey]);
            }
        }*/
    }
    else
    {
        managedObject = [[self executeFetchRequest:request error:nil] objectAtIndex:0];
    }
    
    return managedObject;
}

@end
