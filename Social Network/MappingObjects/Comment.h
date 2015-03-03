//
//  Comment.h
//  Social Network
//
//  Created by Sagar Gondaliya on 1/28/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DataForResponse;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * ids;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * postId;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSNumber * isMyComment;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) DataForResponse *data;

+(RKEntityMapping *)objectMappingForComment:(OPPCodeType)OppCodeType;

@end
