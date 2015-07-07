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
    CGRect rect = CGRectMake(0, 0, 100, 30);
    UITextField *field = [UITextField new];
    field.frame = rect;
    [self.view addSubview:field];
    field.borderStyle = UITextBorderStyleLine;
    field.enabled = YES;
    [self initiateNetworkRequest];


    NSDictionary *mapObject = @{
                                @"name_":@"Hari",
                                @"age":@14,
                                @"date_of_birth":@{
                                        kOMDateFormatString:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",//kOMTimestamp,//@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                                        kOMDateValue:@"2015-05-02T03:22:54.139Z"//@"12321321"//@"2015-05-02T03:22:54.139Z"
                                        }
                                };
    Person *person = [Person new];
    [person manualMapping:mapObject];
    NSDictionary *animalObject = @{@"name":@"Hippo",
                                   @"numberOfLegs":@25
                                   };
    Animal *animal = [Animal new];
    [animal map:animalObject];
    NSLog(@"Name: %@, Age: %@ DateOfBirth: %@",person.name,person.age,person.dateOfBirth);
    NSLog(@"Name: %@, NumberofLegs: %@",animal.name,animal.numberOfLegs);
}

- (void)initiateNetworkRequest {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *param = @{@"apikey":@"TurnLJFLTqELsnVrFvduxqRo4XNic96XfKZ3LYewy7aEaiezRzzBRea66aEajmCP"};
    [manager GET:@"http://flightstatsnepal.com/apiv0-0-1/json-today-flight.php" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *innerMap = @{
                                   @"arrival":[Flight class],
                                   @"departure":[Flight class],
                                   };
        //If it's date is coming in timestamp format send kOMTimeStamp as formatter
        NSDictionary *dateFormatters = @{@"todaynepaltime" : @"yyyy-MM-dd HH:mm:ss",
                                         kOMZuluformatter : @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                                         };
        Object *object = [Object new];
        object.innerMap = innerMap;
        object.dateFormatters = dateFormatters;

        

//        [object map:responseObject];
//        for (Flight *flight in object.arrival){
//            NSLog(@"%@ Arrival ariline Name",flight.airline_name);
//        }
//        for (Flight *flight in object.departure){
//            NSLog(@"%@ Departure airline Name",flight.airline_name);
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Creating core data model programatically 
/*
 
 //Reference: http://www.cocoanetics.com/2012/04/creating-a-coredata-model-in-code/
- (NSManagedObjectModel *)_model
{
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];

    // create the entity
    NSEntityDescription *entity = [[NSEntityDescription alloc] init];
    [entity setName:@"DTCachedFile"];
    [entity setManagedObjectClassName:@"DTCachedFile"];

    // create the attributes
    NSMutableArray *properties = [NSMutableArray array];

    NSAttributeDescription *remoteURLAttribute = [[NSAttributeDescription alloc] init];
    [remoteURLAttribute setName:@"remoteURL"];
    [remoteURLAttribute setAttributeType:NSStringAttributeType];
    [remoteURLAttribute setOptional:NO];
    [remoteURLAttribute setIndexed:YES];
    [properties addObject:remoteURLAttribute];

    NSAttributeDescription *fileDataAttribute = [[NSAttributeDescription alloc] init];
    [fileDataAttribute setName:@"fileData"];
    [fileDataAttribute setAttributeType:NSBinaryDataAttributeType];
    [fileDataAttribute setOptional:NO];
    [fileDataAttribute setAllowsExternalBinaryDataStorage:YES];
    [properties addObject:fileDataAttribute];

    NSAttributeDescription *lastAccessDateAttribute = [[NSAttributeDescription alloc] init];
    [lastAccessDateAttribute setName:@"lastAccessDate"];
    [lastAccessDateAttribute setAttributeType:NSDateAttributeType];
    [lastAccessDateAttribute setOptional:NO];
    [properties addObject:lastAccessDateAttribute];

    NSAttributeDescription *expirationDateAttribute = [[NSAttributeDescription alloc] init];
    [expirationDateAttribute setName:@"expirationDate"];
    [expirationDateAttribute setAttributeType:NSDateAttributeType];
    [expirationDateAttribute setOptional:NO];
    [properties addObject:expirationDateAttribute];

    NSAttributeDescription *contentTypeAttribute = [[NSAttributeDescription alloc] init];
    [contentTypeAttribute setName:@"contentType"];
    [contentTypeAttribute setAttributeType:NSStringAttributeType];
    [contentTypeAttribute setOptional:YES];
    [properties addObject:contentTypeAttribute];

    NSAttributeDescription *fileSizeAttribute = [[NSAttributeDescription alloc] init];
    [fileSizeAttribute setName:@"fileSize"];
    [fileSizeAttribute setAttributeType:NSInteger32AttributeType];
    [fileSizeAttribute setOptional:NO];
    [properties addObject:fileSizeAttribute];

    NSAttributeDescription *entityTagIdentifierAttribute = [[NSAttributeDescription alloc] init];
    [entityTagIdentifierAttribute setName:@"entityTagIdentifier"];
    [entityTagIdentifierAttribute setAttributeType:NSStringAttributeType];
    [entityTagIdentifierAttribute setOptional:YES];
    [properties addObject:entityTagIdentifierAttribute];

    // add attributes to entity
    [entity setProperties:properties];
    
    // add entity to model
    [model setEntities:[NSArray arrayWithObject:entity]];
    
    return model;
}
 
 - (void)_setupCoreDataStack
 {
	// setup managed object model

	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DTDownloadCache" withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];


// in code
_managedObjectModel = [self _model];

// setup persistent store coordinator
NSURL *storeURL = [NSURL fileURLWithPath:[[NSString cachesPath] stringByAppendingPathComponent:@"DTDownload.cache"]];

NSError *error = nil;
_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];

if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
{
    // inconsistent model/store
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];

    // retry once
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

// create MOC
_managedObjectContext = [[NSManagedObjectContext alloc] init];
[_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
}
 */


@end
