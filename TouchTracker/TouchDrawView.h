//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Tim Carlson on 3/29/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Line;

@interface TouchDrawView : UIView // UIView is the super class
{
    NSMutableDictionary *linesInProcess;    // Lines that are still being drawn
    NSMutableArray *completeLines;          // Lines that have been finished.
}
@property (nonatomic, weak) Line *selectedLine;

- (Line *)lineAtPoint:(CGPoint)p;
- (void)clearAll;
- (void)endTouches:(NSSet *)touches;

@end
