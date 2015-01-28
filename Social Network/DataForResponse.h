//
//  DataForResponse.h
//  Social Network
//
//  Created by Sagar Gondaliya on 1/28/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Post, User;

@interface DataForResponse : NSManagedObject

@property (nonatomic, retain) NSSet *post;
@property (nonatomic, retain) NSSet *user;
@property (nonatomic, retain) NSSet *comment;

@end

@interface DataForResponse (CoreDataGeneratedAccessors)

- (void)addPostObject:(Post *)value;
- (void)removePostObject:(Post *)value;
- (void)addPost:(NSSet *)values;
- (void)removePost:(NSSet *)values;

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

- (void)addCommentObject:(Comment *)value;
- (void)removeCommentObject:(Comment *)value;
- (void)addComment:(NSSet *)values;
- (void)removeComment:(NSSet *)values;


+(RKEntityMapping *)objectMappingForDataResponse:(OPPCodeType)OppCodeType;
@end
