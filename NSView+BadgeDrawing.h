//
//  NSView+BadgeDrawing.h
//  UAShared
//
//  Created by Owain Hunt on 10/05/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (BadgeDrawing)

- (void)drawBadgeInRect:(CGRect)badgeRect withString:(NSString *)string foregroundColor:(NSColor *)foregroundColor backgroundColor:(NSColor *)backgroundColor font:(NSFont *)font;
- (NSSize)sizeOfBadgeWithString:(NSString *)string font:(NSFont *)font;

@end
