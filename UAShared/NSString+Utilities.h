//
//  NSString+Utilities.h
//  
//
//  Created by Owain Hunt on 26/11/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//



@interface NSString (Utilities)

//https://github.com/peterdeweese/es_ios_utils/blob/master/es_ios_utils/ios/ESNSCategories.m
//http://stackoverflow.com/questions/1918972/camelcase-to-underscores-and-back-in-objective-c

- (NSString *)toCamelCase;
- (NSString *)toUnderscore;
- (NSString *)encodedString;
- (NSDate *)dateFromISO8601String;


@end
