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
//

#import "CBBoardViewController.h"
#import "CBSwitchViewController.h"

@interface CBBoardViewController ()

@end

@implementation CBBoardViewController

@synthesize addToScoreField;
@synthesize redScoreLabel, greenScoreLabel, blueScoreLabel, yellowScoreLabel, lastActionLabel;
@synthesize redProgress, greenProgress, blueProgress, yellowProgress;
@synthesize pointsEntered, playTo;

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
        playTo = 121;   // TODO: Need this to be something the user can change in settings
        
        //Numberpad init
        numberpad = [[CBNumberpad alloc] init];
        charMax = numberpad.maxCharAllowed;
        
        // Set up scores...
        [self initializeScoresFromPlist];
        
        addToScoreField.delegate = self;

        UIColor *rShade = [UIColor colorWithRed:214.0/255.0 green:24.0/255.0 blue:27.0/255.0 alpha:1.0];
        UIColor *gShade = [UIColor colorWithRed:67.0/255.0 green:174.0/255.0 blue:36.0/255.0 alpha:1.0];
        UIColor *bShade = [UIColor colorWithRed:70.0/255.0 green:126.0/255.0 blue:200.0/255.0 alpha:1.0];
        UIColor *yShade = [UIColor colorWithRed:251.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1.0];
        
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

    }
    return self;
}

- (void)redScoreAdd:(id)sender
{
    pointsEntered = [[addToScoreField text] integerValue];
    NSLog(@"Points to add to red score: %d", pointsEntered);
    [scores addToRed:pointsEntered];
    
    redScoreLabel.text = [NSString stringWithFormat:@"%d", scores.redScore];
    
    [redScoreLabel setNeedsDisplay];
    
    addToScoreField.text = nil;
        [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];        // TODO: Make this only happen when app is closed
    
    if (scores.redScore >= playTo) {
        [self winMatch:@"Red"];
    }
    
    // Set progress bar
    float rProgress = ((float)scores.redScore / (float)playTo);
    [redProgress setProgress:rProgress animated:YES];
}

- (void)greenScoreAdd:(id)sender
{
    pointsEntered = [[addToScoreField text] integerValue];
    NSLog(@"Points to add to green score: %d", pointsEntered);
    [scores addToGreen:pointsEntered];
    
    greenScoreLabel.text = [NSString stringWithFormat:@"%d", scores.greenScore];
    
    [greenScoreLabel setNeedsDisplay];
    
    addToScoreField.text = nil;
    [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];        // TODO: Make this only happen when app is closed
    
    if (scores.greenScore >= playTo) {
        [self winMatch:@"Green"];
    }
    
    // Set progress bar
    float gProgress = ((float)scores.greenScore / (float)playTo);
    [greenProgress setProgress:gProgress animated:YES];
}

- (void)blueScoreAdd:(id)sender
{
    pointsEntered = [[addToScoreField text] integerValue];
    NSLog(@"Points to add to blue score: %d", pointsEntered);
    [scores addToBlue:pointsEntered];
    
    blueScoreLabel.text = [NSString stringWithFormat:@"%d", scores.blueScore];
    
    [blueScoreLabel setNeedsDisplay];
    
    addToScoreField.text = nil;
    [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];        // TODO: Make this only happen when app is closed
    
    if (scores.blueScore >= playTo) {
        [self winMatch:@"Blue"];
    }
    
    // Set progress bar
    float bProgress = ((float)scores.blueScore / (float)playTo);
    [blueProgress setProgress:bProgress animated:YES];
}

- (void)yellowScoreAdd:(id)sender
{
    pointsEntered = [[addToScoreField text] integerValue];
    NSLog(@"Points to add to yellow score: %d", pointsEntered);
    [scores addToYellow:pointsEntered];
    
    yellowScoreLabel.text = [NSString stringWithFormat:@"%d", scores.yellowScore];
    
    [yellowScoreLabel setNeedsDisplay];
    
    addToScoreField.text = nil;
    [numberpad input:@"C"];     // Clears the text field for new input
    
    // Add data to plist
    [self writeScoresToPlist];        // TODO: Make this only happen when app is closed
    
    if (scores.yellowScore >= playTo) {
        [self winMatch:@"Yellow"];
    }
    
    // Set progress bar
    float yProgress = ((float)scores.yellowScore / (float)playTo);
    [yellowProgress setProgress:yProgress animated:YES];
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
    if ([scores undoLastAdd]) {
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
        plistArray = [[NSMutableArray alloc] initWithObjects:zero, zero, zero, zero, nil];
    }
        
    [plistArray replaceObjectAtIndex:0 withObject:[[NSNumber alloc] initWithInt:scores.redScore]];
    [plistArray replaceObjectAtIndex:1 withObject:[[NSNumber alloc] initWithInt:scores.greenScore]];
    [plistArray replaceObjectAtIndex:2 withObject:[[NSNumber alloc] initWithInt:scores.blueScore]];
    [plistArray replaceObjectAtIndex:3 withObject:[[NSNumber alloc] initWithInt:scores.yellowScore]];
    
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
        scores = [[CBScore alloc] initWithArray:plistArray];
    
    } else {
        // Doesn't exist, start with an empty dictionary
        NSLog(@"plist didn't exist");
        
        NSNumber *zero = [[NSNumber alloc] initWithInt:0];
        plistArray = [[NSMutableArray alloc] initWithObjects:zero, zero, zero, zero, nil];
        
        // Initialize the CBScore data class with scores at zero
        scores = [[CBScore alloc] initWithArray:plistArray];
    }
    
    [self updateProgress];
}

// TODO: Consider writing this method to play special music, or display alternate message,
// when a player wins by a certain margin.
- (void)winMatch:(NSString *)winner
{
    UIAlertView *winAlert = [[UIAlertView alloc] initWithTitle:@"We have a winner!"
                                                         message:[winner stringByAppendingString:@" is the winner!"]
                                                        delegate:self
                                               cancelButtonTitle:@"Reset Scores"
                                               otherButtonTitles:nil];
    winAlert.tag = 2;
    [winAlert show];
}

- (void)resetScores
{
    [scores resetScores];
    [self writeScoresToPlist];
    
    // Refresh score labels...
    [self updateScoreLabels];
    [self updateProgress];
}

- (void)updateProgress
{
    // Refresh progress bars
    float rProgress = ((float)scores.redScore / (float)playTo);
    float gProgress = ((float)scores.greenScore / (float)playTo);
    float bProgress = ((float)scores.blueScore / (float)playTo);
    float yProgress = ((float)scores.yellowScore / (float)playTo);
    [redProgress setProgress:rProgress animated:NO];
    [greenProgress setProgress:gProgress animated:NO];
    [blueProgress setProgress:bProgress animated:NO];
    [yellowProgress setProgress:yProgress animated:NO];
}

- (void)updateScoreLabels
{
    // Refresh score labels...
    redScoreLabel.text = [NSString stringWithFormat:@"%d", scores.redScore];
    greenScoreLabel.text = [NSString stringWithFormat:@"%d", scores.greenScore];
    blueScoreLabel.text = [NSString stringWithFormat:@"%d", scores.blueScore];
    yellowScoreLabel.text = [NSString stringWithFormat:@"%d", scores.yellowScore];
    [redScoreLabel setNeedsDisplay];
    [greenScoreLabel setNeedsDisplay];
    [blueScoreLabel setNeedsDisplay];
    [yellowScoreLabel setNeedsDisplay];
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
    
    // Set the text labels to their respective colors
    UIColor *labelColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    redScoreLabel.textColor = labelColor;
    greenScoreLabel.textColor = labelColor;
    blueScoreLabel.textColor = labelColor;
    yellowScoreLabel.textColor = labelColor;
    
    [self updateScoreLabels];
    /////////// End of label setting
    
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
