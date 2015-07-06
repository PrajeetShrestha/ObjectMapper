//
//  Object.h
//  Parser
//
//  Created by Prajeet Shrestha on 7/6/15.
//  Copyright (c) 2015 EK Solutions Pvt Ltd. All rights reserved.
//

#import "ObjectMapper.h"

@interface Object : ObjectMapper
@property (nonatomic) NSMutableArray *arrival;
@property (nonatomic) NSMutableArray *departure;
@property (nonatomic) NSDate *todaynepaltime;

@end
