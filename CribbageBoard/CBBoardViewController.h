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
#import "CBScore.h"

@interface CBBoardViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>
{
    CBNumberpad *numberpad;
    __weak UITextField *addToScoreField;
    
    @private
        int charMax;    // Max number of characters that can be entered in text fields
}

@property (nonatomic, weak) IBOutlet id addToScoreField;

// Labels
@property (nonatomic, weak) IBOutlet UILabel *pOneScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *pTwoScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *pThreeScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *pFourScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastActionLabel;

// Data
@property (assign) int pointsEntered;
@property (assign) int playTo;


// Progress Bars
@property (weak, nonatomic) IBOutlet CERoundProgressView *pOneProgress;
@property (weak, nonatomic) IBOutlet CERoundProgressView *pTwoProgress;
@property (weak, nonatomic) IBOutlet CERoundProgressView *pThreeProgress;
@property (weak, nonatomic) IBOutlet CERoundProgressView *pFourProgress;

// Buttons
- (IBAction)pOneAdd:(id)sender;
- (IBAction)pTwoAdd:(id)sender;
- (IBAction)pThreeAdd:(id)sender;
- (IBAction)pFourAdd:(id)sender;
- (IBAction)resetButton:(id)sender;
- (IBAction)undoButton:(id)sender;
- (IBAction)showInfoView:(id)sender;

// Numberpad Input
- (IBAction) press:(id)sender;

// Helper Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)writeScoresToPlist;
- (void)initializeScoresFromPlist;
- (void)winMatch;
- (void)resetScores;
- (void)updateProgress;
- (void)updateScoreLabels;
- (NSString *)getPlayerColor:(int)playerTag;    // Needs to reflect the colors in the XIB file

@end
