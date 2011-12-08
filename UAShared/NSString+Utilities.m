//
//  NSString+Utilities.m
//  
//
//  Created by Owain Hunt on 26/11/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (NSString *)toCamelCase
{
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0; idx < [self length]; idx += 1) 
    {
        unichar c = [self characterAtIndex:idx];
        if (c == '_') 
        {
            makeNextCharacterUpperCase = YES;
        } 
        else if (makeNextCharacterUpperCase) 
        {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } 
        else 
        {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}


- (NSString *)toUnderscore
{
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSInteger idx = 0; idx < [self length]; idx += 1) 
    {
        unichar c = [self characterAtIndex:idx];
        if ([uppercase characterIsMember:c]) 
        {
            [output appendFormat:@"_%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
        } 
        else 
        {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}


- (NSString *)encodedString
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@";/?:@&=$+{}<>,", kCFStringEncodingUTF8);
    
}


- (NSDate *)dateFromISO8601String 
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];    
    return [df dateFromString:self];   
}



@end
