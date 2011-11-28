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
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    id managedObject;
    
    if ([self countForFetchRequest:request error:nil] == 0)
    {
        managedObject = [NSClassFromString(entityName) performSelector:@selector(insertInManagedObjectContext:) withObject:self];
        for (NSString *key in [[managedObject class] propertyKeys])
        {
            if ([[dictionary allKeys] containsObject:[key toUnderscore]])
            {
#pragma mark TODO if objectForKey isKindOfClass:[NSArray class] find or create MO with obj m
                [managedObject setValue:[dictionary objectForKey:[key toUnderscore]] forKey:key];
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
