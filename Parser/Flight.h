//
//  Flight.h
//  FlightStatsNepal
//
//  Created by ARZEN SHRESTHA on 24/6/15.
//  Copyright (c) 2015 EK Solutions Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface Flight : NSObject

@property (nonatomic, retain) NSString * airline_logo;
@property (nonatomic, retain) NSString * airline_name;
@property (nonatomic, retain) NSString * arrival_airport_city_code;
@property (nonatomic, retain) NSString * arrival_airport_country_code;
@property (nonatomic, retain) NSString * arrival_airport_country_name;
@property (nonatomic, retain) NSString * arrival_airport_icao;
@property (nonatomic, retain) NSString * arrival_airport_lat;
@property (nonatomic, retain) NSString * arrival_airport_lon;
@property (nonatomic, retain) NSString * arrival_airport_name;
@property (nonatomic, retain) NSString * arrival_airport_time_zone_region_name;
@property (nonatomic, retain) NSString * arrival_city;
@property (nonatomic, retain) NSString * arrival_date_display;
@property (nonatomic, retain) NSString * arrival_date_local;
@property (nonatomic, retain) NSString * arrival_date_nst;
@property (nonatomic, retain) NSString * arrivalDeparture;
@property (nonatomic, retain) NSString * arrivalGate;
@property (nonatomic, retain) NSString * arrivalGateDelayMinutes;
@property (nonatomic, retain) NSString * arrivalTerminal;
@property (nonatomic, retain) NSString * carrier_fs_code;
@property (nonatomic, retain) NSDate * current_datetime;
@property (nonatomic, retain) NSString * delay_arrival;
@property (nonatomic, retain) NSString * delay_departure;
@property (nonatomic, retain) NSString * departure_airport_city_code;
@property (nonatomic, retain) NSString * departure_airport_country_code;
@property (nonatomic, retain) NSString * departure_airport_country_name;
@property (nonatomic, retain) NSString * departure_airport_icao;
@property (nonatomic, retain) NSString * departure_airport_lat;
@property (nonatomic, retain) NSString * departure_airport_lon;
@property (nonatomic, retain) NSString * departure_airport_name;
@property (nonatomic, retain) NSString * departure_airport_time_zone_region_name;
@property (nonatomic, retain) NSString * departure_city;
@property (nonatomic, retain) NSString * departure_date_display;
@property (nonatomic, retain) NSString * departure_date_local;
@property (nonatomic, retain) NSString * departure_date_nst;
@property (nonatomic, retain) NSString * departureGate;
@property (nonatomic, retain) NSString * departureGateDelayMinutes;
@property (nonatomic, retain) NSString * departureTerminal;
@property (nonatomic, retain) NSNumber * flight_id;
@property (nonatomic, retain) NSString * flight_number;
@property (nonatomic, retain) NSString * flight_status;
@property (nonatomic, retain) NSString * opt_actualGateArrival_local;
@property (nonatomic, retain) NSString * opt_actualGateDeparture_local;
@property (nonatomic, retain) NSString * opt_actualRunwayArrival_local;
@property (nonatomic, retain) NSString * opt_actualRunwayDeparture_local;
@property (nonatomic, retain) NSString * opt_estimatedGateArrival_local;
@property (nonatomic, retain) NSString * opt_estimatedGateDeparture_local;
@property (nonatomic, retain) NSString * opt_estimatedRunwayArrival_local;
@property (nonatomic, retain) NSString * opt_estimatedRunwayDeparture_local;
@property (nonatomic, retain) NSString * opt_scheduledGateArrival_local;
@property (nonatomic, retain) NSString * opt_scheduledGateDeparture_local;
@property (nonatomic, retain) NSNumber * scheduledBlockMinutes;
@property (nonatomic, retain) NSDate * sort_DateTime;
@property (nonatomic, retain) NSOrderedSet *positions;
@end

