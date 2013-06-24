//
//  CBPopup.h
//  CribbageBoard
//
//  Created by Tim Carlson on 6/24/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//
//  @class CBPopup
//  This class displays a timed popup with a message.  Alternative to
//  UIAlertView, in that it does not require a user touch to dismiss.
//

#import <UIKit/UIKit.h>

@interface CBPopup : UILabel
{
    
}

- (id)initWithText: (NSString*) msg;

@end
