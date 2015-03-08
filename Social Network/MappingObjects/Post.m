//
//  Post.m
//  Social Network
//
//  Created by Sagar Gondaliya on 2/5/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "Post.h"
#import "DataForResponse.h"


@implementation Post

@dynamic commentCount;
@dynamic createdDate;
@dynamic ids;
@dynamic isMyLike;
@dynamic isMyPost;
@dynamic likeCount;
@dynamic text;
@dynamic updatedDate;
@dynamic userId;
@dynamic cityId;
@dynamic mediaUrl;
@dynamic mediaType;
@dynamic cityName;
@dynamic state;
@dynamic country;
@dynamic username;
@dynamic desc;
@dynamic data;

+(RKEntityMapping *)objectMappingForPost:(OPPCodeType)OppCodeType {
    
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:@"Post" inManagedObjectStore:[[AppDelegate appDelegate] rkMOS]];
    
    mapping.setDefaultValueForMissingAttributes = TRUE;
    if (OppCodeType == POST) {
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"id" : @"ids",
                                                      @"likeCount" : @"likeCount",
                                                      @"commentCount" : @"commentCount",
                                                      @"text" : @"text",
                                                      @"isMyLiked" : @"isMyLike",
                                                      @"updatedDate" : @"updatedDate",
                                                      @"createdDate" : @"createdDate",
                                                      @"userId" : @"userId",
                                                      @"cityId" : @"cityId",
                                                      @"mediaUrl" : @"mediaUrl",
                                                      @"mediaType" : @"mediaType",
                                                      @"cityName" : @"cityName",
                                                      @"state" : @"state",
                                                      @"country" : @"country",
                                                      @"description" : @"desc",
                                                      @"username" : @"username",
                                                      @"isMyPost" : @"isMyPost",
                                                      }];
    }
    return mapping;
}

@end
