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
    CGPoint center;
    center.x = NSMidX(frame);
    center.y = NSMidY(frame);
    CGRect spinnerFrame = CGRectMake(center.x - 5, center.y - 6, frame.size.width, 10);
    NSProgressIndicator *spinner = [[NSProgressIndicator alloc] initWithFrame:spinnerFrame];
    spinner.style = NSProgressIndicatorSpinningStyle;
    spinner.controlSize = NSMiniControlSize;
    [spinner startAnimation:self];
    [self addSubview:spinner];
    self.state = NSOnState;
    self.title = @"";
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
}

@end
