//
//  CBBoardViewController.h
//  CribbageBoard
//
//  Created by Tim Carlson on 5/7/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"
#import "CBNumberpad.h"

@interface CBBoardViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>
{
    //__weak IBOutlet UITextField *addToScoreField;
    CBNumberpad *numberpad;
    UITextField *addToScoreField;
    
    @private
    int charMax;
}

@property (nonatomic) IBOutlet id addToScoreField;

// Labels
@property (nonatomic, weak) IBOutlet UILabel *redScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *greenScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *blueScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *yellowScoreLabel;

// Data
@property (assign) int32_t redScore;
@property (assign) int32_t greenScore;
@property (assign) int32_t blueScore;
@property (assign) int32_t pointsEntered;
@property (assign) int32_t playTo;

@property (assign) int lastPlayerTag;  // 0=red, 1=green, 2=blue
@property (retain) NSMutableArray *redData;
@property (retain) NSMutableArray *greenData;
@property (retain) NSMutableArray *blueData;

// Progress Bars
@property (weak, nonatomic) IBOutlet CERoundProgressView *redProgress;
@property (weak, nonatomic) IBOutlet CERoundProgressView *greenProgress;
@property (weak, nonatomic) IBOutlet CERoundProgressView *blueProgress;

// Buttons
- (IBAction)redScoreAdd:(id)sender;
- (IBAction)greenScoreAdd:(id)sender;
- (IBAction)blueScoreAdd:(id)sender;
- (IBAction)resetButton:(id)sender;
- (IBAction)undoButton:(id)sender;
- (IBAction)showInfoView:(id)sender;

// Numberpad Input
- (IBAction) press:(id)sender;

// Helper Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)writeToPlist:(NSString *)fileName playerColor:(NSString *)player withData:(NSMutableArray *)data;
- (void)initializeScoresFromPlist;
- (void)winMatch:(NSString *)winner;
- (void)resetScores;

@end
