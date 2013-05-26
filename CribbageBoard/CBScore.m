//
//  CBScore.m
//  CribbageBoard
//
//  Created by Tim Carlson on 5/24/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import "CBScore.h"

@implementation CBScore

@synthesize redScore, greenScore, blueScore, yellowScore, lastPoints;

#pragma mark - Initializaton Methods

- (CBScore *)initWithArray:(NSMutableArray *)scoreArray
{
    lastPlayerTag = 0;
    lastPoints = 0;
    
    redScore = [[scoreArray objectAtIndex:0] integerValue];
    greenScore = [[scoreArray objectAtIndex:1] integerValue];
    blueScore = [[scoreArray objectAtIndex:2] integerValue];
    yellowScore = [[scoreArray objectAtIndex:3] integerValue];
    
    return self;
}

#pragma mark - Value Change Mehods

- (void)addToRed:(int)points
{
    lastPlayerTag = 1;
    
    if (!points) {
        // no value entered (TODO: adds 1 when 0 is entered)
        points = 1;
    }
    
    redScore += points;
    lastPoints = points;
}

- (void)addToGreen:(int)points
{
    lastPlayerTag = 2;
    
    if (!points) {
        // no value entered (TODO: adds 1 when 0 is entered)
        points = 1;
    }
    
    greenScore += points;
    lastPoints = points;
}

- (void)addToBlue:(int)points
{
    lastPlayerTag = 3;
    
    if (!points) {
        // no value entered (TODO: adds 1 when 0 is entered)
        points = 1;
    }
    
    blueScore += points;
    lastPoints = points;
}

- (void)addToYellow:(int)points
{
    lastPlayerTag = 4;
    
    if (!points) {
        // no value entered (TODO: adds 1 when 0 is entered)
        points = 1;
    }
    
    yellowScore += points;
    lastPoints = points;
}

// Returns YES if undo was successful
- (BOOL)undoLastAdd
{
    if (lastPlayerTag == 1) {
        // red
        redScore = redScore - lastPoints;
        lastPoints = 0;
        return YES;
        
    } else if (lastPlayerTag == 2) {
        // green
        greenScore = greenScore - lastPoints;
        lastPoints = 0;
        return YES;
        
    } else if (lastPlayerTag == 3) {
        // blue
        blueScore = blueScore - lastPoints;
        lastPoints = 0;
        return YES;
        
    } else if (lastPlayerTag == 4) {
        // yellow
        yellowScore = yellowScore - lastPoints;
        lastPoints = 0;
        return YES;
    }
    return NO;
}

// Returns YES if reset was needed
- (void)resetScores
{
    redScore = 0;
    greenScore = 0;
    blueScore = 0;
    yellowScore = 0;
    lastPoints = 0;
    lastPlayerTag = 0;
}

#pragma mark - Getter Methods

- (int)redScore
{
    return redScore;
}

- (int)greenScore
{
    return greenScore;
}

- (int)blueScore
{
    return blueScore;
}

- (int)lastPoints
{
    return lastPoints;
}


@end
