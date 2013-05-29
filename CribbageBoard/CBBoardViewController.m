//
//  CBBoardViewController.m
//  CribbageBoard
//
//  Created by Tim Carlson on 5/7/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//
//  TODO list:
//      - Only have it write to the plist when the view goes into background.
//          I have arrays (redData, etc...) that have all of the info I need.
//      - Consider changing the text field to just a label.  Then users can't
//          copy/paste into the field.
//      - Let players continue to add scores to non-winning players
//          (eg. everyone gets another turn after a player reaches the set amount)
//

#import "CBBoardViewController.h"
#import "CBSwitchViewController.h"

const int DEFAULT_GAME_SCORE = 121;     // The default score of the app (Cribbage)

@interface CBBoardViewController ()

@end

@implementation CBBoardViewController

@synthesize addToScoreField;
@synthesize redScoreLabel, greenScoreLabel, blueScoreLabel, yellowScoreLabel, lastActionLabel;
@synthesize redProgress, greenProgress, blueProgress, yellowProgress;
@synthesize pointsEntered;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            [[NSBundle mainBundle] loadNibNamed:@"CBBoardViewController" owner:self options:nil];
        }
        if(result.height == 568)
        {
            // iPhone 5
            [[NSBundle mainBundle] loadNibNamed:@"CBBoardViewController-5" owner:self options:nil];
        }
    }
    if (self) {
        // Custom initialization
        
        //Numberpad init
        numberpad = [[CBNumberpad alloc] init];
        charMax = numberpad.maxCharAllowed;
        
        // Set up scores...
        [self initializeScoresFromPlist];
        
        addToScoreField.delegate = self;

    }
    return self;
}

- (void)redScoreAdd:(id)sender
{
    pointsEntered = [[addToScoreField text] integerValue];
    NSLog(@"Points to add to red score: %d", pointsEntered);
    [[CBScore sharedCBScore] addToPlayerOne:pointsEntered];
    
    [self updateScoreLabels];
    [self updateProgress];
    
    addToScoreField.text = nil;
        [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];        // TODO: Make this only happen when app is closed
    
    if ([CBScore sharedCBScore].pOneScore >= [CBScore sharedCBScore].maxScore) {
        [self winMatch];
    }
}

- (void)greenScoreAdd:(id)sender
{
    pointsEntered = [[addToScoreField text] integerValue];
    NSLog(@"Points to add to green score: %d", pointsEntered);
    [[CBScore sharedCBScore] addToPlayerTwo:pointsEntered];
    
    [self updateScoreLabels];
    [self updateProgress];
    
    addToScoreField.text = nil;
    [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];        // TODO: Make this only happen when app is closed
    
    if ([CBScore sharedCBScore].pTwoScore >= [CBScore sharedCBScore].maxScore) {
        [self winMatch];
    }
}

- (void)blueScoreAdd:(id)sender
{
    pointsEntered = [[addToScoreField text] integerValue];
    NSLog(@"Points to add to blue score: %d", pointsEntered);
    [[CBScore sharedCBScore] addToPlayerThree:pointsEntered];
    
    [self updateScoreLabels];
    [self updateProgress];
    
    addToScoreField.text = nil;
    [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];        // TODO: Make this only happen when app is closed
    
    if ([CBScore sharedCBScore].pThreeScore >= [CBScore sharedCBScore].maxScore) {
        [self winMatch];
    }
}

- (void)yellowScoreAdd:(id)sender
{
    pointsEntered = [[addToScoreField text] integerValue];
    NSLog(@"Points to add to yellow score: %d", pointsEntered);
    [[CBScore sharedCBScore] addToPlayerFour:pointsEntered];
    
    [self updateScoreLabels];
    [self updateProgress];
    
    addToScoreField.text = nil;
    [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];        // TODO: Make this only happen when app is closed
    
    if ([CBScore sharedCBScore].pFourScore >= [CBScore sharedCBScore].maxScore) {
        [self winMatch];
    }
}

- (void)resetButton:(id)sender
{
    UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Reset Scores"
                                                         message:@"Are you sure?"
                                                        delegate:self
                                               cancelButtonTitle:@"Reset"
                                               otherButtonTitles:@"Cancel", nil];
    resetAlert.tag = 1;
    [resetAlert show];
}

- (void)undoButton:(id)sender
{
    if ([[CBScore sharedCBScore] undoLastAdd]) {
        // Refresh score labels...
        [self updateScoreLabels];
        
        // Refresh progress views...
        [self updateProgress];
        
        // Add data to plist
        [self writeScoresToPlist];        // TODO: Make this only happen when app is closed
    }
}

- (IBAction)showInfoView:(id)sender
{
    [CBSwitchViewController switchToInfo];
}

# pragma mark - Helper Methods

- (BOOL)writeScoresToPlist
{
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:@"/CBScoreList.plist"];
    
    // Create array to be saved
    NSMutableArray *plistArray;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        plistArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    } else {
        // Doesn't exist, start with an empty array
        NSLog(@"plist didn't exist");
        NSNumber *zero = [[NSNumber alloc] initWithInt:0];
        NSNumber *maxPlayTo = [NSNumber numberWithInt:DEFAULT_GAME_SCORE];
        plistArray = [[NSMutableArray alloc] initWithObjects:zero, zero, zero, zero, maxPlayTo, zero, zero, nil];
    }
    
    // Scores...
    [plistArray replaceObjectAtIndex:0 withObject:[[NSNumber alloc] initWithInt:[CBScore sharedCBScore].pOneScore]];
    [plistArray replaceObjectAtIndex:1 withObject:[[NSNumber alloc] initWithInt:[CBScore sharedCBScore].pTwoScore]];
    [plistArray replaceObjectAtIndex:2 withObject:[[NSNumber alloc] initWithInt:[CBScore sharedCBScore].pThreeScore]];
    [plistArray replaceObjectAtIndex:3 withObject:[[NSNumber alloc] initWithInt:[CBScore sharedCBScore].pFourScore]];
    
    // Max play to score...
    [plistArray replaceObjectAtIndex:4 withObject:[[NSNumber alloc] initWithInt:[CBScore sharedCBScore].maxScore]];
    
    // Undo Data...
    [plistArray replaceObjectAtIndex:5 withObject:[[NSNumber alloc] initWithInt:[CBScore sharedCBScore].lastPoints]];
    [plistArray replaceObjectAtIndex:6 withObject:[[NSNumber alloc] initWithInt:[CBScore sharedCBScore].lastPlayerTag]];
    
    NSLog(@"Current plist: %@", [plistArray description]);
    
    BOOL didWriteToFile = [plistArray writeToFile:filePath atomically:YES];
    if (didWriteToFile) {
        NSLog(@"Write to file a SUCCESS!");
        return TRUE;
    } else {
        NSLog(@"Write to file a FAILURE!");
        return FALSE;
    }
}

// New plist storage for a Dictionary
- (void)initializeScoresFromPlist
{
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:@"/CBScoreList.plist"];
    
    NSLog(@"File Path: %@", filePath);
    
    NSMutableArray *plistArray;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        plistArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        
        // // Initialize the CBScore data class with previous scores
        [[CBScore sharedCBScore] initWithArray:plistArray];
    
    } else {
        // Doesn't exist, start with an empty dictionary
        NSLog(@"plist didn't exist");

        NSNumber *zero = [[NSNumber alloc] initWithInt:0];
        NSNumber *maxPlayTo = [NSNumber numberWithInt:DEFAULT_GAME_SCORE];
        plistArray = [[NSMutableArray alloc] initWithObjects:zero, zero, zero, zero, maxPlayTo, zero, zero, nil];
        
//        NSMutableArray *zeroScore = [[NSMutableArray alloc] initWithObjects:zero, zero, zero, zero, nil];
//        NSMutableArray *scoresArray = [[NSMutableArray alloc] initWithObjects:zero, zero, zero, zero, nil];
//        NSMutableArray *infoArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:DEFAULT_GAME_SCORE], zero, nil];
//        NSMutableArray *undoArray = [[NSMutableArray alloc] initWithObjects:zeroScore, nil];
//        plistDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                     scoresArray, @"Scores", infoArray, @"Info", undoArray, @"Undos", nil];
        
        // Initialize the CBScore data class with scores at zero
        [[CBScore sharedCBScore] initWithArray:plistArray];
    }
    
    [self updateProgress];
}

// Displays a win message with score recap, then resets the scores
- (void)winMatch
{
    NSString *lastPlayer = [self getPlayerColor:[CBScore sharedCBScore].lastPlayerTag];
    NSString *winTitle = [NSString stringWithFormat:@"%@ scored beyond %d",
                          lastPlayer,
                          [CBScore sharedCBScore].maxScore];
    NSString *winMessage = [NSString stringWithFormat:@"%@: %d\n%@: %d\n%@: %d\n%@: %d",
                            [self getPlayerColor:1],
                            [CBScore sharedCBScore].pOneScore,
                            [self getPlayerColor:2],
                            [CBScore sharedCBScore].pTwoScore,
                            [self getPlayerColor:3],
                            [CBScore sharedCBScore].pThreeScore,
                            [self getPlayerColor:4],
                            [CBScore sharedCBScore].pFourScore];
    
    int max = [CBScore sharedCBScore].maxScore;
    if ([CBScore sharedCBScore].pOneScore >= max && [CBScore sharedCBScore].pTwoScore >= max
        && [CBScore sharedCBScore].pThreeScore >= max && [CBScore sharedCBScore].pFourScore >= max) {
        NSString *resetTitle = [NSString stringWithFormat:@"All players over %d", [CBScore sharedCBScore].maxScore];
        UIAlertView *winAlert = [[UIAlertView alloc] initWithTitle:resetTitle
                                                           message:winMessage
                                                          delegate:self
                                                 cancelButtonTitle:@"Reset Scores"
                                                 otherButtonTitles:nil];
        winAlert.tag = 2;
        [winAlert show];
    } else {
        UIAlertView *winAlert = [[UIAlertView alloc] initWithTitle:winTitle
                                                             message:winMessage
                                                            delegate:self
                                                   cancelButtonTitle:@"Reset Scores"
                                                   otherButtonTitles:@"Continue Scoring", nil];
        winAlert.tag = 3;
        [winAlert show];
    }
}

- (void)resetScores
{
    [[CBScore sharedCBScore] resetScores];
    [self writeScoresToPlist];
    
    // Refresh score labels...
    [self updateScoreLabels];
    [self updateProgress];
}

- (void)updateProgress
{
    // Refresh progress bars
    float rProgress = ((float)[CBScore sharedCBScore].pOneScore / (float)[CBScore sharedCBScore].maxScore);
    float gProgress = ((float)[CBScore sharedCBScore].pTwoScore / (float)[CBScore sharedCBScore].maxScore);
    float bProgress = ((float)[CBScore sharedCBScore].pThreeScore / (float)[CBScore sharedCBScore].maxScore);
    float yProgress = ((float)[CBScore sharedCBScore].pFourScore / (float)[CBScore sharedCBScore].maxScore);
    [redProgress setProgress:rProgress animated:YES];
    [greenProgress setProgress:gProgress animated:YES];
    [blueProgress setProgress:bProgress animated:YES];
    [yellowProgress setProgress:yProgress animated:YES];
}

- (void)updateScoreLabels
{
    // Refresh score labels...
    redScoreLabel.text = [NSString stringWithFormat:@"%d", [CBScore sharedCBScore].pOneScore];
    greenScoreLabel.text = [NSString stringWithFormat:@"%d", [CBScore sharedCBScore].pTwoScore];
    blueScoreLabel.text = [NSString stringWithFormat:@"%d", [CBScore sharedCBScore].pThreeScore];
    yellowScoreLabel.text = [NSString stringWithFormat:@"%d", [CBScore sharedCBScore].pFourScore];
    [redScoreLabel setNeedsDisplay];
    [greenScoreLabel setNeedsDisplay];
    [blueScoreLabel setNeedsDisplay];
    [yellowScoreLabel setNeedsDisplay];
    
    int playerTag = [CBScore sharedCBScore].lastPlayerTag;
    
    // Last action label
    if (!playerTag) {
        lastActionLabel.text = [NSString stringWithFormat:@"--"];
    } else {
        lastActionLabel.text = [NSString stringWithFormat:@"%d to %@",
                                [CBScore sharedCBScore].lastPoints,
                                [self getPlayerColor:playerTag]];
    }    
}

// Returns the NSString of the player's corresponding color
- (NSString *)getPlayerColor:(int)pTag
{
    if (pTag == 1) {
        return @"Green";
    } else if (pTag == 2) {
        return @"Orange";
    } else if (pTag == 3) {
        return @"Yellow";
    } else if (pTag == 4) {
        return @"Blue";
    }
    return nil;
}

#pragma mark - Numberpad IBAction's

- (IBAction) press:(id)sender {
    [numberpad input:[sender titleForState:UIControlStateNormal]];
    [addToScoreField setText:[numberpad displayValue]];
}


# pragma mark - Delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if(buttonIndex == 0) {
            [self resetScores];
        } else {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    } else if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [self resetScores];
        } else {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    } else if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            [self resetScores];
        }
    }
}

// Prevents pasting of text larger than character limit
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSLog(@"In the text field delegate method");
    NSLog(@"Max chars: %d", charMax);
    NSLog(@"newLength chars: %lu", (unsigned long)newLength);
    return (newLength > charMax ) ? NO : YES;
}

# pragma View handling

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Display a blinking cursor in the text field
    [addToScoreField becomeFirstResponder];
    
    // Rotate the text labels to conform with the corresponding buttons
    redScoreLabel.transform = CGAffineTransformMakeRotation (7*M_PI/4);
    greenScoreLabel.transform = CGAffineTransformMakeRotation (M_PI/4);
    blueScoreLabel.transform = CGAffineTransformMakeRotation (7*M_PI/4);
    yellowScoreLabel.transform = CGAffineTransformMakeRotation (M_PI/4);
    
    // Set the text labels and fields to their respective colors
    UIColor *labelColor = [UIColor colorWithRed:100.0/255.0 green:106.0/255.0 blue:67.0/255.0 alpha:1.0];
    redScoreLabel.textColor = labelColor;
    greenScoreLabel.textColor = labelColor;
    blueScoreLabel.textColor = labelColor;
    yellowScoreLabel.textColor = labelColor;
    addToScoreField.textColor = labelColor;
    lastActionLabel.textColor = labelColor;
    
    [self updateScoreLabels];
    /////////// End of label setting
    
    UIColor *rShade = [UIColor colorWithRed:68.0/255.0 green:202.0/255.0 blue:55.0/255.0 alpha:1.0];
    UIColor *gShade = [UIColor colorWithRed:255.0/255.0 green:139.0/255.0 blue:58.0/255.0 alpha:1.0];
    UIColor *bShade = [UIColor colorWithRed:248.0/255.0 green:208.0/255.0 blue:55.0/255.0 alpha:1.0];
    UIColor *yShade = [UIColor colorWithRed:94.0/255.0 green:196.0/255.0 blue:231.0/255.0 alpha:1.0];
    
    self.redProgress.tintColor = rShade;
    self.redProgress.trackColor = [UIColor colorWithWhite:0.00 alpha:0.0];
    self.redProgress.startAngle = (3.0*M_PI)/2.0;
    
    self.greenProgress.tintColor = gShade;
    self.greenProgress.trackColor = [UIColor colorWithWhite:0.00 alpha:0.0];
    self.greenProgress.startAngle = (3.0*M_PI)/2.0;
    
    self.blueProgress.tintColor = bShade;
    self.blueProgress.trackColor = [UIColor colorWithWhite:0.00 alpha:0.0];
    self.blueProgress.startAngle = (3.0*M_PI)/2.0;
    
    self.yellowProgress.tintColor = yShade;
    self.yellowProgress.trackColor = [UIColor colorWithWhite:0.00 alpha:0.0];
    self.yellowProgress.startAngle = (3.0*M_PI)/2.0;
    
    [self updateProgress];
    
    // This prevents a keyboard from popping up, and still allows for typing in textfield
    UIView *hideKeyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    addToScoreField.inputView = hideKeyboardView; // Hide keyboard, but show blinking cursor
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
