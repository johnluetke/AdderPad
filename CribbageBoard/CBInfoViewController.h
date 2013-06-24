//
//  CBInfoViewController.h
//  CribbageBoard
//
//  Created by Tim Carlson on 5/13/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBNumberpad.h"

@interface CBInfoViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>
{
    CBNumberpad *numberpad;
    UITextField *maxScoreField;
    
    @private
        int charMax;
        BOOL soundButtonStatus;
        BOOL idleDisabled;
}

@property (nonatomic) BOOL *isSoundOn;
@property (nonatomic) BOOL *isIdleDisabled;
@property (nonatomic) IBOutlet id maxScoreField;
@property (nonatomic, weak) IBOutlet UILabel *webLabel;
@property (nonatomic, weak) IBOutlet UIButton *soundButton;
@property (nonatomic, weak) IBOutlet UIButton *idleButton;

// Labels
@property (nonatomic, weak) IBOutlet UILabel *maxScoreLabel;

- (IBAction)backToBoard:(id)sender;
- (IBAction)saveMaxScore:(id)sender;
- (IBAction)setSound:(id)sender;
- (IBAction)setIdleStatus:(id)sender;

// Numberpad Input
- (IBAction)press:(id)sender;

// Helper Methods
- (void)updateLabels;

@end
