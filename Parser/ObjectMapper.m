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

    NSMutableDictionary *trimmedDictionary = [NSMutableDictionary new];
    for (NSString *key in inputDictionaryKeys) {
        NSString *trimmedKey = key;//[self trimKey:key];
        [trimmedDictionary setValue:inputDictionary[key] forKey:trimmedKey];
    }
    //NSArray *propertyAndTypesKeys = [propertyAndTypes allKeys];
    for (NSString *key in [propertyAndTypes allKeys]) {
        NSLog(@"%@",key);
        NSString *type = propertyAndTypes[key];
        NSString *trimmedDicKey = key.lowercaseString;
        if ([type isEqualToString:@"NSNumber"]) {
            [self validateNSNumber:trimmedDictionary[trimmedDicKey] andAssignToKey:key forObject:self];
        }
        if ([type isEqualToString:@"NSString"]) {
            [self validateNSString:trimmedDictionary[trimmedDicKey] andAssignToKey:key forObject:self];
        }
        if ([type isEqualToString:@"id"]) {
            [self validateId:trimmedDictionary[trimmedDicKey] andAssignToKey:key forObject:self];
        }
        if ([type isEqualToString:@"NSDate"]) {
            [self validateNSDate:trimmedDictionary[trimmedDicKey] andAssignToKey:key forObject:self];
        }

        if ([type isEqualToString:@"NSMutableArray"]) {

            NSArray *innerMapKeys = [self.innerMap allKeys];
            for (NSString *key in innerMapKeys){
                if ([key isEqualToString:trimmedDicKey]) {
                    NSMutableArray *arrayOfObjects = [NSMutableArray new];
                    NSArray *arrayValue = trimmedDictionary[trimmedDicKey];
                    id mappedClass = [self.innerMap[key] class];
                    for (NSDictionary *dictionary in arrayValue){
                        id object = [mappedClass new];
                        NSDictionary *propertyAndTypes = [self typesForInnerObject:object];
                        [self mapInnerArray:dictionary withPropertyAndTypes:propertyAndTypes forObject:object];
                        [arrayOfObjects addObject:object];
                    }
                    [self setValue:arrayOfObjects forKey:key];
                }
            }
        }
    }
}

- (void)mapInnerArray:(NSDictionary *)inputDictionary withPropertyAndTypes:(NSDictionary *)propertyAndTypes forObject:obj1 {

    NSArray *inputDictionaryKeys = [inputDictionary allKeys];

    NSMutableDictionary *trimmedDictionary = [NSMutableDictionary new];
    for (NSString *key in inputDictionaryKeys) {
        NSString *trimmedKey = key;//[self trimKey:key];
        [trimmedDictionary setValue:inputDictionary[key] forKey:trimmedKey];
    }
    //NSArray *propertyAndTypesKeys = [propertyAndTypes allKeys];
    for (NSString *key in [propertyAndTypes allKeys]) {
        NSString *type = propertyAndTypes[key];
        NSString *trimmedDicKey = key.lowercaseString;
        if ([type isEqualToString:@"NSNumber"]) {
            [self validateNSNumber:trimmedDictionary[trimmedDicKey] andAssignToKey:key forObject:obj1];
        }
        if ([type isEqualToString:@"NSString"]) {
            [self validateNSString:trimmedDictionary[trimmedDicKey] andAssignToKey:key forObject:obj1];
        }
        if ([type isEqualToString:@"id"]) {
            [self validateId:trimmedDictionary[trimmedDicKey] andAssignToKey:key forObject:obj1];
        }
        if ([type isEqualToString:@"NSDate"]) {
            [self validateNSDate:trimmedDictionary[trimmedDicKey] andAssignToKey:key forObject:obj1];
        }
    }
}

- (void)validateId:(id)value andAssignToKey:(NSString *)key  forObject:(id)object{
    [object setValue:value forKey:key];
}

- (void)validateNSString:(id)value andAssignToKey:(NSString *)key  forObject:(id)object{
    if ([value isKindOfClass:[NSString class]]) {
        [object setValue:value forKey:key];
        //NSLog(@"Mapped %@ into key %@",value, key);
    } else if ([value isKindOfClass:[NSNumber class]]){
        [object setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    } else {
        [object setValue:nil forKey:key];
        //NSLog(@"Object mapped is not a string and is %@",[value class]);
    }
}

- (void)validateNSNumber:(id)value andAssignToKey:(NSString *)key  forObject:(id)object {
    if ([value isKindOfClass:[NSNumber class]]) {
        [object setValue:value forKey:key];
        //NSLog(@"Mapped %@ into key %@",value, key);
    } else {
        [object setValue:nil forKey:key];
        //NSLog(@"Mapped value is not of type NSNumber");
    }
}

- (void)validateNSDate:(id)value andAssignToKey:(NSString *)key forObject:(id)object {
    NSString *formatString;
    for (NSString *formatterKey in self.dateFormatters){
        if ([formatterKey isEqualToString:key]) {
            formatString = self.dateFormatters[formatterKey];
        }
    }
    if (formatString) {
        NSString *dateValue = value;
        if ([formatString isKindOfClass:[NSString class]] && [dateValue isKindOfClass:[NSString class]]) {
            NSDate *date;
            if ([formatString isEqualToString:kOMTimestamp]) {
                date = [NSDate dateWithTimeIntervalSince1970:dateValue.doubleValue];
            } else {
                date = [self convertString:dateValue intoDateObjectWithFormatString:formatString];
            }
            [object setValue:date forKey:key];
        } else {
            [object setValue:nil forKey:key];
        }
    }
}

- (NSDate *)convertString:(NSString *)dateString intoDateObjectWithFormatString:(NSString *)formatString  {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    [dateFormatter setTimeZone      : [NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *dateObject  = [dateFormatter dateFromString:dateString];
    return dateObject;
}

- (NSString *)trimKey:(NSString *)string {
    NSString *trimmedKey = [string
                            stringByReplacingOccurrencesOfString:@"_" withString:@""];
    return trimmedKey.lowercaseString ;
}

- (NSDictionary *)typesForInnerObject:(id)object {
    unsigned int count;
    objc_property_t* props = class_copyPropertyList([object class], &count);
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

@end
