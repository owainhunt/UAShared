//
//  NSManagedObject+Utilities.h
//  
//
//  Created by Owain Hunt on 26/11/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//

@interface NSManagedObjectContext (Utilities)

- (id)managedObjectWithEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)dictionary withPredicateKey:(NSString *)predicateKey;
- (id)managedObjectWithEntity:(NSEntityDescription *)entityDescription dictionary:(NSDictionary *)dictionary primaryKey:(NSString *)primaryKey;
- (id)JSONRepresentationForObject:(NSManagedObject *)managedObject;

@end
