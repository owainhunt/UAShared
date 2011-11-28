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
//http://stackoverflow.com/questions/2299841/objective-c-introspection-reflection

+ (NSArray *)propertyKeys
{
    __block NSMutableArray *propertyArray = [NSMutableArray array];
    
    void (^theBlock)(Class klass);    
    theBlock = ^(Class klass) {
        u_int count;
        objc_property_t* properties = class_copyPropertyList(klass, &count);
        for (int i = 0; i < count ; i++)
        {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        free(properties);
    };
    
    theBlock([self class]);
    
    Class superClass = class_getSuperclass([self class]);    
    if (superClass != nil && ![superClass isEqual:[NSObject class]] && [[NSStringFromClass(superClass) substringToIndex:1] isEqual:@"_"])
    {
        theBlock(class_getSuperclass([self class]));
    }
    
    return propertyArray;
    
}


@end
