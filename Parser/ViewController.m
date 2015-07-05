//
//  ViewController.m
//  Parser
//
//  Created by Prajeet Shrestha on 7/3/15.
//  Copyright (c) 2015 EK Solutions Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Animal.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *mapObject = @{
                                @"name_":@"Hari",
                                @"age":@14,
                                @"date_of_birth":@{
                                        kOMDateFormatString:kOMTimestamp,//@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                                        kOMDateValue:@"12321321"//@"2015-05-02T03:22:54.139Z"
                                        }
                                };
    Person *person = [Person new];
    [person map:mapObject];
    NSDictionary *animalObject = @{@"name":@"Hippo",
                                   @"numberOfLegs":@25
                                   };
    Animal *animal = [Animal new];
    [animal map:animalObject];
    NSLog(@"Name: %@, Age: %@ DateOfBirth: %@",person.name,person.age,person.dateOfBirth);
    NSLog(@"Name: %@, NumberofLegs: %@",animal.name,animal.numberOfLegs);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
