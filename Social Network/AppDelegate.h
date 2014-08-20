//
//  AppDelegate.h
//  Social Network
//
//  Created by Sitanshu Joshi on 7/26/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "HomeViewController.h"
#import "FlightViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL isFBSessionOpen;
    NSUserDefaults *userDefaults;
    FlightViewController *objFlightVC;
}

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate *)appDelegate;

- (void)sessionStateChanged :(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;


@end
