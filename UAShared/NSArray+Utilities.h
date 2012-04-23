//
//  NSArray+Utilities.h
//  UAShared
//
//  Created by Owain Hunt on 07/12/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//



@interface NSArray (Utilities)

- (id)firstObject;
- (NSArray *)sortedWithKey:(NSString *)theKey ascending:(BOOL)ascending;
- (NSArray *)uniqueObjects;


@end
