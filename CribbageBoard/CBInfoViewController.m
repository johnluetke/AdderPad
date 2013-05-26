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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            [[NSBundle mainBundle] loadNibNamed:@"CBInfoViewController" owner:self options:nil];
        }
        if(result.height == 568)
        {
            // iPhone 5
            [[NSBundle mainBundle] loadNibNamed:@"CBInfoViewController-5" owner:self options:nil];
        }
    }
    if (self) {
        // Custom initialization
        numberpad = [[CBNumberpad alloc] init];
        charMax = numberpad.maxCharAllowed;
        maxScoreField.delegate = self;
    }
    return self;
}

- (IBAction)backToBoard:(id)sender
{
    [CBSwitchViewController switchToBoard];
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
