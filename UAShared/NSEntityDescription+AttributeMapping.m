//
//  NSEntityDescription+AttributeMapping.m
//  UAShared
//
//  Created by Owain Hunt on 02/04/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import "NSEntityDescription+AttributeMapping.h"

@implementation NSEntityDescription (AttributeMapping)

- (NSDictionary *)attributeMap
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *attributeMappingFilename = [NSString stringWithFormat:@"%@AttributeMap", [self name]];
    plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", attributeMappingFilename]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
    {
        plistPath = [[NSBundle mainBundle] pathForResource:attributeMappingFilename ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *reservedWords = (NSDictionary *)[NSPropertyListSerialization
                                                   propertyListFromData:plistXML
                                                   mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                   format:&format
                                                   errorDescription:&errorDesc];
    
    return reservedWords;

}


@end
