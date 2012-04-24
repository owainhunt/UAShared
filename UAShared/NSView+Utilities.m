//
//  NSView+Utilities.m
//  IssuesHub
//
//  Created by Owain Hunt on 16/09/2010.
//  Copyright 2010 Owain R Hunt. All rights reserved.
//

#import "NSView+Utilities.h"


@implementation NSView (Utilities)

- (void)animateToVisible:(BOOL)visible;
{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0f]
					 forKey:kCATransactionAnimationDuration];
	[[self animator] setAlphaValue:(visible ? 1.0 : 0.0)];
	[CATransaction commit];
}


@end
