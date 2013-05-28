//
//  TouchDrawLines.h
//  TouchTracker
//
//  Created by Tim Carlson on 4/2/13.
//  Copyright (c) 2013 Tim G Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TouchDrawLines : NSManagedObject

@property (nonatomic, strong) NSArray *completeLines;

@end
