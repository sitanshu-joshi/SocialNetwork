//
//  HomeViewController.m
//  Social Network
//
//  Created by Sagar Gondaliya on 20/08/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize btnFbLogin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - UIViewController Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([[AppDelegate appDelegate]isNetworkReachableToInternet]){
        if([AppLogin sharedAppLogin].isUserLoggedIn){
            [self loginWithExistingCredential];
        }
    }else{
        [self networkNotReachable];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//-(void)setFBLoginView {
//    FBLoginView *loginView = [[FBLoginView alloc] init];
//    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)),self.view.center.y);
//    loginView.readPermissions = @[@"public_profile", @"email", @"user_friends",@"user_birthday",@"user_location",@"user_hometown"];
//    loginView.delegate = self;
//    [self.view addSubview:loginView];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - FBLoginView Delegate Methods
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    if([[AppDelegate appDelegate]isNetworkReachableToInternet]){
        if([FBSession activeSession].isOpen){
            //set AppUserInfo
            AppUserInfo *appUserInfo = [AppUserInfo sharedAppUserInfo];
            appUserInfo.userName = user.name;
            appUserInfo.firstName = user.first_name;
            appUserInfo.lastName = user.last_name;
            appUserInfo.userEmail = [user objectForKey:@"email"];
            appUserInfo.userId = user.id;
            appUserInfo.birthday = user.birthday;
        
            //set AppLogin Details
            AppLogin *appLoginInfo = [AppLogin sharedAppLogin];
            NSString *strToken  = [NSString stringWithFormat:@"%@",[FBSession activeSession].accessTokenData.accessToken];
            NSString *strPassword = [strToken substringFromIndex:[strToken length] - 8];
            appLoginInfo.userEmail = [user objectForKey:@"email"];
            appLoginInfo.password = strPassword;
            appLoginInfo.isUserLoggedIn = TRUE;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:user.username forKey:kUSER_NAME];
            [dict setValue:user.first_name forKey:kUSER_FIRST_NAME];
            [dict setValue:user.last_name forKey:kUSER_LAST_NAME];
            [dict setValue:[user objectForKey:@"email"] forKey:kUSER_EMAIL];
            [dict setValue:[FBSession activeSession].accessTokenData.accessToken forKey:kUSER_AUTH_TOKEN];
            [dict setValue:kAuth_FB forKey:kUSER_TYPE];
            [dict setValue:[[NSTimeZone localTimeZone] name] forKey:kUSER_TIMEZONE];
            [dict setValue:user.birthday forKey:kUSER_BDAY];
            if ([[AppDelegate appDelegate] isNetworkReachableToInternet]) {
                [self makeLoginUsingAuthCredential:dict];
            } else {
                [self networkNotReachable];
            }
        }
    }else{
        [self networkNotReachable];
    }
    
}

//- (void)loginView:(FBLoginView *)loginView
//      handleError:(NSError *)error{
//        NSLog(@"%@",error.description);
//    if ([error code] == -(kCode_NSURLErrorNotConnectedToInternet)){
//        [self networkNotReachable];
//        return;
//    }
//}
//


-(void)networkNotReachable{
    [RSActivityIndicator hideIndicator];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_NoInternet delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - IBAction Methods
- (IBAction)fbLoginBtnTapped:(id)sender {
    if([[AppDelegate appDelegate]isNetworkReachableToInternet]){
        [[AppDelegate appDelegate] openSessionWithAllowLoginUI:YES];
    }else{
        [self networkNotReachable];
    }
}

#pragma mark - RestKit API Implementation
-(void)loginWithExistingCredential{
    
}

-(void)makeLoginUsingAuthCredential:(NSMutableDictionary *)dict {
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    [[AppDelegate appDelegate].rkomForLogin postObject:nil path:kResource_SignUp_Auth parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
        {
            // app already launched
            [self performSegueWithIdentifier:kPush_To_SlideBar sender:nil];
        }else {
            // This is the first launch ever
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:kPush_To_Question sender:nil];
        }
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *data  = [mappingResult.array objectAtIndex:0];
        User *user  = [[data.user allObjects] firstObject];
        NSLog(@"%@",user.description);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        //NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSLog(@"%@",error.localizedDescription);
        [RSActivityIndicator hideIndicator];
        NSString *errorMessage = [NSString stringWithFormat:@"%@",error.localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:errorMessage delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
        [alert show];
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

@end
