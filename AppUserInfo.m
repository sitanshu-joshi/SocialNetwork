//
//  AppUserInfo.m
//  Social Network
//
//  Created by Sagar Gondaliya on 26/01/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "AppUserInfo.h"

@implementation AppUserInfo

@synthesize userName;
@synthesize firstName;
@synthesize lastName;
@synthesize birthday;
@synthesize userId;
@synthesize userEmail;

+(AppUserInfo *)sharedAppUserInfo{
    
    static AppUserInfo *appUserInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appUserInfo = [[self alloc] init];
    });
    return appUserInfo;
}

-(void)setUserName:(NSString *)username{
    
    userName = username;
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUSER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setFirstName:(NSString *)firstname{
    
    firstName = firstname;
    [[NSUserDefaults standardUserDefaults] setObject:firstName forKey:kUSER_FIRST_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)setLastName:(NSString *)lastname{
    
    lastName = lastname;
    [[NSUserDefaults standardUserDefaults] setObject:lastName forKey:kUSER_LAST_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setBirthday:(NSString *)birthdate{
    
    birthday = birthdate;
    [[NSUserDefaults standardUserDefaults] setObject:birthday forKey:kUSER_BDAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)setUserId:(NSString *)userid{
    userId = userid;
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kUSER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setUserEmail:(NSString *)email{
    
    userEmail = email;
    [[NSUserDefaults standardUserDefaults] setObject:userEmail forKey:kUSER_EMAIL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)userName{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_NAME];

}

-(NSString *)firstName{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_FIRST_NAME];
    
}

-(NSString *)lastName{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_LAST_NAME];

}

-(NSString *)birthday{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_BDAY];
    
}

-(NSString *)userId{
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:kUSER_ID];
}

-(NSString *)userEmail{
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:kUSER_EMAIL];
    
}

-(void)clearUserDefaults{
    
    [self setUserName:@""];
    [self setFirstName:@""];
    [self setLastName:@""];
    [self setBirthday:@""];
    [self setUserId:@""];
    [self setUserEmail:@""];
}

@end
