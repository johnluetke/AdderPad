//
//  CBScore.h
//  CribbageBoard
//
//  Created by Tim Carlson on 5/24/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//
//  @class CBScore
//  Handles the data for the score
//  Plist Player Reference: 0=Player One, 1=Player Two, 2=Player Three, 3=Player Four
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "CBUndoStack.h"

@interface CBScore : NSObject
{
    @private
        int pOneScore, pTwoScore, pThreeScore, pFourScore;
        int maxScore;
        int lastPoints, lastPlayerTag;  // lastPlayerTag returns the player number
        CBUndoStack *gameStateStack;
}

@property (nonatomic, readonly) int pOneScore;
@property (nonatomic, readonly) int pTwoScore;
@property (nonatomic, readonly) int pThreeScore;
@property (nonatomic, readonly) int pFourScore;
@property (nonatomic, readonly) int maxScore;
@property (nonatomic, readonly) int lastPoints;
@property (nonatomic, readonly) int lastPlayerTag;

// Singleton Macros
CWL_DECLARE_SINGLETON_FOR_CLASS(CBScore);

// Takes in a plist (filepath in a string) and sets the numbers
- (void)initWithArray:(NSMutableArray *)scoreArray;

- (void)addToPlayerOne:(int)points;
- (void)addToPlayerTwo:(int)points;
- (void)addToPlayerThree:(int)points;
- (void)addToPlayerFour:(int)points;

- (void)setMaxScore:(int)maxScore;

- (void)resetScores;
- (BOOL)undoLastAdd;
- (void)addStateToStack;

@end