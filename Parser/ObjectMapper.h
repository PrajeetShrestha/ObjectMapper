//
//  EKParser.h
//  Parser
//
//  Created by Prajeet Shrestha on 7/3/15.
//  Copyright (c) 2015 EK Solutions Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define kOMDateFormatString @"FormatString"
#define kOMDateValue @"DateValue"
#define kOMTimestamp @"Timestamp"

@interface ObjectMapper : NSObject
- (void)map:(NSDictionary *)dictionary;
@end
