//
//  Notification.h
//  Social Network
//
//  Created by Sitanshu Joshi on 3/26/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DataForResponse;

@interface Notification : NSManagedObject

@property (nonatomic, retain) NSString * ids;
@property (nonatomic, retain) NSString * activityType;
@property (nonatomic, retain) NSString * objectType;
@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * senderId;
@property (nonatomic, retain) NSString * recipientId;
@property (nonatomic, retain) NSString * objectUrl;
@property (nonatomic, retain) NSString * senderName;
@property (nonatomic, retain) NSString * recepientName;

@property (nonatomic, retain) DataForResponse *data;

+(RKEntityMapping *)objectMappingForNotification:(OPPCodeType)OppCodeType;

@end
