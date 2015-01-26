//
//  AppLogin.h
//  Social Network
//
//  Created by Sagar Gondaliya on 26/01/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLogin : NSObject

+(AppLogin *)sharedAppLogin;

@property (nonatomic) NSString *userEmail;
@property (nonatomic) NSString *password;
@property (nonatomic) BOOL isUserLoggedIn;
@property (nonatomic) BOOL isActiveSession;

-(void)clearUserDefaults;

@end
