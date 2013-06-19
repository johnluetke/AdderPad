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
//

#import "CBBoardViewController.h"
#import "CBSwitchViewController.h"

const int DEFAULT_GAME_SCORE = 121;     // The default score of the app (Cribbage)

@interface CBBoardViewController ()

@end

@implementation CBBoardViewController

@synthesize addToScoreField;
@synthesize pOneScoreLabel, pTwoScoreLabel, pThreeScoreLabel, pFourScoreLabel, lastActionLabel;
@synthesize pOneProgress, pTwoProgress, pThreeProgress, pFourProgress;
@synthesize pointsEntered;

+ (void)initialize
{
    
    NSDictionary *defaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"isSoundOn"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPhone 5
        [[NSBundle mainBundle] loadNibNamed:@"CBBoardViewController" owner:self options:nil];
        NSLog(@"iPhone 5 xib file loaded");
        
    } else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            [[NSBundle mainBundle] loadNibNamed:@"CBBoardViewController" owner:self options:nil];
            NSLog(@"iPhone Retina 3.5 xib file Loaded");
        }
        if(result.height == 568)
        {
            // iPhone 5
            [[NSBundle mainBundle] loadNibNamed:@"CBBoardViewController-5" owner:self options:nil];
            NSLog(@"iPhone 5 xib file loaded");
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
        
        // On first ever startup, load an instruction subview
//        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        if (([[prefs objectForKey:@"launchCount"] integerValue] == 1) {
//            
//        }
    }
    return self;
}

- (IBAction)pOneAdd:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
        AudioServicesPlaySystemSound(0x450);
    }
    // Check if value is null or zero
    if (![[addToScoreField text] integerValue]) {
        if ([[addToScoreField text] isEqualToString:@"0"]
            || [[addToScoreField text] isEqualToString:@"00"]
            || [[addToScoreField text] isEqualToString:@"000"]
            || [[addToScoreField text] isEqualToString:@"0000"]
            || [[addToScoreField text] isEqualToString:@"00000"]
            || [[addToScoreField text] isEqualToString:@"000000"]) {
            pointsEntered = -999;   // sentinel value to detect user intending to enter only zeros
        } else {
            pointsEntered = 0;
        }
    } else {
        pointsEntered = [[addToScoreField text] integerValue];
    }
    
    NSLog(@"Points to add to player ONE score: %d", pointsEntered);
    [[CBScore sharedCBScore] addToPlayerOne:pointsEntered];
    
    [self updateScoreLabels];
    [self updateProgress];
    
    addToScoreField.text = nil;
    [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];
    
    if ([CBScore sharedCBScore].pOneScore >= [CBScore sharedCBScore].maxScore) {
        [self winMatch];
    }
}

- (IBAction)pTwoAdd:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
        AudioServicesPlaySystemSound(0x450);
    }
    // Check if value is null or zero
    if (![[addToScoreField text] integerValue]) {
        if ([[addToScoreField text] isEqualToString:@"0"]
            || [[addToScoreField text] isEqualToString:@"00"]
            || [[addToScoreField text] isEqualToString:@"000"]
            || [[addToScoreField text] isEqualToString:@"0000"]
            || [[addToScoreField text] isEqualToString:@"00000"]
            || [[addToScoreField text] isEqualToString:@"000000"]) {
            pointsEntered = -999;   // sentinel value to detect user intending to enter only zeros
        } else {
            pointsEntered = 0;
        }
    } else {
        pointsEntered = [[addToScoreField text] integerValue];
    }
    
    NSLog(@"Points to add to player TWO score: %d", pointsEntered);
    [[CBScore sharedCBScore] addToPlayerTwo:pointsEntered];
    
    [self updateScoreLabels];
    [self updateProgress];
    
    addToScoreField.text = nil;
    [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];
    
    if ([CBScore sharedCBScore].pTwoScore >= [CBScore sharedCBScore].maxScore) {
        [self winMatch];
    }
}

- (IBAction)pThreeAdd:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
        AudioServicesPlaySystemSound(0x450);
    }
    // Check if value is null or zero
    if (![[addToScoreField text] integerValue]) {
        if ([[addToScoreField text] isEqualToString:@"0"]
            || [[addToScoreField text] isEqualToString:@"00"]
            || [[addToScoreField text] isEqualToString:@"000"]
            || [[addToScoreField text] isEqualToString:@"0000"]
            || [[addToScoreField text] isEqualToString:@"00000"]
            || [[addToScoreField text] isEqualToString:@"000000"]) {
            pointsEntered = -999;   // sentinel value to detect user intending to enter only zeros
        } else {
            pointsEntered = 0;
        }
    } else {
        pointsEntered = [[addToScoreField text] integerValue];
    }
    
    NSLog(@"Points to add to player THREE score: %d", pointsEntered);
    [[CBScore sharedCBScore] addToPlayerThree:pointsEntered];
    
    [self updateScoreLabels];
    [self updateProgress];
    
    addToScoreField.text = nil;
    [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];
    
    if ([CBScore sharedCBScore].pThreeScore >= [CBScore sharedCBScore].maxScore) {
        [self winMatch];
    }
}

- (IBAction)pFourAdd:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
        AudioServicesPlaySystemSound(0x450);
    }
    // Check if value is null or zero
    if (![[addToScoreField text] integerValue]) {
        if ([[addToScoreField text] isEqualToString:@"0"]
                || [[addToScoreField text] isEqualToString:@"00"]
                || [[addToScoreField text] isEqualToString:@"000"]
                || [[addToScoreField text] isEqualToString:@"0000"]
                || [[addToScoreField text] isEqualToString:@"00000"]
                || [[addToScoreField text] isEqualToString:@"000000"]) {
            pointsEntered = -999;   // sentinel value to detect user intending to enter only zeros
        } else {
        pointsEntered = 0;
        }
    } else {
        pointsEntered = [[addToScoreField text] integerValue];
    }
    NSLog(@"Points to add to player FOUR score: %d", pointsEntered);
    [[CBScore sharedCBScore] addToPlayerFour:pointsEntered];
    
    [self updateScoreLabels];
    [self updateProgress];
    
    addToScoreField.text = nil;
    [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];
    
    if ([CBScore sharedCBScore].pFourScore >= [CBScore sharedCBScore].maxScore) {
        [self winMatch];
    }
}

- (IBAction)resetButton:(id)sender
{
    UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Reset Scores"
                                                         message:@"Are you sure?"
                                                        delegate:self
                                               cancelButtonTitle:@"Reset"
                                               otherButtonTitles:@"Cancel", nil];
    resetAlert.tag = 1;
    [resetAlert show];
}

- (IBAction)undoButton:(id)sender
{
    if ([[CBScore sharedCBScore] undoLastAdd]) {
        // Refresh score labels...
        [self updateScoreLabels];
        
        // Refresh progress views...
        [self updateProgress];
        
        // Add data to plist
        [self writeScoresToPlist];
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
    NSString *winMessage = [NSString stringWithFormat:@"%@: %d  \t%@: %d\n%@: %d  \t%@: %d",
                            [self getPlayerColor:1],
                            [CBScore sharedCBScore].pOneScore,
                            [self getPlayerColor:2],
                            [CBScore sharedCBScore].pTwoScore,
                            [self getPlayerColor:4],
                            [CBScore sharedCBScore].pFourScore,
                            [self getPlayerColor:3],
                            [CBScore sharedCBScore].pThreeScore];
    
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
                                                   otherButtonTitles:@"Continue", nil];
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
    float oneProgressPer = ((float)[CBScore sharedCBScore].pOneScore / (float)[CBScore sharedCBScore].maxScore);
    float twoProgressPer = ((float)[CBScore sharedCBScore].pTwoScore / (float)[CBScore sharedCBScore].maxScore);
    float threeProgressPer = ((float)[CBScore sharedCBScore].pThreeScore / (float)[CBScore sharedCBScore].maxScore);
    float fourProgressPer = ((float)[CBScore sharedCBScore].pFourScore / (float)[CBScore sharedCBScore].maxScore);

    [pOneProgress setProgress:oneProgressPer animated:YES];
    [pTwoProgress setProgress:twoProgressPer animated:YES];
    [pThreeProgress setProgress:threeProgressPer animated:YES];
    [pFourProgress setProgress:fourProgressPer animated:YES];
}

- (void)updateScoreLabels
{
    // Refresh score labels...
    pOneScoreLabel.text = [NSString stringWithFormat:@"%d", [CBScore sharedCBScore].pOneScore];
    pTwoScoreLabel.text = [NSString stringWithFormat:@"%d", [CBScore sharedCBScore].pTwoScore];
    pThreeScoreLabel.text = [NSString stringWithFormat:@"%d", [CBScore sharedCBScore].pThreeScore];
    pFourScoreLabel.text = [NSString stringWithFormat:@"%d", [CBScore sharedCBScore].pFourScore];
    [pOneScoreLabel setNeedsDisplay];
    [pTwoScoreLabel setNeedsDisplay];
    [pThreeScoreLabel setNeedsDisplay];
    [pFourScoreLabel setNeedsDisplay];
    
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
// Needs to be updated along with changes to XIB file
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
    pOneScoreLabel.transform = CGAffineTransformMakeRotation (7*M_PI/4);
    pTwoScoreLabel.transform = CGAffineTransformMakeRotation (M_PI/4);
    pThreeScoreLabel.transform = CGAffineTransformMakeRotation (7*M_PI/4);
    pFourScoreLabel.transform = CGAffineTransformMakeRotation (M_PI/4);
    
    // Set the text labels and fields to their respective colors
    UIColor *labelColor = [UIColor colorWithRed:100.0/255.0 green:106.0/255.0 blue:67.0/255.0 alpha:1.0];
    pOneScoreLabel.textColor = labelColor;
    pTwoScoreLabel.textColor = labelColor;
    pThreeScoreLabel.textColor = labelColor;
    pFourScoreLabel.textColor = labelColor;
    addToScoreField.textColor = labelColor;
    lastActionLabel.textColor = labelColor;
    
    [self updateScoreLabels];
    /////////// End of label setting
    
    UIColor *oneShade = [UIColor colorWithRed:68.0/255.0 green:202.0/255.0 blue:55.0/255.0 alpha:1.0];
    UIColor *twoShade = [UIColor colorWithRed:255.0/255.0 green:139.0/255.0 blue:58.0/255.0 alpha:1.0];
    UIColor *threeShade = [UIColor colorWithRed:248.0/255.0 green:208.0/255.0 blue:55.0/255.0 alpha:1.0];
    UIColor *fourShade = [UIColor colorWithRed:94.0/255.0 green:196.0/255.0 blue:231.0/255.0 alpha:1.0];
    
    self.pOneProgress.tintColor = oneShade;
    self.pOneProgress.trackColor = [UIColor colorWithWhite:0.00 alpha:0.0];
    self.pOneProgress.startAngle = (3.0*M_PI)/2.0;
    
    self.pTwoProgress.tintColor = twoShade;
    self.pTwoProgress.trackColor = [UIColor colorWithWhite:0.00 alpha:0.0];
    self.pTwoProgress.startAngle = (3.0*M_PI)/2.0;
    
    self.pThreeProgress.tintColor = threeShade;
    self.pThreeProgress.trackColor = [UIColor colorWithWhite:0.00 alpha:0.0];
    self.pThreeProgress.startAngle = (3.0*M_PI)/2.0;
    
    self.pFourProgress.tintColor = fourShade;
    self.pFourProgress.trackColor = [UIColor colorWithWhite:0.00 alpha:0.0];
    self.pFourProgress.startAngle = (3.0*M_PI)/2.0;
    
    [self updateProgress];
    
    // This prevents a keyboard from popping up, and still allows for typing in textfield
    UIView *hideKeyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    addToScoreField.inputView = hideKeyboardView; // Hide keyboard, but show blinking cursor
    
    [self writeScoresToPlist];  // In case max score was changed in other view
    
    // Load audio....
    
    // Impletmentation for custom sound effects...
//    NSURL *tapSoundURL   = [[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];
////    NSURL *blip1URL   = [[NSBundle mainBundle] URLForResource: @"Blip1" withExtension: @"aif"];
////    NSURL *blip2URL   = [[NSBundle mainBundle] URLForResource: @"Blip2" withExtension: @"aif"];
////    NSURL *blip3URL   = [[NSBundle mainBundle] URLForResource: @"Blip3" withExtension: @"aif"];
////    NSURL *blip4URL   = [[NSBundle mainBundle] URLForResource: @"Blip4" withExtension: @"aif"];
//    
//    NSURL *blip1URL   = [[NSBundle mainBundle] URLForResource: @"KeyOne" withExtension: @"aif"];
//    NSURL *blip2URL   = [[NSBundle mainBundle] URLForResource: @"KeyTwo" withExtension: @"aif"];
//    NSURL *blip3URL   = [[NSBundle mainBundle] URLForResource: @"KeyThree" withExtension: @"aif"];
//    NSURL *blip4URL   = [[NSBundle mainBundle] URLForResource: @"KeyFour" withExtension: @"aif"];
//    
//    // Initialize SystemSoundID variable with file URL
//    AudioServicesCreateSystemSoundID (CFBridgingRetain(tapSoundURL), &soundTap);
//    AudioServicesCreateSystemSoundID (CFBridgingRetain(blip1URL), &blipOne);
//    AudioServicesCreateSystemSoundID (CFBridgingRetain(blip2URL), &blipTwo);
//    AudioServicesCreateSystemSoundID (CFBridgingRetain(blip3URL), &blipThree);
//    AudioServicesCreateSystemSoundID (CFBridgingRetain(blip4URL), &blipFour);
/////////////////////////////////////////////////////////////////////////////////
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self writeScoresToPlist];
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
