//
//  UAPrefix.h
//  RecTest
//
//  Created by Owain Hunt on 08/01/2011.
//  Copyright 2011 Owain R Hunt. All rights reserved.
//

#ifdef DEBUG
#    define UALog(fmt, ...) NSLog(@"%s:%d (%s): " fmt, __FILE__, __LINE__, __func__, ## __VA_ARGS__)
#else
#    define UALog(...) /* */
#endif

// https://github.com/Machx/Zangetsu/blob/master/Source/CWMacros.h

#define UAIBOutletAssert(_x_) \
    do { \
        if(_x_ == nil) { \
            UALog(@"IBOutlet Assertion: %s is nil and appears to not be hooked up!",#_x_); \
        } \
    } while(0);

