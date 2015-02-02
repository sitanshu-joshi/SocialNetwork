//
//  Result.m
//  Social Network
//
//  Created by Sitanshu Joshi on 2/2/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "Result.h"


@implementation Result

@dynamic ids;
@dynamic geometry;
@dynamic icon;
@dynamic name;
@dynamic place_id;
@dynamic reference;
@dynamic types;

+(RKEntityMapping *)objectMappingForPlaces:(OPPCodeType)OppCodeType {
    
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:@"Result" inManagedObjectStore:[[AppDelegate appDelegate] rkMOS]];
    
    mapping.setDefaultValueForMissingAttributes = TRUE;
    if (OppCodeType == PLACES) {
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"id" : @"ids",
                                                      @"geometry" : @"geometry",
                                                      @"icon" : @"icon",
                                                      @"name" : @"name",
                                                      @"place_id" : @"place_id",
                                                      @"reference" : @"reference",
                                                      @"types" : @"types",
                                                      }];
    }
    return mapping;
}


@end
