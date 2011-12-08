//
//  NSManagedObject+Utilities.h
//  
//
//  Created by Owain Hunt on 26/11/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//



@interface NSManagedObjectContext (Utilities)

/**

 Returns a managed object, either newly created or retrieved from the data store based on `dictionary` and `entityName`.
 
 Relies on the incoming dictionary and the attribute names of the given entity following a number of conventions. 
 
 For the sake of clarity, assume that the given `dictionary` has been parsed from JSON retrieved from a web service, and will henceforth be referred to as the 'remote' data.
 The data store and managed object model will be referred to as the 'local' data.
 
 - The remote must use underscore case for its attributes; camel case must be used locally.
 - For remote attributes to be mirrored locally, the local attribute must use the same name as the remote attribute, adjusted for case. For example, `my_object_attribute` on the remote, and `myObjectAttribute` locally.
 - The value of the remote `id` attribute is stored locally with the key `remoteObjectID`.
  
 This method first sets up an NSFetchRequest using `entityName`. The NSPredicate for this fetch request uses either `predicateKey`, or the object for the `id` key in `dictionary` if `predicateKey` is not given.
 
 If this fetch request returns an object, it is updated with the values from `dictionary`, including handling any relationship attributes. If no object is returned, a new managed object is created, and given the values from `dictionary`.
 
 Finally, the updated or created managed object is returned.

 @returns A managed object, either newly created or retrieved from the data store based on the dictionary and entityName provided.
 
 @param entityName The name of an entity present in the Managed Object Model.
 @param dictionary An NSDictionary representation of a managed object.
 @param predicateKey An attribute on the entity given in entityName to be used to determine if the object represented by dictionary is present in the data store. In the absence of this parameter, the key 'id' will be used.
 
 */

- (id)managedObjectWithEntityName:(NSString *)entityName fromDictionary:(NSDictionary *)dictionary withPredicateKey:(NSString *)predicateKey;

@end
