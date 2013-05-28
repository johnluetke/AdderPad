//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Tim Carlson on 3/29/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchDrawView : UIView // UIView is the super class
{
    NSMutableDictionary *linesInProcess;    // Lines that are still being drawn
    NSMutableArray *completeLines;          // Lines that have been finished.
}
- (void)clearAll;
- (void)endTouches:(NSSet *)touches;

@end
