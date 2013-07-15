//
//  CBScore.m
//  CribbageBoard
//
//  Created by Tim Carlson on 5/24/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import "CBScore.h"

@implementation CBScore

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(CBScore);
@synthesize pOneScore, pTwoScore, pThreeScore, pFourScore, maxScore, lastPoints, lastPlayerTag;

#pragma mark - Initializaton Methods

- (void)initWithArray:(NSMutableArray *)scoreArray
{    
    pOneScore = [[scoreArray objectAtIndex:0] integerValue];
    pTwoScore = [[scoreArray objectAtIndex:1] integerValue];
    pThreeScore = [[scoreArray objectAtIndex:2] integerValue];
    pFourScore = [[scoreArray objectAtIndex:3] integerValue];
    maxScore = [[scoreArray objectAtIndex:4] integerValue];
    lastPoints = [[scoreArray objectAtIndex:5] integerValue];
    lastPlayerTag = [[scoreArray objectAtIndex:6] integerValue];
    
    gameStateStack = [[CBUndoStack alloc] init];
    [self addStateToStack];
}

#pragma mark - Value Change Mehods

- (void)addToPlayerOne:(int)points
{
    if (pOneScore > -999999) {
        if (pOneScore < maxScore) {
            lastPlayerTag = 1;
            pOneScore += points;
            lastPoints = points;
            
            [self addStateToStack];
        }
    }
    // TODO: Inform user that score can't go any more negative
}

- (void)addToPlayerTwo:(int)points
{
    if (pOneScore > -999999) {
        if (pTwoScore < maxScore) {
            lastPlayerTag = 2;
            pTwoScore += points;
            lastPoints = points;
            
            [self addStateToStack];
        }
    }
    // TODO: Inform user that score can't go any more negative
}

- (void)addToPlayerThree:(int)points
{
    if (pOneScore > -999999) {
        if (pThreeScore < maxScore) {
            lastPlayerTag = 3;
            pThreeScore += points;
            lastPoints = points;
            
            [self addStateToStack];
        }
    }
    // TODO: Inform user that score can't go any more negative
}

- (void)addToPlayerFour:(int)points
{
    if (pOneScore > -999999) {
        if (pFourScore < maxScore) {
            lastPlayerTag = 4;
            pFourScore += points;
            lastPoints = points;
            
            [self addStateToStack];
        }
    }
    // TODO: Inform user that score can't go any more negative
}

// Reverts game state back to state prior to last add.
// Returns YES if undo was successful
- (BOOL)undoLastAdd
{
    // Nothing to Undo
    if ([gameStateStack count] != 1) {
        if ([gameStateStack canUndo]) {
            [gameStateStack pop];
            NSMutableArray *undoArray = [[NSMutableArray alloc] initWithArray:[gameStateStack pop]];
            [self setAllValuesWithArray:undoArray];
            [gameStateStack push:undoArray]; // So that next undo can occur
            return YES;
        }
    }
    return NO;
}

// This also resets |gameStateStack|
// User should be warned of reset since it won't be possible to undo last add after reset.
- (void)resetScores
{
    pOneScore = 0;
    pTwoScore = 0;
    pThreeScore = 0;
    pFourScore = 0;
    lastPoints = 0;
    lastPlayerTag = 0;
    
    [gameStateStack clear];
    [self addStateToStack];     // So stack is not empty.
}

- (void)addStateToStack
{
    // Of the form {0, 0, 0, 0, maxScore, lastPoints, lastPlayerTag}.  0's are player scores.
    NSArray *currState = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithInt:pOneScore],
                          [[NSNumber alloc] initWithInt:pTwoScore], [[NSNumber alloc] initWithInt:pThreeScore],
                          [[NSNumber alloc] initWithInt:pFourScore], [[NSNumber alloc] initWithInt:maxScore],
                          [[NSNumber alloc] initWithInt:lastPoints], [[NSNumber alloc] initWithInt:lastPlayerTag], nil];
    
    [gameStateStack push:currState];
}

#pragma mark - Getter Methods

- (int)pOneScore
{
    return pOneScore;
}

- (int)pTwoScore
{
    return pTwoScore;
}

- (int)pThreeScore
{
    return pThreeScore;
}

- (int)lastPoints
{
    return lastPoints;
}

- (int)maxScore
{
    return maxScore;
}

// Returns the number of the last player to go
- (int)lastPlayerTag
{
    return lastPlayerTag;
}

#pragma mark - Setter Methods

- (void)setMaxScore:(int)score
{
    maxScore = score;
}

#pragma mark - Private Methods

// Helper method for under method
- (void)setAllValuesWithArray:(NSMutableArray *)values
{
    pOneScore = [[values objectAtIndex:0] integerValue];
    pTwoScore = [[values objectAtIndex:1] integerValue];
    pThreeScore = [[values objectAtIndex:2] integerValue];
    pFourScore = [[values objectAtIndex:3] integerValue];
    maxScore = [[values objectAtIndex:4] integerValue];
    lastPoints = [[values objectAtIndex:5] integerValue];
    lastPlayerTag = [[values objectAtIndex:6] integerValue];
}

@end
