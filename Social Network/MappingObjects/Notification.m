//
//  Notification.m
//  Social Network
//
//  Created by Sitanshu Joshi on 3/26/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "Notification.h"
#import "DataForResponse.h"


@implementation Notification

@dynamic ids;
@dynamic activityType;
@dynamic objectType;
@dynamic createdTime;
@dynamic isRead;
@dynamic senderId;
@dynamic recipientId;
@dynamic objectUrl;
@dynamic recepientName;
@dynamic senderName;

@dynamic data;

+(RKEntityMapping *)objectMappingForNotification:(OPPCodeType)OppCodeType {
    
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Notification" inManagedObjectStore:[[AppDelegate appDelegate] rkMOS]];
    mapping.setDefaultValueForMissingAttributes = TRUE;
    
    if (OppCodeType == NOTIFICATION) {
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"id" : @"ids",
                                                      @"activityType" : @"activityType",
                                                      @"objectType" : @"objectType",
                                                      @"createdTime" : @"createdTime",
                                                      @"isRead" : @"isRead",
                                                      @"senderId" : @"senderId",
                                                      @"recipientId" : @"recipientId",
                                                      @"objectUrl" : @"objectUrl",
                                                      @"recepientName" : @"recepientName",
                                                      @"senderName" : @"senderName",
                                                      }];
    }
    return mapping;
}

@end
