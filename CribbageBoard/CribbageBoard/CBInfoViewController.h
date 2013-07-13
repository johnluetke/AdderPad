//
//  CBInfoViewController.h
//  CribbageBoard
//
//  Created by Tim Carlson on 5/13/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBNumberpad.h"

@interface CBInfoViewController : UIViewController <UITextFieldDelegate>
{
    CBNumberpad *numberpad;
    UITextField *maxScoreField;
    
    @private
        int charMax;
}

@property (nonatomic) IBOutlet id maxScoreField;

- (IBAction)backToBoard:(id)sender;

// Numberpad Input
- (IBAction) press:(id)sender;

@end
