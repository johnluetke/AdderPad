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
//    lastPlayerTag = 0;
//    lastPoints = 0;
//    maxScore = 121;     // Default score is for Cribbage games
    
    pOneScore = [[scoreArray objectAtIndex:0] integerValue];
    pTwoScore = [[scoreArray objectAtIndex:1] integerValue];
    pThreeScore = [[scoreArray objectAtIndex:2] integerValue];
    pFourScore = [[scoreArray objectAtIndex:3] integerValue];
    maxScore = [[scoreArray objectAtIndex:4] integerValue];
    lastPoints = [[scoreArray objectAtIndex:5] integerValue];
    lastPlayerTag = [[scoreArray objectAtIndex:6] integerValue];
}

#pragma mark - Value Change Mehods

- (void)addToPlayerOne:(int)points
{
    if (pOneScore < maxScore) {
        lastPlayerTag = 1;
        if (!points) {
            // no value entered (TODO: adds 1 when 0 is entered)
            points = 1;
        }
        
        pOneScore += points;
        lastPoints = points;
    }
}

- (void)addToPlayerTwo:(int)points
{
    if (pTwoScore < maxScore) {
        lastPlayerTag = 2;
        if (!points) {
            // no value entered (TODO: adds 1 when 0 is entered)
            points = 1;
        }
        
        pTwoScore += points;
        lastPoints = points;
    }
}

- (void)addToPlayerThree:(int)points
{
    if (pThreeScore < maxScore) {
        lastPlayerTag = 3;
        if (!points) {
            // no value entered (TODO: adds 1 when 0 is entered)
            points = 1;
        }
        
        pThreeScore += points;
        lastPoints = points;
    }
}

- (void)addToPlayerFour:(int)points
{
    if (pFourScore < maxScore) {
        lastPlayerTag = 4;
        if (!points) {
            // no value entered (TODO: adds 1 when 0 is entered)
            points = 1;
        }
        
        pFourScore += points;
        lastPoints = points;
    }
}

// Returns YES if undo was successful
- (BOOL)undoLastAdd
{
    if (lastPlayerTag == 1) {
        // red
        pOneScore = pOneScore - lastPoints;
        lastPoints = 0;
        lastPlayerTag = 0;
        return YES;
        
    } else if (lastPlayerTag == 2) {
        // green
        pTwoScore = pTwoScore - lastPoints;
        lastPoints = 0;
        lastPlayerTag = 0;
        return YES;
        
    } else if (lastPlayerTag == 3) {
        // blue
        pThreeScore = pThreeScore - lastPoints;
        lastPoints = 0;
        lastPlayerTag = 0;
        return YES;
        
    } else if (lastPlayerTag == 4) {
        // yellow
        pFourScore = pFourScore - lastPoints;
        lastPoints = 0;
        lastPlayerTag = 0;
        return YES;
    }
    return NO;
}

- (void)resetScores
{
    pOneScore = 0;
    pTwoScore = 0;
    pThreeScore = 0;
    pFourScore = 0;
    lastPoints = 0;
    lastPlayerTag = 0;
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


@end
