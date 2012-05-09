//
//  NSNumber+StringUtilities.m
//  UAShared
//
//  Created by Owain Hunt on 09/05/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import "NSNumber+StringUtilities.h"

@implementation NSNumber (StringUtilities)

- (NSString *)stringValueIfGreaterThanZero
{
    return [self intValue] ? [self stringValue] : nil;
}

@end
