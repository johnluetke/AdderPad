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
    //__weak IBOutlet UITextField *addToScoreField;
    CBNumberpad *numberpad;
    //CBScore *scores;
    __weak UITextField *addToScoreField;
    
    @private
    int charMax;
}

@property (nonatomic, weak) IBOutlet id addToScoreField;

// Labels
@property (nonatomic, weak) IBOutlet UILabel *redScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *greenScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *blueScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *yellowScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastActionLabel;

// Data
@property (assign) int pointsEntered;
@property (assign) int playTo;


// Progress Bars
@property (weak, nonatomic) IBOutlet CERoundProgressView *redProgress;
@property (weak, nonatomic) IBOutlet CERoundProgressView *greenProgress;
@property (weak, nonatomic) IBOutlet CERoundProgressView *blueProgress;
@property (weak, nonatomic) IBOutlet CERoundProgressView *yellowProgress;

// Buttons
- (IBAction)redScoreAdd:(id)sender;
- (IBAction)greenScoreAdd:(id)sender;
- (IBAction)blueScoreAdd:(id)sender;
- (IBAction)yellowScoreAdd:(id)sender;
- (IBAction)resetButton:(id)sender;
- (IBAction)undoButton:(id)sender;
- (IBAction)showInfoView:(id)sender;

// Numberpad Input
- (IBAction) press:(id)sender;

// Helper Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)writeScoresToPlist;
- (void)initializeScoresFromPlist;
- (void)winMatch:(NSString *)winner;
- (void)resetScores;
- (void)updateProgress;
- (void)updateScoreLabels;
- (NSString *)lastPlayerColor:(int)playerTag;

@end
