//
//  AppLogin.m
//  Social Network
//
//  Created by Sagar Gondaliya on 26/01/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "AppLogin.h"

@implementation AppLogin

@synthesize isActiveSession;
@synthesize isUserLoggedIn;
@synthesize userEmail;
@synthesize password;

+(AppLogin *)sharedAppLogin{
    static AppLogin *appLogin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appLogin = [[self alloc] init];
    });
    return appLogin;
}


-(void)setIsUserLoggedIn:(BOOL)isLogin{
    
    isUserLoggedIn = isLogin;
    [[NSUserDefaults standardUserDefaults] setBool:isUserLoggedIn forKey:kIs_User_Logged_In];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setUserEmail:(NSString *)email{
    
    userEmail = email;
    [[NSUserDefaults standardUserDefaults] setObject:userEmail forKey:kLogin_User_Email];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setPassword:(NSString *)pass{
    
    password = pass;
    [[NSUserDefaults standardUserDefaults]setObject:password forKey:kLogin_User_Password];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isUserLoggedIn{
    
    return  [[NSUserDefaults standardUserDefaults]boolForKey:kIs_User_Logged_In];
}

-(BOOL)isActiveSession{
    
    return [[FBSession activeSession] isOpen];
    
}

-(NSString *)userEmail{
    
     return [[NSUserDefaults standardUserDefaults] objectForKey:kLogin_User_Email];
}

-(NSString *)password{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLogin_User_Password];
}

-(void)clearUserDefaults
{
    [self setUserEmail:@""];
    [self setPassword:@""];
    [self setIsUserLoggedIn:NO];
    [self setIsActiveSession:NO];
}


@end
