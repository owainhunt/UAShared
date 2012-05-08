//
//  NSManagedObject+Utilities.h
//  
//
//  Created by Owain Hunt on 26/11/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//

@interface NSManagedObjectContext (Utilities)

- (id)managedObjectWithEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)dictionary withPredicateKey:(NSString *)predicateKey havingRelatedObject:(NSManagedObject *)relatedObject forRelationship:(NSString *)relationshipName;
- (id)managedObjectWithEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)dictionary withPredicateKey:(NSString *)predicateKey;
- (id)managedObjectWithEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)dictionary withPredicateKey:(NSString *)predicateKey parentObject:(NSManagedObject *)parentObject;
- (id)managedObjectWithEntity:(NSEntityDescription *)entityDescription dictionary:(NSDictionary *)dictionary primaryKey:(NSString *)primaryKey;

@end
