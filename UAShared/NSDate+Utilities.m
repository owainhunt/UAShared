//
//  NSDate+Utilities.m
//  UAShared
//
//  Created by Owain Hunt on 19/12/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

- (NSString *)ISO8601StringFromDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];     
    return [df stringFromDate:self];
}


- (NSString *)mediumFormatDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    return [df stringFromDate:self];
}

@end
