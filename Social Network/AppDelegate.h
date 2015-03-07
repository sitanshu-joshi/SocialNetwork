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
#import "User.h"
#import "Reachability/Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL isFBSessionOpen;
    NSUserDefaults *userDefaults;
    UINavigationController *navController;
}

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate *)appDelegate;

#pragma CoreData
/**
 *   Core Data Objects Declaration
 *   Properties for Core Data
 */
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
#pragma RestKit
/**
 *  RestKit Initialization for Core Mapping Context Object Declaration
 */
@property (nonatomic, strong) NSManagedObjectContext *nsManegedObjectContext;
@property (nonatomic, strong) RKManagedObjectStore *rkMOS;
@property (nonatomic, strong) RKObjectManager *rkObjectManager;
/**
 *  RKObjectManager - Mapping Object Declaration
 */
@property (nonatomic, strong) RKObjectManager *rkomForLogin;
@property (nonatomic, strong) RKObjectManager *rkomForPost;
@property (nonatomic, strong) RKObjectManager *rkomForComment;
@property (nonatomic, strong) RKObjectManager *rkomForPlaces;
@property (nonatomic, strong) RKObjectManager *rkomForCity;
@property (nonatomic, strong) RKObjectManager *rkomForGeneralObject;




// Local instance
@property (nonatomic, strong) User *loggedUser;

/**
 * Facebook Delegate Methods
 */
- (void)sessionStateChanged :(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

//To check Network Rechability
-(BOOL)isNetworkReachableToInternet;
-(void)backToRootView;

@end
