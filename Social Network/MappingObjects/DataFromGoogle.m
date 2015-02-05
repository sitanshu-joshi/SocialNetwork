//
//  DataFromGoogle.m
//  Social Network
//
//  Created by Sitanshu Joshi on 2/2/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "DataFromGoogle.h"


@implementation DataFromGoogle

@dynamic status;
@dynamic results;

+(RKEntityMapping *)objectMappingForDataFromGoogle:(OPPCodeType)OppCodeType {
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([DataFromGoogle class]) inManagedObjectStore:[[AppDelegate appDelegate] rkMOS]];
    mapping.setDefaultValueForMissingAttributes = TRUE;
    
    if (OppCodeType == PLACES) {
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"status" : @"status",
                                                      }];
        
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"results" toKeyPath:@"results" withMapping:[Result objectMappingForPlaces:PLACES]]];
    }
    return mapping;
}

@end
