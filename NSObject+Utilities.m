//
//  NSObject+Utilities.m
//  
//
//  Created by Owain Hunt on 26/11/2011.
//  Copyright (c) 2011 Owain R Hunt. All rights reserved.
//

#import "NSObject+Utilities.h"

@implementation NSObject (Utilities)

//http://stackoverflow.com/questions/780897/how-do-i-find-all-the-property-keys-of-a-kvc-compliant-objective-c-object
+ (NSArray *)propertyKeysForClass:(Class)className
{
    unsigned int outCount, i;
    NSMutableArray *array;
    objc_property_t *properties = class_copyPropertyList([className class], &outCount);
    for(i = 0; i < outCount; i++) 
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) 
        {
            [array addObject:[NSString stringWithUTF8String:propName]];
        }
    }
    free(properties);
    
    return array;
}


@end
