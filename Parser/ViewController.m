//
//  ViewController.m
//  Parser
//
//  Created by Prajeet Shrestha on 7/3/15.
//  Copyright (c) 2015 EK Solutions Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Friend.h"
#import "Animal.h"
#import "AFNetworking.h"
#import "Flight.h"
#import "Object.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSDictionary *mapObject = @{
    //                                @"name_":@"Hari",
    //                                @"age":@14,
    //                                @"date_of_birth":@{
    //                                        kOMDateFormatString:kOMTimestamp,//@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
    //                                        kOMDateValue:@"12321321"//@"2015-05-02T03:22:54.139Z"
    //                                        },
    //                                @"friends":@[
    //                                        @{@"name":@"Prajeet"},
    //                                        @{@"name":@"Superman"},
    //                                        @{@"name":@"Ganesh"},
    //                                        @{@"name":@"Ujjawal"}],
    //                                @"animals":@[
    //                                        @{@"name":@"Rhino"},
    //                                        @{@"name":@"Donkey"},
    //                                        @{@"name":@"Zebra"},
    //                                        @{@"name":@"Harkey"}]
    //                                };
    //    NSDictionary *innerMap = @{
    //                               @"friends":[Friend class],
    //                               @"animals":[Animal class]
    //                               };
    //    [self initiateNetworkRequest];
    //
    //
    //
    //    Person *person = [Person new];
    //    person.innerMap = innerMap;
    //    [person map:mapObject];
    //    for (Friend *friend in person.friends){
    //        NSLog(@"%@",friend.name);
    //    }
    //    for (Animal *animal in person.animals){
    //        NSLog(@"%@",animal.name);
    //    }
    //
    ////
    ////    NSDictionary *animalObject = @{@"name":@"Hippo",
    ////                                   @"numberOfLegs":@25
    ////                                   };
    // //   Animal *animal = [Animal new];
    ////    [animal map:animalObject];
    //    NSLog(@"Name: %@, Age: %@ DateOfBirth: %@",person.name,person.age,person.dateOfBirth);
    ////    NSLog(@"Name: %@, NumberofLegs: %@",animal.name,animal.numberOfLegs);
    [self initiateNetworkRequest];
}

- (void)initiateNetworkRequest {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *param = @{@"apikey":@"TurnLJFLTqELsnVrFvduxqRo4XNic96XfKZ3LYewy7aEaiezRzzBRea66aEajmCP"};
    [manager GET:@"http://flightstatsnepal.com/apiv0-0-1/json-today-flight.php" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);

        NSDictionary *innerMap = @{
                                   @"arrival":[Flight class],
                                   @"departure":[Flight class],
                                   };
        //If it's site send kOMTimeStamp as formatter
        NSDictionary *dateFormatters = @{@"todaynepaltime":@"yyyy-MM-dd HH:mm:ss"//@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                         //@"2015-05-02T03:22:54.139Z"
                                         };
        Object *object = [Object new];
         object.innerMap = innerMap;
        object.dateFormatters = dateFormatters;
        [object map:responseObject];
        NSLog(@"%@ Today's Time",object.todaynepaltime);
        for (Flight *flight in object.arrival){
               NSLog(@"%@ Flight",flight.airline_name);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
