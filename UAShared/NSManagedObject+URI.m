//
//  NSManagedObject+URI.m
//  UAShared
//
//  Created by Owain Hunt on 13/01/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import "NSManagedObject+URI.h"
#import "NSString+Utilities.h"

@implementation NSManagedObject (URI)

- (NSString *)encodedURIPath
{
    return [[[[self objectID] URIRepresentation] path] encodedString];
}

@end
