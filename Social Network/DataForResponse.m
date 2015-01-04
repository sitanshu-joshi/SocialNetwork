//
//  DataForResponse.m
//  Social Network
//
//  Created by Sitanshu Joshi on 1/4/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "DataForResponse.h"
#import "User.h"


@implementation DataForResponse

@dynamic user;

+(RKEntityMapping *)objectMappingForDataResponse:(OPPCodeType)OppCodeType {
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([DataForResponse class]) inManagedObjectStore:[[AppDelegate appDelegate] rkMOS]];
    mapping.setDefaultValueForMissingAttributes = TRUE;
    
    if (OppCodeType == LOGIN) {
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[User objectMappingForLogin:LOGIN]]];
    }
    
    return mapping ;
}

@end
