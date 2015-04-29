//
//  AppDelegate.m
//  Social Network
//
//  Created by Sitanshu Joshi on 7/26/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

static AppDelegate *appDelegate;

@implementation AppDelegate
@synthesize nsManegedObjectContext,managedObjectModel,persistentStoreCoordinator;
@synthesize rkMOS,rkObjectManager,rkomForLogin,rkomForComment,rkomForPost,rkomForPlaces,rkomForCity,rkomForNotification,rkomForGeneralObject;
@synthesize loggedUser;

+(AppDelegate *)appDelegate{
    if(!appDelegate){
        appDelegate = [[UIApplication sharedApplication]delegate];
        return appDelegate;
    }
    return appDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    isFBSessionOpen = false;
    //navController = (UINavigationController *)self.window.rootViewController;
    self.window.backgroundColor = [UIColor clearColor];
    self.window.opaque = NO;
    [self setupRestKitForInitializeUserMapping];
    [self setupDocumentDirectory];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        [FBAppEvents activateApp];
        [FBAppCall handleDidBecomeActive];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
        [[FBSession activeSession]accessTokenData];
        [FBSession.activeSession close];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error){
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [self sessionStateChanged:session state:state error:error];
     }];
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}


#pragma mark - Facebook Session Handler Methods

//This will call to Start Facebook Session by Passing Permission
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI{
    //[FBSession.activeSession closeAndClearTokenInformation];
    return [FBSession openActiveSessionWithReadPermissions:
            @[@"email",@"user_friends"] allowLoginUI:YES completionHandler:
            ^(FBSession *session, FBSessionState state, NSError *error) {
                // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                [self sessionStateChanged:session state:state error:error];
            }];
    return NO;
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error{
    @autoreleasepool {
        // If the session was opened successfully
        if (!error && state == FBSessionStateOpen){
            NSLog(@"Session opened");
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                if (!error) {
                    //set AppUserInfo
                    AppUserInfo *appUserInfo = [AppUserInfo sharedAppUserInfo];
                    appUserInfo.userName = user.name;
                    appUserInfo.firstName = user.first_name;
                    appUserInfo.lastName = user.last_name;
                    appUserInfo.userEmail = [user objectForKey:@"email"];
                    appUserInfo.userId = user.objectID;
                    appUserInfo.birthday = user.birthday;
                    
                    //set AppLogin Details
                    AppLogin *appLoginInfo = [AppLogin sharedAppLogin];
                    NSString *strToken  = [NSString stringWithFormat:@"%@",[FBSession activeSession].accessTokenData.accessToken];
                    NSString *strPassword = [strToken substringToIndex:8];
                    appLoginInfo.userEmail = [user objectForKey:@"email"];
                    appLoginInfo.password = strPassword;
                    appLoginInfo.isUserLoggedIn = TRUE;
                    
                    NSString *fbAccessToken = [[[FBSession activeSession]accessTokenData]accessToken];
                    NSString *firstName = user.first_name;
                    NSString *lastName = user.last_name;
                    NSString *userName = user.username;
                    NSString *birthday = user.birthday;
                    NSString *email = [user objectForKey:@"email"];
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    userName ? [dict setValue:firstName forKey:kUSER_NAME] : [dict setValue:@"" forKey:kUSER_NAME];
                    firstName ? [dict setValue:firstName forKey:kUSER_FIRST_NAME] : [dict setValue:@"" forKey:kUSER_FIRST_NAME];
                    lastName ? [dict setValue:lastName forKey:kUSER_LAST_NAME] : [dict setValue:@"" forKey:kUSER_LAST_NAME];
                    email ? [dict setValue:email forKey:kUSER_EMAIL] : [dict setValue:@"" forKey:kUSER_EMAIL];
                    fbAccessToken ? [dict setValue:fbAccessToken forKey:kUSER_AUTH_TOKEN] : [dict setValue:@"" forKey:kUSER_AUTH_TOKEN];
                    [dict setValue:kAuth_FB forKey:kUSER_TYPE];
                    [dict setValue:[[NSTimeZone localTimeZone] name] forKey:kUSER_TIMEZONE];
                    birthday ? [dict setValue:birthday forKey:kUSER_BDAY] : [dict setValue:@"" forKey:kUSER_BDAY];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifier_Facebook_Session_Opened object:dict];
                }else{
                    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_FacebookConnectionProblem delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
            return;
        }
        if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
            NSLog(@"Facebook Session closed");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifier_Facebook_Session_Closed object:nil];
        }
        // Handle errors
        if (error){
            NSLog(@"Error");
            NSString *alertText;
            NSString *alertTitle;
            if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
                alertTitle = @"Something went wrong";
                alertText = [FBErrorUtility userMessageForError:error];
                UIAlertView *aALert=[[UIAlertView alloc]initWithTitle:alertTitle message:alertText delegate:nil cancelButtonTitle:kCancelButton otherButtonTitles:kOkButton, nil];
                [aALert show];
            }else{
                // If the user cancelled login, do nothing
                if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled){
                    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Facebook_Session_Closed delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
                    [alertView show];
                }
                else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                    alertText = @"Your current session is no longer valid. Please log in again.";
                    UIAlertView *aALert=[[UIAlertView alloc]initWithTitle:kAppTitle message:alertText delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
                    [aALert show];
                }
                else{
                    NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                    // Show the user an error message
                    alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                    UIAlertView *aALert=[[UIAlertView alloc]initWithTitle:kAppTitle message:alertText delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
                    [aALert show];
                }
            }
            // Clear this token
            [FBSession.activeSession closeAndClearTokenInformation];
            // Show the user the logged-out UI
            NSLog(@"USER LOGGED OUT SUCCESSFULLY!!");
        }
    }
}


// ============================== Core Data - RestKit =========================
#pragma mark Do Not Back APP local Data
/*
 It will not back up data from document directory.
 */
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark - Core Data stack
/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    @try {
        if (nsManegedObjectContext != nil)
        {
            return nsManegedObjectContext;
        }
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil)
        {
            nsManegedObjectContext = [[NSManagedObjectContext alloc] init];
            [nsManegedObjectContext setPersistentStoreCoordinator:coordinator];
        }
        return nsManegedObjectContext;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    @try {
        if (managedObjectModel != nil) {
            return managedObjectModel;
        }
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"troyage" withExtension:@"momd"];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        return managedObjectModel;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    @try {
        if (persistentStoreCoordinator != nil) {
            return persistentStoreCoordinator;
        }
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [searchPaths objectAtIndex:0];
        NSURL *storeURL = [[NSURL fileURLWithPath:documentPath] URLByAppendingPathComponent:kDB_Store];
        
        NSError *error = nil;
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSMutableDictionary *pragmaOptions = [NSMutableDictionary dictionary];
        [pragmaOptions setObject:@"OFF" forKey:@"synchronous"];
        [pragmaOptions setObject:@"MEMORY" forKey:@"journal_mode"];
        NSDictionary *storeOptions =
        [NSDictionary dictionaryWithObject:pragmaOptions forKey:NSSQLitePragmasOption];
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed object model.
             Check the error message to determine what the actual problem was.
             
             
             If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
             
             If you encounter schema incompatibility errors during development, you can reduce their frequency by:
             * Simply deleting the existing store:
             [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
             
             * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
             [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
             
             Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
             
             */
            abort();
        }
        
        return persistentStoreCoordinator;
    }
    @catch (NSException *exception) {
        NSLog(@"AppDelegate->persistentStoreCoordinator %@", exception);
    }
}

#pragma mark RestKit Initilization
-(void)setupRestKitForInitializeUserMapping {
    /*
     Setup Initial RestKit ObjectStore & Manager
     */
    rkMOS = [[RKManagedObjectStore alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:kDB_Store];
    [rkMOS addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:@{
                                                                                                          NSInferMappingModelAutomaticallyOption: @YES,
                                                                                                          NSMigratePersistentStoresAutomaticallyOption: @YES
                                                                                                          }
                                    error:nil];
    [rkMOS createManagedObjectContexts];
    
    
    rkObjectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBase_URL]];
    [rkObjectManager setManagedObjectStore:rkMOS];
    
    /*
     General Object
     */
    rkomForGeneralObject = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBase_Place_URL]];
    [rkomForGeneralObject setManagedObjectStore:rkMOS];
    
    /*
     Login Mapping
     */
    rkomForLogin = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBase_URL]];
    [rkomForLogin setManagedObjectStore:rkMOS];
    [rkomForLogin addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[[DataForResponse objectMappingForDataResponse:LOGIN] inverseMapping] objectClass:[DataForResponse class] rootKeyPath:@"data" method:RKRequestMethodPOST]];
    
    RKResponseDescriptor *responseDescriptorForLogin = [RKResponseDescriptor responseDescriptorWithMapping:[DataForResponse objectMappingForDataResponse:LOGIN] method:RKRequestMethodPOST pathPattern:nil keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [rkomForLogin addResponseDescriptor:responseDescriptorForLogin];
    
    /*
     Post Mapping
     */
    rkomForPost = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBase_URL]];
    [rkomForPost setManagedObjectStore:rkMOS];
    [rkomForPost addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[[DataForResponse objectMappingForDataResponse:POST] inverseMapping] objectClass:[DataForResponse class] rootKeyPath:@"data" method:RKRequestMethodGET]];
    
    RKResponseDescriptor *responseDescriptorForPost = [RKResponseDescriptor responseDescriptorWithMapping:[DataForResponse objectMappingForDataResponse:POST] method:RKRequestMethodGET pathPattern:nil keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [rkomForPost addResponseDescriptor:responseDescriptorForPost];
    
    /*
     Comment Mapping
     */
    rkomForComment = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBase_URL]];
    [rkomForComment setManagedObjectStore:rkMOS];
    [rkomForComment addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[[DataForResponse objectMappingForDataResponse:COMMENT] inverseMapping] objectClass:[DataForResponse class] rootKeyPath:@"data" method:RKRequestMethodGET]];
    
    RKResponseDescriptor *responseDescriptorForComment = [RKResponseDescriptor responseDescriptorWithMapping:[DataForResponse objectMappingForDataResponse:COMMENT] method:RKRequestMethodGET pathPattern:nil keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [rkomForComment addResponseDescriptor:responseDescriptorForComment];
    
    
    /*
     Places Mapping
     */
    rkomForPlaces = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBase_Place_URL]];
    [rkomForPlaces setManagedObjectStore:rkMOS];
    [rkomForPlaces addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[[DataFromGoogle objectMappingForDataFromGoogle:PLACES] inverseMapping] objectClass:[DataFromGoogle class] rootKeyPath:@"" method:RKRequestMethodGET]];
    RKResponseDescriptor *responseDescriptorForPlace = [RKResponseDescriptor responseDescriptorWithMapping:[DataFromGoogle objectMappingForDataFromGoogle:PLACES] method:RKRequestMethodGET pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [rkomForPlaces addResponseDescriptor:responseDescriptorForPlace];
    
    /*
     City Mapping
     */
    rkomForCity = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBase_URL]];
    [rkomForCity setManagedObjectStore:rkMOS];
    [rkomForCity addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[[DataForResponse objectMappingForDataResponse:CITY] inverseMapping] objectClass:[DataForResponse class] rootKeyPath:@"data" method:RKRequestMethodGET]];
    [rkomForCity addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[DataForResponse objectMappingForDataResponse:CITY] method:RKRequestMethodGET pathPattern:nil keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /*
     Notification Mapping
     */
    rkomForNotification = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBase_URL]];
    [rkomForNotification setManagedObjectStore:rkMOS];
    [rkomForNotification addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:[[DataForResponse objectMappingForDataResponse:NOTIFICATION] inverseMapping] objectClass:[DataForResponse class] rootKeyPath:@"data" method:RKRequestMethodGET]];
    [rkomForNotification addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[DataForResponse objectMappingForDataResponse:NOTIFICATION] method:RKRequestMethodGET pathPattern:nil keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
}

#pragma mark Document Directory
-(void)setupDocumentDirectory {
    if(![[FileUtility utility] checkDirectoryExistsAtPath:[[[FileUtility utility] documentDirectoryPath] stringByAppendingPathComponent:kDD_Images] isDirectory:YES]) {
        // Create Document Directory
        [[FileUtility utility] createDirectory:kDD_Images atFilePath:[[FileUtility utility] documentDirectoryPath]];
        [[FileUtility utility] createDirectory:kDD_Video atFilePath:[[FileUtility utility] documentDirectoryPath]];
    }
}


#pragma mark Network Reachability
-(BOOL)isNetworkReachableToInternet {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}


-(void)backToRootView {
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    NSArray *arrViewControllers = nav.viewControllers;
    if([[arrViewControllers objectAtIndex:0] isKindOfClass:[HomeViewController class]]){
        [nav popToViewController:[arrViewControllers objectAtIndex:0] animated:YES];
    }
}

#pragma mark - AutoLogin Methods
-(void)loginWithExistingCredential{
    NSString *strEmail = [AppLogin sharedAppLogin].userEmail;
    NSString *strPassword = [AppLogin sharedAppLogin].password;
    NSMutableDictionary *dictForLogin = [NSMutableDictionary dictionary];
    [dictForLogin setObject:strEmail forKey:kUSER_NAME];
    [dictForLogin setObject:strPassword forKey:kUSER_PASSWORD];
    
    [[AppDelegate appDelegate].rkomForLogin postObject:nil path:kResource_Login parameters:dictForLogin success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *data  = [mappingResult.array objectAtIndex:0];
        User *user  = [[data.user allObjects] firstObject];
        NSLog(@"%@",user.description);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSLog(@"%@",error.localizedDescription);
        RKLogError(@"Operation failed with error: %@", error);
    }];
}
@end
