//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Tim Carlson on 3/29/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@implementation TouchDrawView

- (id)initWithFrame:(CGRect)r
{
    self = [super initWithFrame:r];
    
    if (self) {
        linesInProcess = [[NSMutableDictionary alloc] init];
        completeLines = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setMultipleTouchEnabled:YES];     // Single touch only is the default
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // Draw complete lines in black
    
    [[UIColor blackColor] set];
    for (Line *line in completeLines) {
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    // Draw lines in process red
    [[UIColor redColor] set];
    for (NSValue *v in linesInProcess) {
        Line *line = [linesInProcess objectForKey:v];   // Find is line in the dictionary
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
}

- (void)clearAll
{
    [linesInProcess removeAllObjects];
    [completeLines removeAllObjects];
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches
{
    // Remove ending touches from dictionary
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Line *line = [linesInProcess objectForKey:key];
        
        // Double tpas are not added to array
        if (line) {
            [completeLines addObject:line];
            [linesInProcess removeObjectForKey:key];
        }
    }
    // Redraw line
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        // Is this a double tap?
        if ([t tapCount] > 1) {
            [self clearAll];
            return;
        }
        
        // Use the touch object (packed in an NSValue) as the key
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        // Create a line for the value
        CGPoint loc = [t locationInView:self];
        Line *newLine = [[Line alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];
        
        // Put the pair in the dictionary
        [linesInProcess setObject:newLine forKey:key];
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Update lines in process with moved touches
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        // Find the line for this touch
        Line *line = [linesInProcess objectForKey:key];
        
        // Update the line
        CGPoint loc = [t locationInView:self];
        [line setEnd:loc];
    }
    // Redraw the line
    [self setNeedsDisplay];
}

// User was done drawing
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

// User's drawing was interrupted by system
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}





@end
