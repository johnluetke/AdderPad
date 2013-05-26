//
//  CBScore.h
//  CribbageBoard
//
//  Created by Tim Carlson on 5/24/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//
//  @class CBScore
//  Handles the data for the score
//  Plist Player Reference: Red=0, Green=1, Blue=2, Yellow=3
//

#import <Foundation/Foundation.h>

@interface CBScore : NSObject
{
    @private
        int redScore, greenScore, blueScore, yellowScore;
        int lastPoints, lastPlayerTag;  // Used for the undo method
        // lastPlayerTag: Red=1, Green=2, Blue=3, Yellow=4
}

@property (nonatomic, assign) int redScore;
@property (nonatomic, assign) int greenScore;
@property (nonatomic, assign) int blueScore;
@property (nonatomic, assign) int yellowScore;
@property (nonatomic, assign) int lastPoints;

// Takes in a plist (filepath in a string) and sets the numbers
- (CBScore *)initWithArray:(NSMutableArray *)scoreArray;

- (void)addToRed:(int)points;
- (void)addToGreen:(int)points;
- (void)addToBlue:(int)points;
- (void)addToYellow:(int)points;


- (void)resetScores;
- (BOOL)undoLastAdd;


@end