//
//  NSAttributeDescription+ColumnTypes.h
//  Cloudbacked
//
//  Created by Owain Hunt on 09/02/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSAttributeDescription (ColumnTypes)

- (NSString *)attributeTypeAsRailsColumnType;

@end
