//
//  NSButton+Spinner.h
//  UAShared
//
//  Created by Owain Hunt on 08/06/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSButton (Spinner)

- (void)showProgressIndicator;
- (void)hideProgressIndicatorWithTitle:(NSString *)newTitle;

@end
