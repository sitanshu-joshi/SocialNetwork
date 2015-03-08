//
//  UtilityMethods.h
//  Social Network
//
//  Created by Sitanshu Joshi on 3/8/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UtilityMethods : NSObject

//Static Object of Single-Ton
+ (UtilityMethods *)utilityMethods;

-(BOOL)isUrlForImage:(NSString *)strUtl;

@end
