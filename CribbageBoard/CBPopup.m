//
//  CBPopup.m
//  CribbageBoard
//
//  Created by Tim Carlson on 6/24/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import "CBPopup.h"
#import <QuartzCore/QuartzCore.h>

@implementation CBPopup

#define POPUP_DELAY  1.5

- (id)initWithText: (NSString*)msg
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:106.0/255.0 blue:67.0/255.0 alpha:0.9];
//        self.textColor = [UIColor colorWithRed:198.0/255.0 green:202.0/255.0 blue:168.0/255.0 alpha:1.0];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont fontWithName: @"Trebuchet-MS" size: 13];
        self.text = msg;
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (void)didMoveToSuperview {
    
    UIView* parent = self.superview;
    
    if(parent) {
        
        CGSize maximumLabelSize = CGSizeMake(300, 200);
        CGSize expectedLabelSize = [self.text sizeWithFont: self.font  constrainedToSize:maximumLabelSize lineBreakMode: NSLineBreakByTruncatingTail];
        
        expectedLabelSize = CGSizeMake(expectedLabelSize.width + 20, expectedLabelSize.height + 10);
        
        self.frame = CGRectMake(parent.center.x - expectedLabelSize.width/2,
                                (parent.bounds.size.height / 2)-expectedLabelSize.height + 0,
                                expectedLabelSize.width,
                                expectedLabelSize.height);
        
        CALayer *layer = self.layer;
        layer.cornerRadius = 4.0f;
        
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:POPUP_DELAY];
    }
}

- (void)dismiss:(id)sender {
    // Fade out the message and destroy self
    [UIView animateWithDuration:0.6  delay:0 options: UIViewAnimationOptionAllowUserInteraction
                     animations:^  { self.alpha = 0; }
                     completion:^ (BOOL finished) { [self removeFromSuperview]; }];
}

@end
