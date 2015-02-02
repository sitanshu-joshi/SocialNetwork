//
//  Post.m
//  Social Network
//
//  Created by Sagar Gondaliya on 1/28/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "Post.h"
#import "DataForResponse.h"


@implementation Post

@dynamic commentCount;
@dynamic createdDate;
@dynamic ids;
@dynamic isMyLike;
@dynamic likeCount;
@dynamic text;
@dynamic updatedDate;
@dynamic data;



+(RKEntityMapping *)objectMappingForPost:(OPPCodeType)OppCodeType {
    
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:@"Post" inManagedObjectStore:[[AppDelegate appDelegate] rkMOS]];
    
    mapping.setDefaultValueForMissingAttributes = TRUE;
    if (OppCodeType == LOGIN) {
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"id" : @"ids",
                                                      @"likeCount" : @"likeCount",
                                                      @"commentCount" : @"commentCount",
                                                      @"createTime" : @"createTime",
                                                      @"text" : @"text",
                                                      @"isMyLike" : @"isMyLike",
                                                      @"updatedDate" : @"updatedDate",
                                                      @"createdDate" : @"createdDate",
                                                      }];
    }
    return mapping;
}


@end