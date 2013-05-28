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
@synthesize selectedLine;

- (id)initWithFrame:(CGRect)r
{
    self = [super initWithFrame:r];
    
    if (self) {
        linesInProcess = [[NSMutableDictionary alloc] init];
        completeLines = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setMultipleTouchEnabled:YES];     // Single touch only is the default
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    // Draw selected lines in green
    if ([self selectedLine]) {
        [[UIColor greenColor] set];
        CGContextMoveToPoint(context, [[self selectedLine] begin].x, [[self selectedLine] begin].y);
        CGContextAddLineToPoint(context, [[self selectedLine] end].x, [[self selectedLine] end].y);
        CGContextStrokePath(context);
    }
}

- (void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized tap");
    
    CGPoint point = [gr locationInView:self];
    [self setSelectedLine:[self lineAtPoint:point]];
    
    // prevents a "dot" from being drawn on taps
    [linesInProcess removeAllObjects];
    
    if ([self selectedLine]) {
        [self becomeFirstResponder];
        
        // Grab the menu controller
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete"
                                                            action:@selector(deleteLine:)];
        [menu setMenuItems:[NSArray arrayWithObject:deleteItem]];
        
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    } else {
        // Hide the menu if no line is selected
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

// Returns the line close to the point that the user selected
- (Line *)lineAtPoint:(CGPoint)p
{
    // Find a line close to p
    for (Line *l in completeLines) {
        CGPoint start = [l begin];
        CGPoint end = [l end];
        
        // Check a few points on the line
        for (float t = 0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            // Tap should be within 10 points of the line
            if (hypotf(x - p.x, y - p.y) < 10.0) {
                return l;
            }
        }
    }
    return nil;
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
    // This if statement should solve SILVER PROBLEM
    if (![self selectedLine]) {
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

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)deleteLine:(id)sender
{
    [completeLines removeObject:[self selectedLine]];
    [self setNeedsDisplay];
}



@end
