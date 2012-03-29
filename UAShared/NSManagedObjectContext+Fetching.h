//
//  NSManagedObjectContext+Fetching.h
//  UAShared
//
//  Created by Owain Hunt on 30/01/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

@interface NSManagedObjectContext (Fetching)

- (id)allEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (id)allEntities:(NSString *)entityName;

@end
