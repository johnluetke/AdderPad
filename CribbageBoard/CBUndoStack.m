//
//  CBUndoStack.m
//  CribbageBoard
//
//  Created by Tim Carlson on 5/28/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import "CBUndoStack.h"

@implementation CBUndoStack

- (id)init
{
    if (self = [super init]) {
        contents = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)push:(id)object
{
    [contents addObject:object];
}

- (id)pop
{
    NSUInteger count = [contents count];
    if (count > 0) {
        id returnObject = [contents objectAtIndex:count - 1];
        [contents removeLastObject];
        return returnObject;
    }
    else {
        return nil;
    }
}

- (void)clear
{
    [contents removeAllObjects];
}

- (BOOL)canUndo
{
    return [contents count] ? YES : NO;
}

- (int)count
{
    return [contents count];
}

@end