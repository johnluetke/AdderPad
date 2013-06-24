//
//  CBInfoViewController.m
//  CribbageBoard
//
//  Created by Tim Carlson on 5/13/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//
//  NOTE: Use [CBScore sharedCBScore] to access the score data
//


#import "CBInfoViewController.h"
#import "CBSwitchViewController.h"
#import "CBScore.h"

@interface CBInfoViewController ()

@end

@implementation CBInfoViewController

@synthesize maxScoreField;
@synthesize maxScoreLabel;
@synthesize isSoundOn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    // Check for iPad devices
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[NSBundle mainBundle] loadNibNamed:@"CBInfoViewController-5" owner:self options:nil];
        NSLog(@"iPhone 5 xib file loaded");
        
    } else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480) {
            // iPhone Classic
            [[NSBundle mainBundle] loadNibNamed:@"CBInfoViewController" owner:self options:nil];
        }
        if(result.height == 568) {
            // iPhone 5
            [[NSBundle mainBundle] loadNibNamed:@"CBInfoViewController-5" owner:self options:nil];
        }
    }
    
    
    if (self) {
        // Custom initialization
        numberpad = [[CBNumberpad alloc] init];
        charMax = numberpad.maxCharAllowed;
        maxScoreField.delegate = self;
        self.wantsFullScreenLayout = YES;  // Ensures that status bar overlaps the view
    }
    return self;
}

- (IBAction)backToBoard:(id)sender
{
    [CBSwitchViewController switchToBoard];
}

- (IBAction)saveMaxScore:(id)sender
{
    if ([[maxScoreField text] integerValue] != 0) {
        UIAlertView *changeMaxScoreAlert = [[UIAlertView alloc] initWithTitle:@"Change Winning Score?"
                                                                      message:@"This will reset scores.\nAre you sure?"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Yes"
                                                            otherButtonTitles:@"No", nil];
        changeMaxScoreAlert.tag = 1;
        [changeMaxScoreAlert show];
    } else {
        UIAlertView *changeMaxScoreAlert = [[UIAlertView alloc] initWithTitle:@"Enter a Valid Score"
                                                                      message:@"Please enter a value greater than zero."
                                                                     delegate:self
                                                            cancelButtonTitle:@"Ok"
                                                            otherButtonTitles:nil];
        changeMaxScoreAlert.tag = 2;
        [changeMaxScoreAlert show];
    }
}

// Toggles the sound button
- (IBAction)setSound:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSoundOn"];
        [sender setImage: [UIImage imageNamed:@"SoundOff.png"] forState:UIControlStateNormal];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSoundOn"];
        [sender setImage: [UIImage imageNamed:@"SoundOn.png"] forState:UIControlStateNormal];
    }
}

// Disables the device from going into sleep/idle mode
// isIdleDisabled = YES ... Dont' go to sleep
// isIdleDisabled = NO  ... Allow to sleep
- (IBAction)setIdleStatus:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isIdleDisabled"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isIdleDisabled"];
        [sender setImage: [UIImage imageNamed:@"SleepOn.png"] forState:UIControlStateNormal];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isIdleDisabled"];
        [sender setImage: [UIImage imageNamed:@"SleepOff.png"] forState:UIControlStateNormal];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if(buttonIndex == 0) {
            int newMaxScore = [[maxScoreField text] integerValue];
            NSLog(@"Changing new max score to: %d", newMaxScore);
            [[CBScore sharedCBScore] setMaxScore:newMaxScore];
            maxScoreField.text = nil;
            [numberpad input:@"C"];     // Clears the text field for new input
            [[CBScore sharedCBScore] resetScores];
            [self updateLabels];
        } else {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    } else if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            maxScoreField.text = nil;
            [numberpad input:@"C"];     // Clears the text field for new input
        }
    }
}

#pragma mark - Helper Methods

- (void)updateLabels
{
    maxScoreLabel.text = [NSString stringWithFormat:@"Playing to %d", [CBScore sharedCBScore].maxScore];
    [maxScoreLabel setNeedsDisplay];
}

#pragma mark - Numberpad IBAction's

- (IBAction) press:(id)sender {
    [numberpad input:[sender titleForState:UIControlStateNormal]];
    [maxScoreField setText:[numberpad displayValue]];
}

#pragma mark - View Methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Display a blinking cursor in the text field
    [maxScoreField becomeFirstResponder];
    // This prevents a keyboard from popping up, and still allows for typing in textfield
    UIView *hideKeyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    maxScoreField.inputView = hideKeyboardView; // Hide keyboard, but show blinking cursor
    [self updateLabels];
    
    // Set the text labels to their respective colors
    UIColor *labelColor = [UIColor colorWithRed:100.0/255.0 green:106.0/255.0 blue:67.0/255.0 alpha:1.0];
    maxScoreLabel.textColor = labelColor;
    maxScoreField.textColor = labelColor;
    maxScoreLabel.textAlignment = NSTextAlignmentCenter;
    maxScoreField.textAlignment = NSTextAlignmentCenter;
    
    soundButtonStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"];
    idleDisabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"isIdleDisabled"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
