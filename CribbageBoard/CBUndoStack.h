//
//  CBUndoStack.h
//  CribbageBoard
//
//  Created by Tim Carlson on 5/28/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBUndoStack : NSObject {
    NSMutableArray* m_array;
    int count;
}

@property (nonatomic, readonly) int count;

- (void)push:(int)anInt;
- (int)pop;
- (void)clear;

@end