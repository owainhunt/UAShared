//
//  NSAttributeDescription+ColumnTypes.m
//  Cloudbacked
//
//  Created by Owain Hunt on 09/02/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import "NSAttributeDescription+ColumnTypes.h"

@implementation NSAttributeDescription (ColumnTypes)

- (NSString *)attributeTypeAsRailsColumnType
{
    switch ([self attributeType])
    {
        case NSInteger16AttributeType:
        case NSInteger32AttributeType:
        case NSInteger64AttributeType:
            return @"integer";
            break;
            
        case NSDecimalAttributeType:
            return @"decimal";
            break;
            
        case NSFloatAttributeType:
            return @"float";
            break;
            
        case NSStringAttributeType:
            return @"string";
            break;
            
        case NSBooleanAttributeType:
            return @"boolean";
            break;
            
        case NSDateAttributeType:
            return @"datetime";
            break;
            
        case NSBinaryDataAttributeType:
            return @"binary";
            break;
            
        default:
            return nil;
            break;
    }
}

@end
