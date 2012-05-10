//
//  NSView+BadgeDrawing.m
//  UAShared
//
//  Created by Owain Hunt on 10/05/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import "NSView+BadgeDrawing.h"

@implementation NSView (BadgeDrawing)

- (void)drawBadgeInRect:(CGRect)badgeRect withString:(NSString *)string foregroundColor:(NSColor *)foregroundColor backgroundColor:(NSColor *)backgroundColor font:(NSFont *)font
{
    NSAttributedString *badgeAttrString = [[NSAttributedString alloc] initWithString:string attributes:
                                           @{                   NSFontAttributeName : (font) ?: [NSFont boldSystemFontOfSize:11],
                                                     NSForegroundColorAttributeName : (foregroundColor) ?: [NSColor whiteColor]
                                           }];
    
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:badgeRect xRadius:badgeRect.size.height/2 yRadius:badgeRect.size.height/2];
    (backgroundColor) ? [backgroundColor set] : [[NSColor colorWithCalibratedRed:0.6 green:0.65 blue:0.7 alpha:1.0] set];
    [path fill];
    
	NSSize stringSize = [badgeAttrString size];
	NSPoint badgeTextPoint = NSMakePoint(NSMidX(badgeRect)-(stringSize.width/2.0), NSMidY(badgeRect)-(stringSize.height/2.0));	
	[badgeAttrString drawAtPoint:badgeTextPoint];
    [context restoreGraphicsState];
    
}


- (void)drawBadgeInRect:(CGRect)badgeRect withString:(NSString *)string
{
    [self drawBadgeInRect:badgeRect withString:string foregroundColor:nil backgroundColor:nil font:nil];
}


- (NSSize)sizeOfBadgeWithString:(NSString *)string font:(NSFont *)font
{
    NSAttributedString *badgeAttrString = [[NSAttributedString alloc] initWithString:string attributes:
                                           @{                   NSFontAttributeName : (font) ?: [NSFont boldSystemFontOfSize:11]
                                           }
                                           ];
    CGSize badgeSize = [badgeAttrString size];
    CGFloat margin = 6;
    badgeSize.width += (margin * 2);
    return badgeSize;
}


@end
