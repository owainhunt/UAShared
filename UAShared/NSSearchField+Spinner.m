//
//  NSSearchField+Spinner.m
//  UAShared
//
//  Created by Owain Hunt on 06/09/2012.
//  Copyright (c) 2012 Owain R Hunt. All rights reserved.
//

#import "NSSearchField+Spinner.h"

@implementation NSSearchField (Spinner)

- (void)showProgressIndicator
{
    NSArray *subviews = [self.superview subviews];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSProgressIndicator class]])
        {
            [obj removeFromSuperview];
            *stop = YES;
            return;
        }
    }];

    int xPos = NSMaxX(self.frame) - 16;
    int yPos = NSMidY(self.frame) - 6;
    CGRect spinnerFrame = CGRectMake(xPos, yPos, 13, 13);
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
    ((NSSearchFieldCell *)self.cell).cancelButtonCell = nil;
    [spinner startAnimation:self];
    [self.superview addSubview:spinner positioned:NSWindowAbove relativeTo:self];
}


- (void)hideProgressIndicator
{
    NSArray *subviews = [self.superview subviews];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSProgressIndicator class]])
        {
            [obj removeFromSuperview];
            [self.cell resetCancelButtonCell];
            *stop = YES;
        }
    }];
}


@end
