//
//  User.h
//  Social Network
//
//  Created by Sitanshu Joshi on 1/4/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * strTz;
@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * forgotPassword;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * ids;
@property (nonatomic, retain) NSDate * lastLockoutDate;
@property (nonatomic, retain) NSDate * lastPasswordChangeDate;
@property (nonatomic, retain) NSNumber * locationRadius;
@property (nonatomic, retain) NSString * loginName;
@property (nonatomic, retain) NSString * orgDomainName;
@property (nonatomic, retain) NSNumber * pushStatus;
@property (nonatomic, retain) id roles;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSNumber * useGeoLocation;
@property (nonatomic, retain) NSManagedObject *data;

/**
 *  This is mapping of response Login & will return User object.
 *
 *  @param OppCodeType Login
 *
 *  @return Return RKManagedObjectMapping object with mapping.
 */
+(RKEntityMapping *)objectMappingForLogin:(OPPCodeType)OppCodeType;


@end
