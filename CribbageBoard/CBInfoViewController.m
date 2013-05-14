//
//  CBInfoViewController.m
//  CribbageBoard
//
//  Created by Tim Carlson on 5/13/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import "CBInfoViewController.h"
#import "CBSwitchViewController.h"

@interface CBInfoViewController ()

@end

@implementation CBInfoViewController

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
    }
    return self;
}

- (IBAction)backToBoard:(id)sender
{
    [CBSwitchViewController switchToBoard];
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
