//
//  NSManagedObject+URI.h
//  UAShared
//
//  Created by Owain Hunt on 13/01/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (URI)

- (NSString *)encodedURIPath;

@end
