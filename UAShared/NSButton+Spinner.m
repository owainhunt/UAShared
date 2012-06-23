//
//  NSButton+Spinner.m
//  UAShared
//
//  Created by Owain Hunt on 08/06/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import "NSButton+Spinner.h"

@implementation NSButton (Spinner)

- (void)showProgressIndicator
{
    CGRect frame = self.bounds;
    CGFloat sideLength = 10;
    CGFloat yPosModifier = 1;
    if ([self.cell controlSize] == NSRegularControlSize)
    {
        sideLength = 16;
        yPosModifier = 2;
    }
    CGRect spinnerFrame = CGRectMake(NSMidX(frame) - (sideLength/2), NSMidY(frame) - (sideLength/2) - yPosModifier, sideLength, sideLength);
    NSProgressIndicator *spinner = [[NSProgressIndicator alloc] initWithFrame:spinnerFrame];
    spinner.style = NSProgressIndicatorSpinningStyle;
    if ([self.cell controlSize] == NSRegularControlSize)
    {
        spinner.controlSize = NSSmallControlSize;
    }
    else
    {
        spinner.controlSize = NSMiniControlSize;
    }
    [spinner startAnimation:self];
    [self addSubview:spinner];
    self.state = NSOnState;
    self.title = @"";
    self.image = nil;
    self.enabled = NO;
}


- (void)hideProgressIndicatorWithTitle:(NSString *)newTitle
{
    NSArray *subviews = [self subviews];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSProgressIndicator class]])
        {
            [obj removeFromSuperview];
            *stop = YES;
        }
    }];
    self.state = NSOffState;
    self.title = newTitle;
    self.enabled = YES;
}


- (void)hideProgressIndicatorWithImage:(NSImage *)newImage
{
    NSArray *subviews = [self subviews];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSProgressIndicator class]])
        {
            [obj removeFromSuperview];
            *stop = YES;
        }
    }];
    self.state = NSOffState;
    self.image = newImage;
    self.enabled = YES;
}

@end
