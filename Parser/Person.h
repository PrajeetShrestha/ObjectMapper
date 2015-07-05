//
//  Person.h
//  Parser
//
//  Created by Prajeet Shrestha on 7/3/15.
//  Copyright (c) 2015 EK Solutions Pvt Ltd. All rights reserved.
//


#import "ObjectMapper.h"

@interface Person :ObjectMapper
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *age;
@property (nonatomic) NSDate *dateOfBirth;


@end
