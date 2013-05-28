//
//  TouchViewController.m
//  TouchTracker
//
//  Created by Tim Carlson on 3/29/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import "TouchViewController.h"
#import "TouchDrawView.h"

@implementation TouchViewController

// Override loadView to set up an instance of TouchDrawView as TouchViewController's view
- (void)loadView
{
    [self setView:[[TouchDrawView alloc] initWithFrame:CGRectZero]];
}

@end
