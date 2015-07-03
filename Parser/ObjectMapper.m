//
//  EKParser.m
//  Parser
//
//  Created by Prajeet Shrestha on 7/3/15.
//  Copyright (c) 2015 EK Solutions Pvt Ltd. All rights reserved.
//

#import "ObjectMapper.h"

@implementation ObjectMapper

- (NSDictionary *)types {
    unsigned int count;
    objc_property_t* props = class_copyPropertyList([self class], &count);
    NSMutableDictionary *types = [NSMutableDictionary new];
    for (int i = 0; i < count; i++) {
        objc_property_t property = props[i];
        const char * name = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        const char * type = property_getAttributes(property);
        // NSString *attr = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [propertyType UTF8String];

        if (strcmp(rawPropertyType, @encode(float)) == 0) {
            [types setValue:@"float" forKey:propertyName];
            //dic = @{propertyName :@"Float" };
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            [types setValue:@"int" forKey:propertyName];
            //dic = @{propertyName : @"int" };
        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
            [types setValue:@"id" forKey:propertyName];
            //dic = @{propertyName : @"id" };
        } else {
            // According to Apples Documentation you can determine the corresponding encoding values
        }
        if ([typeAttribute hasPrefix:@"T@"]) {
            NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];  //turns @"NSDate" into NSDate
            //Class typeClass = NSClassFromString(typeClassName);
            if (typeClassName != nil) {
                // Here is the corresponding class even for nil values
            }
            [types setValue:typeClassName forKey:propertyName];
            //dic = @{propertyName : typeClass };
        }
    }
    free(props);
    return types;
}

- (void)map:(NSDictionary *)inputDictionary {
    NSDictionary *propertyAndTypes = [self types];
    NSArray *inputDictionaryKeys = [inputDictionary allKeys];
    //NSArray *propertyAndTypesKeys = [propertyAndTypes allKeys];
    for (NSString *key in inputDictionaryKeys) {
        NSString *type = propertyAndTypes[key];
        if ([type isEqualToString:@"NSNumber"]) {
            [self validateNSNumber:inputDictionary[key] andAssignToKey:key];
        }
        if ([type isEqualToString:@"NSString"]) {
            [self validateNSString:inputDictionary[key] andAssignToKey:key];
        }
        if ([type isEqualToString:@"id"]) {
            [self validateId:inputDictionary[key] andAssignToKey:key];
        }
        if ([type isEqualToString:@"NSDate"]) {
            [self validateNSDate:inputDictionary[key] andAssignToKey:key];
        }
    }
}

- (void)validateId:(id)value andAssignToKey:(NSString *)key {
    [self setValue:value forKey:key];
}

- (void)validateNSString:(id)value andAssignToKey:(NSString *)key {
    if ([value isKindOfClass:[NSString class]]) {
        [self setValue:value forKey:key];
        //NSLog(@"Mapped %@ into key %@",value, key);
    } else {
        [self setValue:nil forKey:key];
        NSLog(@"Object mapped is not a string");
    }
}

- (void)validateNSNumber:(id)value andAssignToKey:(NSString *)key {
    if ([value isKindOfClass:[NSNumber class]]) {
        [self setValue:value forKey:key];
        //NSLog(@"Mapped %@ into key %@",value, key);
    } else {
        [self setValue:nil forKey:key];
        //NSLog(@"Mapped value is not of type NSNumber");
    }
}

- (void)validateNSDate:(id)value andAssignToKey:(NSString *)key {
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dateObject = value;
        NSString *formatString = dateObject[kOMDateFormatString];
        NSString *dateValue = dateObject[kOMDateValue];
        if ([formatString isKindOfClass:[NSString class]] && [dateValue isKindOfClass:[NSString class]]) {
            NSDate *date;
            if ([formatString isEqualToString:kOMTimestamp]) {
                date = [NSDate dateWithTimeIntervalSince1970:dateValue.doubleValue];
            } else {
                date = [self convertString:dateValue intoDateObjectWithFormatString:formatString];
            }
            [self setValue:date forKey:key];
        } else {
            [self setValue:nil forKey:key];
        }
    } else {
        [self setValue:nil forKey:key];
        NSLog(@"Date value mapped incorrectly");
    }
}

- (NSDate *)convertString:(NSString *)dateString intoDateObjectWithFormatString:(NSString *)formatString  {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSDate *dateObject  = [dateFormatter dateFromString:dateString];
    return dateObject;
}

@end
