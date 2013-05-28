//
//  CAHAppDelegate.h
//  Cards Against Humanity
//
//  Created by Tim Carlson on 1/21/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAHViewController;

@interface CAHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CAHViewController *viewController;

@end
