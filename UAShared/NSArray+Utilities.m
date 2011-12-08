//
//  NSArray+Utilities.m
//  UAShared
//
//  Created by Owain Hunt on 07/12/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//

#import "NSArray+Utilities.h"

@implementation NSArray (Utilities)

- (id)firstObject
{
    if ([self count] > 0)
    {
        return [self objectAtIndex:0];
    }
    return nil;
}


- (NSArray *)sortedWithKey:(NSString *)theKey ascending:(BOOL)ascending 
{
    return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:theKey ascending:ascending selector:@selector(caseInsensitiveCompare:)]]];
}


@end
