//
//  main.m
//  ProjectEuler
//
//  PROBLEM 16 ---
//  2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
//  What is the sum of the digits of the number 2^1000?
//
//  Created by Tim Carlson on 4/19/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "math.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        long long sumResult = 0;
        long long exponent = pow(2, 15);
        
        NSLog(@"%lld", exponent);
        
        while (exponent != 0) {
            sumResult += exponent % 10;
            exponent = exponent / 10;
        }
        
        NSLog(@"%lld", sumResult);
        
    }
    return 0;
}

