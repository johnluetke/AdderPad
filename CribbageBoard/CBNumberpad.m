//
//  CBNumberpad.m
//  CribbageBoard
//
//  Created by Tim Carlson on 5/23/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//
//

#import "CBNumberpad.h"

// These are the valid characters that can be accepted...
const NSString *Digits = @"0123456789.";
const NSString *Delete = @"D";
const NSString *Clear = @"C";
const int charMax = 6;  // max characters allowed in text field, will not add beyond this

@implementation CBNumberpad

#pragma mark Lifecycle

- init {
    if ((self = [super init])) {
        _display = [NSMutableString stringWithCapacity:10];
        charCounter = 0;
    }
    return self;
}

#pragma mark Calculator Operation

- (void)input:(NSString *)inputChar
{
    BOOL badCharacter;
        
    // Does inputChar contain exactly one character?
    if (!(badCharacter = !(inputChar && [inputChar length] == 1))) {
        
        // Is inputChar in Digits?
        if ([Digits rangeOfString: inputChar].length) {
            // Add inputChar to _display.
            if (charCounter < charMax) {
                [_display appendString:inputChar];
                charCounter++;
            }
        }

        // Is inputChar Delete?
        else if ([inputChar isEqualToString:(NSString *)Delete]) {
            // Remove the rightmost character from _display.
            NSInteger index_of_char_to_remove = [_display length] - 1;
            if (index_of_char_to_remove >= 0) {
                [_display deleteCharactersInRange:NSMakeRange(index_of_char_to_remove, 1)];
                charCounter--;
            }
        }
        // Is inputChar Clear?
        else if ([inputChar isEqualToString:(NSString *)Clear]) {
            // If there's something in _display, clear it.
            if ([_display length]) {
                [_display setString:[NSString string]];
                charCounter = 0;
            }
        }
        else {
            // inputChar is an unexpected (invalid) character.
            badCharacter = TRUE;
        }
    }
    if (badCharacter) {
        // Raise exception for unexpected character.
        NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                         reason:@"The inputChar parameter contains an unexpected value."
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys: inputChar, @"arg0", nil]];
        [exception raise];
    }
    
}

#pragma mark Outlets


//The displayValue method rerutns a copy of _display.
- (NSString *)displayValue
{
    if ([_display length]) {
        return [_display copy];
    }
    return @"";
}

- (int)maxCharAllowed
{
    return charMax;
}

@end
