//
//  CBUndoStack.h
//  CribbageBoard
//
//  Created by Tim Carlson on 5/28/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBUndoStack : NSObject {
    @private
    NSMutableArray *contents;   // This will be the stack
}

- (void)push:(id)object;
- (id)pop;
- (void)clear;
- (BOOL)canUndo;    // Returns NO if stack is empty, avoiding external conflicts
- (int)count;   // Returns the number of objects in stack

@end