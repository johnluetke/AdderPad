//
//  CBSwitchViewController.m
//  CribbageBoard
//
//  Created by Tim Carlson on 5/13/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import "CBSwitchViewController.h"
#import "CBBoardViewController.h"
#import "CBInfoViewController.h"

@interface CBSwitchViewController ()

@end

@implementation CBSwitchViewController

@synthesize boardVC;
@synthesize infoVC;

static CBSwitchViewController *instance = NULL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (void)switchToBoard
{
    if (instance.boardVC.view.superview == nil) {
        if (instance.boardVC == nil) {
            instance.boardVC = [[CBBoardViewController alloc] initWithNibName:@"CBBoardViewController" bundle:nil];
        }
        UIViewAnimationOptions animation;
        float transitionTime = 0.5;
        animation = UIViewAnimationOptionTransitionFlipFromRight;
        
        [UIView transitionWithView:instance.view
                          duration:transitionTime
                           options: animation
                        animations:^{
                            [instance.boardVC viewWillAppear:YES];
                            [instance.infoVC viewWillDisappear:YES];
                            
                            [instance.infoVC.view removeFromSuperview];
                            [instance.view insertSubview:instance.boardVC.view atIndex:0];
                            
                            [instance.boardVC viewDidAppear:YES];
                            [instance.infoVC viewDidDisappear:YES];
                        }
                        completion:nil];
    }
}

+(void)switchToInfo
{
    if (instance.infoVC.view.superview == nil)
    {
        if (instance.infoVC == nil)
        {
            instance.infoVC = [[CBInfoViewController alloc] initWithNibName:@"CBInfoViewController" bundle:nil];
        }
        
        [UIView transitionWithView:instance.view
                          duration:0.5
                           options: UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [instance.infoVC viewWillAppear:YES];
                            [instance.boardVC viewWillDisappear:YES];
                            
                            [instance.boardVC.view removeFromSuperview];
                            [instance.view insertSubview:instance.infoVC.view atIndex:0];
                            
                            [instance.infoVC viewWillAppear:YES];
                            [instance.boardVC viewWillDisappear:YES];
                        }
                        completion:nil];
    }
}

#pragma mark - Memory Warnings

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    instance = self;
    self.boardVC = [[CBBoardViewController alloc] initWithNibName:@"CBBoardViewController" bundle:nil];
    [self.view insertSubview:boardVC.view atIndex:0];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
