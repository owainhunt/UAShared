//
//  NSObject+Utilities.m
//  
//
//  Created by Owain Hunt on 26/11/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//

#import "NSObject+Utilities.h"

@implementation NSObject (Utilities)

//http://stackoverflow.com/questions/780897/how-do-i-find-all-the-property-keys-of-a-kvc-compliant-objective-c-object
+ (NSArray *)propertyKeysForClass:(Class)className
{
    unsigned int outCount, i;
    NSMutableArray *array;
    objc_property_t *properties = class_copyPropertyList([className class], &outCount);
    for(i = 0; i < outCount; i++) 
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) 
        {
            [array addObject:[NSString stringWithUTF8String:propName]];
        }
    }
    free(properties);
    
    return array;
}


/*
 - (id)repositoryWithDictionary:(NSDictionary *)dictionary
 {
 NSFetchRequest *request = [NSFetchRequest repositoryRequestWithDictionary:dictionary inContext:self];
 
 IHRepository *aRepository;
 
 if ([self countForFetchRequest:request error:nil] == 0)
 {
 aRepository = [IHRepository insertInManagedObjectContext:self];
 aRepository.name = [dictionary objectForKey:@"name"];
 aRepository.owner = [self userWithDictionary:[NSDictionary dictionaryWithObject:[dictionary objectForKey:@"owner"] forKey:IHLoginKey]];
 aRepository.createdAt = [dictionary objectForKey:@"created_at"];
 aRepository.hasIssues = [dictionary objectForKey:@"has_issues"];
 aRepository.cOpenIssues = [dictionary objectForKey:@"open_issues"];
 
 }
 else
 {
 aRepository = [[self executeFetchRequest:request error:nil] firstObject];
 }
 
 if ([[dictionary allKeys] containsObject:@"open_issues"])
 {
 aRepository.cOpenIssues = [dictionary objectForKey:@"open_issues"];
 }
 
 return aRepository;
 
 }
 */


+ (id)managedObjectWithEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)dictionary
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName context:self]];
    
    id managedObject;
    
    if ([self countForFetchRequest:request error:nil] == 0)
    {
        managedObject = [[NSClassFromString entityName] insertInManagedObjectContext:self];
        for (NSString *key in [NSObject propertyKeysForClass:[NSClassFromString entityName]])
        {
            if ([[dictionary allKeys] containsObject:[key toUnderscore]])
            {
                [managedObject setValue:[dictionary objectForKey:[key toUnderscore]] forKey:key];
            }
        }
    }
    else
    {
        managedObject = [[self countForFetchRequest:request error:nil] objectAtIndex:0];
    }
    
    return managedObject;
}


@end
