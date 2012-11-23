//
//  UAShared.h
//  UAShared
//
//  Created by Owain Hunt on 02/04/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#if __MAC_OS_X_VERSION_MIN_REQUIRED
    #import "NSView+Utilities.h"
    #import "NSView+BadgeDrawing.h"
    #import "NSButton+Spinner.h"
    #import "NSSearchField+Spinner.h"
    #import "NSData+Base64.h"
#endif

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "NSManagedObjectContext+Fetching.h"
#import "NSAttributeDescription+ColumnTypes.h"
#import "NSManagedObject+JSON.h"
#import "NSManagedObject+URI.h"
#import "NSManagedObjectContext+Utilities.h"
#import "NSObject+Utilities.h"
#import "NSDate+Utilities.h"
#import "NSString+Utilities.h"
#import "NSArray+Utilities.h"
#import "NSNumber+StringUtilities.h"

#ifdef DEBUG
#    define UALog(fmt, ...) NSLog(@"%s:%d (%s): " fmt, __FILE__, __LINE__, __func__, ## __VA_ARGS__)
#else
#    define UALog(...)
#endif

#define swf(fmt, ...) [NSString stringWithFormat:fmt, ## __VA_ARGS__]

// https://github.com/Machx/Zangetsu/blob/master/Source/CWMacros.h

#define UAIBOutletAssert(_x_) \
do { \
if(_x_ == nil) { \
UALog(@"IBOutlet Assertion: %s is nil and appears to not be hooked up!",#_x_); \
} \
} while(0);

#define unless(x) if(!x)
#define until(x) while(!x)
