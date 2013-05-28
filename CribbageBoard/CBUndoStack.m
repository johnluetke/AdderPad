//
//  CBUndoStack.m
//  CribbageBoard
//
//  Created by Tim Carlson on 5/28/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import "CBUndoStack.h"

@implementation CBUndoStack
@synthesize count;

- (id)init
{
    if( self=[super init] )
    {
        m_array = [[NSMutableArray alloc] init];
        count = 0;
    }
    return self;
}

- (void)push:(int)anInt
{
    NSNumber *anObject = [[NSNumber alloc] initWithInt:anInt];
    [m_array addObject:anObject];
    count = m_array.count;
}

- (int)pop
{
    id obj = nil;
    if (m_array.count > 0) {
        [m_array removeLastObject];
        count = m_array.count;
    }
    
    int poppedNum = [obj integerValue];
    return poppedNum;
}

- (void)clear
{
    [m_array removeAllObjects];
    count = 0;
}

@end