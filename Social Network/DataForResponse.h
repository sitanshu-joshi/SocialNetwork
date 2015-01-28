//
//  DataForResponse.h
//  Social Network
//
//  Created by Sitanshu Joshi on 1/28/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface DataForResponse : NSManagedObject

@property (nonatomic, retain) NSSet *user;
@property (nonatomic, retain) NSManagedObject *post;
@end

@interface DataForResponse (CoreDataGeneratedAccessors)

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

+(RKEntityMapping *)objectMappingForDataResponse:(OPPCodeType)OppCodeType ;

@end
