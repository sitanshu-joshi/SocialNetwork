//
//  Comment.m
//  Social Network
//
//  Created by Sagar Gondaliya on 1/28/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "Comment.h"
#import "DataForResponse.h"


@implementation Comment

@dynamic ids;
@dynamic userId;
@dynamic postId;
@dynamic text;
@dynamic createdDate;
@dynamic updatedDate;
@dynamic data;


+(RKEntityMapping *)objectMappingForComment:(OPPCodeType)OppCodeType {
    
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:@"Comment" inManagedObjectStore:[[AppDelegate appDelegate] rkMOS]];
    
    mapping.setDefaultValueForMissingAttributes = TRUE;
    if (OppCodeType == COMMENT) {
        [mapping addAttributeMappingsFromDictionary:@{
                                                      @"id" : @"ids",
                                                      @"userId" : @"userId",
                                                      @"postId" : @"postId",
                                                      @"text" : @"text",
                                                      @"updatedDate" : @"updatedDate",
                                                      @"createdDate" : @"createdDate",
                                                      }];
    }
    return mapping;
}

@end
