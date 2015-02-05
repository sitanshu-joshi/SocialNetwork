//
//  City.m
//  Social Network
//
//  Created by Sagar Gondaliya on 2/5/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "City.h"
#import "DataForResponse.h"


@implementation City

@dynamic ids;
@dynamic cityName;
@dynamic state;
@dynamic country;
@dynamic desc;
@dynamic createdDate;
@dynamic updatedDate;
@dynamic data;


+(RKEntityMapping *)objectMappingForCity:(OPPCodeType)OppCodeType{
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"City" inManagedObjectStore:[[AppDelegate appDelegate] rkMOS]];
    mapping.setDefaultValueForMissingAttributes = TRUE;
    
    if (OppCodeType == CITY) {
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"id" : @"ids",
                                                      @"updatedDate" : @"updatedDate",
                                                      @"createdDate" : @"createdDate",
                                                      @"cityName" : @"cityName",
                                                      @"state" : @"state",
                                                      @"country" : @"country",
                                                      @"description" : @"desc",
                                                      }];
    }
    return mapping;
}
@end
