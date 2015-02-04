//
//  AppUserInfo.h
//  Social Network
//
//  Created by Sagar Gondaliya on 26/01/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUserInfo : NSObject

+(AppUserInfo *)sharedAppUserInfo;

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *birthday;
@property (nonatomic) NSString *userId;

-(void)clearUserDefaults;

@end
