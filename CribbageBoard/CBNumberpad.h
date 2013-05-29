//
//  CBNumberpad.h
//  CribbageBoard
//
//  Created by Tim Carlson on 5/23/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//
//
// @class Calculator
// This class implements a simulated numberpad to teft field engine.
// @throws NSInvalidArgumentException
//


#import <Foundation/Foundation.h>

@interface CBNumberpad : NSObject
{
    @private
        NSMutableString *_display;  // The "add to score field" display
        int charCounter;    // for limiting the number of characters entered
}

- init;

/*!
 * @method input:
 * Receives input into the calculator.
 *
 * Valid characters:
 *
 *     Digits:      .0123456789
 *
 *     Commands:    D   Delete
 *                  C   Clear
 */
- (void)input:(NSString *)inputChar;

/*!
 * @method displayValue
 * Provides the value in the addToScoreField
 */
- (NSString *)displayValue;

/*!
 * @method maxCharAllow
 * Provides the value in the max characters allowed in text field
 */
- (int)maxCharAllowed;

@end
