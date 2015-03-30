//
//  DataForResponse.h
//  Social Network
//
//  Created by Sitanshu Joshi on 3/26/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, Comment, Notification, Post, User;

@interface DataForResponse : NSManagedObject

@property (nonatomic, retain) NSSet *city;
@property (nonatomic, retain) NSSet *comment;
@property (nonatomic, retain) NSSet *post;
@property (nonatomic, retain) NSSet *user;
@property (nonatomic, retain) NSSet *notification;
@end

@interface DataForResponse (CoreDataGeneratedAccessors)

- (void)addCityObject:(City *)value;
- (void)removeCityObject:(City *)value;
- (void)addCity:(NSSet *)values;
- (void)removeCity:(NSSet *)values;

- (void)addCommentObject:(Comment *)value;
- (void)removeCommentObject:(Comment *)value;
- (void)addComment:(NSSet *)values;
- (void)removeComment:(NSSet *)values;

- (void)addPostObject:(Post *)value;
- (void)removePostObject:(Post *)value;
- (void)addPost:(NSSet *)values;
- (void)removePost:(NSSet *)values;

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

- (void)addNotificationObject:(Notification *)value;
- (void)removeNotificationObject:(Notification *)value;
- (void)addNotification:(NSSet *)values;
- (void)removeNotification:(NSSet *)values;

+(RKEntityMapping *)objectMappingForDataResponse:(OPPCodeType)OppCodeType;

@end
