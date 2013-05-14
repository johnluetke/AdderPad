//
//  CBSwitchViewController.h
//  CribbageBoard
//
//  Created by Tim Carlson on 5/13/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class CBBoardViewController;
@class CBInfoViewController;

@interface CBSwitchViewController : UIViewController
{
    CBBoardViewController *boardVC;
    CBInfoViewController *infoVC;
}
@property (retain, nonatomic) CBBoardViewController *boardVC;
@property (retain, nonatomic) CBInfoViewController *infoVC;

+ (void)switchToBoard;
+ (void)switchToInfo;

@end
