//
//  Post.h
//  Social Network
//
//  Created by Sagar Gondaliya on 2/5/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DataForResponse;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * ids;
@property (nonatomic, retain) NSNumber * isMyLike;
@property (nonatomic, retain) NSNumber * likeCount;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * cityId;
@property (nonatomic, retain) NSString * mediaUrl;
@property (nonatomic, retain) NSNumber * mediaType;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) DataForResponse *data;


+(RKEntityMapping *)objectMappingForPost:(OPPCodeType)OppCodeType;

@end
