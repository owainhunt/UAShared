//
//  NSManagedObjectContext+Fetching.m
//  UAShared
//
//  Created by Owain Hunt on 30/01/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import "NSManagedObjectContext+Fetching.h"

@implementation NSManagedObjectContext (ORHFetching)

- (id)allEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
  
    if (predicate)
    {
        [request setPredicate:predicate];
    }
    
    NSError *fetchError;
//    NSLog(@"Returned %lu objects for entity %@", [self countForFetchRequest:request error:nil], entityName);
    return [self executeFetchRequest:request error:&fetchError];
}


- (id)allEntities:(NSString *)entityName
{
    return [self allEntities:entityName withPredicate:nil];
}


- (NSInteger)countAllEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    if (predicate)
    {
        [request setPredicate:predicate];
    }
    
    NSError *fetchError;
    return [self countForFetchRequest:request error:&fetchError];
}


- (NSInteger)countAllEntities:(NSString *)entityName
{
    return [self countAllEntities:entityName withPredicate:nil];
}

@end
