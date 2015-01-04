//
//  User.m
//  Social Network
//
//  Created by Sitanshu Joshi on 1/4/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic strTz;
@dynamic birthDate;
@dynamic createTime;
@dynamic email;
@dynamic forgotPassword;
@dynamic gender;
@dynamic ids;
@dynamic lastLockoutDate;
@dynamic lastPasswordChangeDate;
@dynamic locationRadius;
@dynamic loginName;
@dynamic orgDomainName;
@dynamic pushStatus;
@dynamic roles;
@dynamic status;
@dynamic type;
@dynamic updateTime;
@dynamic useGeoLocation;
@dynamic data;


+(RKEntityMapping *)objectMappingForLogin:(OPPCodeType)OppCodeType {
    
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:[[AppDelegate appDelegate] rkMOS]];
    
    mapping.setDefaultValueForMissingAttributes = TRUE;
    if (OppCodeType == LOGIN) {
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"id" : @"ids",
                                                      @"strTz" : @"strTz",
                                                      @"birthDate" : @"birthDate",
                                                      @"createTime" : @"createTime",
                                                      @"email" : @"email",
                                                      @"forgotPassword" : @"forgotPassword",
                                                      @"gender" : @"gender",
                                                      @"lastLockoutDate" : @"lastLockoutDate",
                                                      @"lastPasswordChangeDate" : @"lastPasswordChangeDate",
                                                      @"locationRadius" : @"locationRadius",
                                                      @"loginName" : @"loginName",
                                                      @"orgDomainName" : @"orgDomainName",
                                                      @"pushStatus" : @"pushStatus",
                                                      @"roles" : @"roles",
                                                      @"status" : @"status",
                                                      @"type" : @"type",
                                                      @"updateTime" : @"updateTime",
                                                      @"useGeoLocation" : @"useGeoLocation",
                                                      }];
        
//        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"card" toKeyPath:@"userInfoCards" withMapping:[UserInfoCards objectMappingForInfoCard:INFO_CARDS]]];
    }
    return mapping;
}
@end
