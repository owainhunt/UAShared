//
//  NSManagedObjectContext+Fetching.h
//  UAShared
//
//  Created by Owain Hunt on 30/01/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

@interface NSManagedObjectContext (ORHFetching)

- (id)allEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (id)allEntities:(NSString *)entityName;
- (NSInteger)countAllEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (NSInteger)countAllEntities:(NSString *)entityName;

@end
