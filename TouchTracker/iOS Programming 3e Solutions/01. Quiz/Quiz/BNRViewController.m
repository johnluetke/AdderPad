//
//  BNRViewController.m
//  Quiz
//
//  Created by Michael Ward on 5/9/12.
//  Copyright (c) 2012 Big Nerd Ranch, Inc. All rights reserved.
//

#import "BNRViewController.h"

@implementation BNRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // load quesitons
        NSString *questionString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"txt"]];
        
        questions = [questionString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSLog(@"%@",questions);
        NSLog(@"%u",[questions count]);
        
        // load answers
        NSString *answerString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answers" ofType:@"txt"]];
        
        answers = [answerString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSLog(@"%@",answers);
        NSLog(@"%u",[answers count]);
        
        
      /*
        // Create two arrays and make the pointers point to them
        questions = [NSMutableArray array];
        answers = [NSMutableArray array];
        
        // Add questions and answers to the arrays
        // index 0
        [questions addObject:@"From what is cognac made?"];
        [answers addObject:@"Grapes"];
        
        // index 1
        [questions addObject:@"What is 7 + 7?"];
        [answers addObject:@"14"];
        
        // index 2
        [questions addObject:@"What is the capital of Vermont?"];
        [answers addObject:@"Montpelier"];
       */
        
    }
    // Return the address of the new object
    return self;
}

- (IBAction)showQuestion:(id)sender 
{
    // The following is if you want the questions displayed in order
    /*
    // Step to the next question
    currentQuestionIndex++;
    
    // Am I past the last question?
    if (currentQuestionIndex == [questions count]) {
        // If so, go back to the first question
        currentQuestionIndex = 0;
    }
    */
    
    // Get the string in the current index of the questions array
    NSString *question = [questions objectAtIndex:arc4random() % [questions count]];
    
    // Output the question string to the debug console
    NSLog(@"Displaying question: %@",question);
    
    questionField.numberOfLines = 0;
    
    // Display the string in the question text field
    [questionField setText:question];
    
    // Clear the answer text field
    [answerField setText:@"???"];
}

- (IBAction)showAnswer:(id)sender 
{
    // Get the string in the current index of the answers array
    NSString *answer = [answers objectAtIndex:arc4random() % [answers count]];
    
    answerField.numberOfLines = 0;
    
    // Display the answer string in the answer text field
    [answerField setText:answer];
}
@end
