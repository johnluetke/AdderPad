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
#import "LNNumberpad.h"

@interface CBBoardViewController ()

@end

@implementation CBBoardViewController

@synthesize redScoreLabel, greenScoreLabel, blueScoreLabel;
@synthesize redScore, greenScore, blueScore;
@synthesize lastPlayerTag;
@synthesize redData, greenData, blueData;
@synthesize redProgress, greenProgress, blueProgress;
@synthesize pointsEntered, playTo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        playTo = 121;
        [self initializeScoresFromPlist];
    }
    return self;
}

- (void)redScoreAdd:(id)sender
{
    lastPlayerTag = 1;
    pointsEntered = [[addToScoreField text] integerValue];
    NSLog(@"Points to add to red score: %d", pointsEntered);
    
    if (!pointsEntered) {
        redScore += 1;  // no value entered (TODO: adds 1 when 0 is entered)
        pointsEntered = 1;
    } else {
        redScore += pointsEntered;
    }
    redScoreLabel.text = [NSString stringWithFormat:@"%d", redScore];
    
    [redScoreLabel setNeedsDisplay];
    addToScoreField.text = nil;
    
    // Add data to plist
    
    NSNumber *points = [NSNumber numberWithInt:pointsEntered];
    NSNumber *total = [NSNumber numberWithInt:redScore];
    [redData replaceObjectAtIndex:0 withObject:points];
    [redData replaceObjectAtIndex:1 withObject:total];
    
    [self writeToPlist:@"/CurrentScores.plist" playerColor:@"RedScore" withData:redData];
    
    if (redScore >= playTo) {
        [self winMatch:@"Red"];
    }
    
    // Set progress bar
    float progress = ((float)redScore / (float)playTo);
    [redProgress setProgress:progress animated:YES];
}

- (void)greenScoreAdd:(id)sender
{
    lastPlayerTag = 2;
    pointsEntered = [[addToScoreField text] integerValue];
    NSLog(@"Points to add to green score: %d", pointsEntered);
    
    if (!pointsEntered) {
        greenScore += 1;  // no value entered (TODO: adds 1 when 0 is entered)
        pointsEntered = 1;
    } else {
        greenScore += pointsEntered;
    }
    greenScoreLabel.text = [NSString stringWithFormat:@"%d", greenScore];
    
    [greenScoreLabel setNeedsDisplay];
    addToScoreField.text = nil;
    
    // Add data to plist
    
    NSNumber *points = [NSNumber numberWithInt:pointsEntered];
    NSNumber *total = [NSNumber numberWithInt:greenScore];
    [greenData replaceObjectAtIndex:0 withObject:points];
    [greenData replaceObjectAtIndex:1 withObject:total];
    
    [self writeToPlist:@"/CurrentScores.plist" playerColor:@"GreenScore" withData:greenData];
    
    if (greenScore >= playTo) {
        [self winMatch:@"Green"];
    }
    
    // Set progress bar
    float progress = ((float)greenScore / (float)playTo);
    [greenProgress setProgress:progress animated:YES];
}

- (void)blueScoreAdd:(id)sender
{
    lastPlayerTag = 3;
    pointsEntered = [[addToScoreField text] integerValue];
    NSLog(@"Points to add to blue score: %d", pointsEntered);
    
    if (!pointsEntered) {
        blueScore += 1;  // no value entered (TODO: adds 1 when 0 is entered)
        pointsEntered = 1;
    } else {
        blueScore += pointsEntered;
    }
    blueScoreLabel.text = [NSString stringWithFormat:@"%d", blueScore];
    
    [blueScoreLabel setNeedsDisplay];
    addToScoreField.text = nil;
    
    // Add data to plist
    
    NSNumber *points = [NSNumber numberWithInt:pointsEntered];
    NSNumber *total = [NSNumber numberWithInt:blueScore];
    [blueData replaceObjectAtIndex:0 withObject:points];
    [blueData replaceObjectAtIndex:1 withObject:total];
    
    [self writeToPlist:@"/CurrentScores.plist" playerColor:@"BlueScore" withData:blueData];

    if (blueScore >= playTo) {
        [self winMatch:@"Blue"];
    }
    
    // Set progress bar
    float progress = ((float)blueScore / (float)playTo);
    [blueProgress setProgress:progress animated:YES];
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

// TODO:  Shouldn't have to go into plist here, just use the arrays (redData, etc...)
- (void)undoButton:(id)sender
{
    if (lastPlayerTag == 1) {
        
        // red
        int lastPoints = [[redData objectAtIndex:0] integerValue];
        int prevScore = [[redData objectAtIndex:1] integerValue];
        
        NSNumber *afterUndoScore = [[NSNumber alloc] initWithInt:(prevScore - lastPoints)];
        NSNumber *temp = [[NSNumber alloc] initWithInt:0];
        redData = [[NSMutableArray alloc] initWithObjects:temp, afterUndoScore, nil];
        redScore = (prevScore - lastPoints);
        [self writeToPlist:@"/CurrentScores" playerColor:@"RedScore" withData:redData];
        redScoreLabel.text = [NSString stringWithFormat:@"%d", redScore];
        [redScoreLabel setNeedsDisplay];
        float progress = ((float)redScore / (float)playTo);
        [redProgress setProgress:progress animated:YES];
        
    } else if (lastPlayerTag == 2) {
        
        // green
        int lastPoints = [[greenData objectAtIndex:0] integerValue];
        int prevScore = [[greenData objectAtIndex:1] integerValue];
        NSNumber *afterUndoScore = [[NSNumber alloc] initWithInt:(prevScore - lastPoints)];
        NSNumber *temp = [[NSNumber alloc] initWithInt:0];
        greenData = [[NSMutableArray alloc] initWithObjects:temp, afterUndoScore, nil];
        greenScore = (prevScore - lastPoints);
        [self writeToPlist:@"/CurrentScores" playerColor:@"GreenScore" withData:greenData];
        greenScoreLabel.text = [NSString stringWithFormat:@"%d", greenScore];
        [greenScoreLabel setNeedsDisplay];
        float progress = ((float)greenScore / (float)playTo);
        [greenProgress setProgress:progress animated:YES];
        
    } else if (lastPlayerTag == 3) {
        
        // blue
        int lastPoints = [[blueData objectAtIndex:0] integerValue];
        int prevScore = [[blueData objectAtIndex:1] integerValue];
        NSNumber *afterUndoScore = [[NSNumber alloc] initWithInt:(prevScore - lastPoints)];
        NSNumber *temp = [[NSNumber alloc] initWithInt:0];
        blueData = [[NSMutableArray alloc] initWithObjects:temp, afterUndoScore, nil];
        blueScore = (prevScore - lastPoints);
        [self writeToPlist:@"/CurrentScores" playerColor:@"BlueScore" withData:blueData];
        blueScoreLabel.text = [NSString stringWithFormat:@"%d", blueScore];
        [blueScoreLabel setNeedsDisplay];
        float progress = ((float)blueScore / (float)playTo);
        [blueProgress setProgress:progress animated:YES];
        
    }
}

# pragma mark - Helper Methods

// TODO: Currently not working, need to this to be saved whenever the game goes into background
- (BOOL)writeToPlist:(NSString *)fileName playerColor:(NSString *)player withData:(NSMutableArray *)data
{
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary *plistDict;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    } else {
        // Doesn't exist, start with an empty dictionary
        NSLog(@"plist didn't exist");
        plistDict = [[NSMutableDictionary alloc] init];
    }
        
    [plistDict setValue:data forKey:player];
    
    NSLog(@"Current plist: %@", [plistDict description]);
    
    BOOL didWriteToFile = [plistDict writeToFile:filePath atomically:YES];
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
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:@"/CurrentScores.plist"];
    
    NSLog(@"File Path: %@", filePath);
    
    NSMutableDictionary *plistDict;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        // Initialize with previous scores
        redData = [[NSMutableArray alloc] initWithObjects:[[plistDict objectForKey:@"RedScore"] objectAtIndex:0], [[plistDict objectForKey:@"RedScore"] objectAtIndex:1], nil];
        redScore = [[redData objectAtIndex:1] intValue];
        
        greenData = [[NSMutableArray alloc] initWithObjects:[[plistDict objectForKey:@"GreenScore"] objectAtIndex:0], [[plistDict objectForKey:@"GreenScore"] objectAtIndex:1], nil];
        greenScore = [[greenData objectAtIndex:1] intValue];
        
        blueData = [[NSMutableArray alloc] initWithObjects:[[plistDict objectForKey:@"BlueScore"] objectAtIndex:0], [[plistDict objectForKey:@"BlueScore"] objectAtIndex:1], nil];
        blueScore = [[blueData objectAtIndex:1] intValue];
        
        // Initialize progress bars
        float rProgress = ((float)redScore / (float)playTo);
        float gProgress = ((float)greenScore / (float)playTo);
        float bProgress = ((float)blueScore / (float)playTo);
        [redProgress setProgress:rProgress animated:NO];
        [greenProgress setProgress:gProgress animated:NO];
        [blueProgress setProgress:bProgress animated:NO];
    } else {
        // Doesn't exist, start with an empty dictionary
        NSLog(@"plist didn't exist");
        plistDict = [[NSMutableDictionary alloc] init];
        
        NSNumber *temp = [[NSNumber alloc] initWithInt:0];
        redData = [[NSMutableArray alloc] initWithObjects:temp, temp, nil];
        redScore = 0;
        
        greenData = [[NSMutableArray alloc] initWithObjects:temp, temp, nil];
        greenScore = 0;
        
        blueData = [[NSMutableArray alloc] initWithObjects:temp, temp, nil];
        blueScore = 0;
        
        // Initialize progress bars
        [redProgress setProgress:0.0 animated:NO];
        [greenProgress setProgress:0.0 animated:NO];
        [blueProgress setProgress:0.0 animated:NO];
    }

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
    NSNumber *temp = [[NSNumber alloc] initWithInt:0];
    
    redData = [[NSMutableArray alloc] initWithObjects:temp, temp, nil];
    redScore = 0;
    
    greenData = [[NSMutableArray alloc] initWithObjects:temp, temp, nil];
    greenScore = 0;
    
    blueData = [[NSMutableArray alloc] initWithObjects:temp, temp, nil];
    blueScore = 0;
    
    [self writeToPlist:@"/CurrentScores.plist" playerColor:@"RedScore" withData:redData];
    [self writeToPlist:@"/CurrentScores.plist" playerColor:@"GreenScore" withData:redData];
    [self writeToPlist:@"/CurrentScores.plist" playerColor:@"BlueScore" withData:redData];
    
    redScoreLabel.text = [NSString stringWithFormat:@"%d", redScore];
    greenScoreLabel.text = [NSString stringWithFormat:@"%d", greenScore];
    blueScoreLabel.text = [NSString stringWithFormat:@"%d", blueScore];
    [redScoreLabel setNeedsDisplay];
    [greenScoreLabel setNeedsDisplay];
    [blueScoreLabel setNeedsDisplay];
    
    [redProgress setProgress:0.0 animated:NO];
    [greenProgress setProgress:0.0 animated:NO];
    [blueProgress setProgress:0.0 animated:NO];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 2) ? NO : YES;  // Max score on a hand is 29, so limit to just two characters
}

# pragma View handling

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [addToScoreField selectAll:addToScoreField];
    self->addToScoreField.inputView  = [LNNumberpad defaultLNNumberpad];
    [addToScoreField becomeFirstResponder];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Refresh current scores
    redScoreLabel.text = [NSString stringWithFormat:@"%d", redScore];
    greenScoreLabel.text = [NSString stringWithFormat:@"%d", greenScore];
    blueScoreLabel.text = [NSString stringWithFormat:@"%d", blueScore];
    [redScoreLabel setNeedsDisplay];
    [greenScoreLabel setNeedsDisplay];
    [blueScoreLabel setNeedsDisplay];
    
    float rProgress = ((float)redScore / (float)playTo);
    float gProgress = ((float)greenScore / (float)playTo);
    float bProgress = ((float)blueScore / (float)playTo);
    [redProgress setProgress:rProgress animated:NO];
    [greenProgress setProgress:gProgress animated:NO];
    [blueProgress setProgress:bProgress animated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
