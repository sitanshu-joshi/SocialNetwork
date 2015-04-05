//
//  City.h
//  Social Network
//
//  Created by Sagar Gondaliya on 2/5/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DataForResponse;

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * ids;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSNumber * wantsToVisit;
@property (nonatomic, retain) NSNumber * isVisitedCity;

@property (nonatomic, retain) DataForResponse *data;


+(RKEntityMapping *)objectMappingForCity:(OPPCodeType)OppCodeType;

@end
