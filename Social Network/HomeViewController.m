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
            strLoginPath = kResource_SignUp_Auth;
        }else{
            strLoginPath = kResource_SignUp_Auth;
        }
    }else{
        [self networkNotReachable];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideActivityIndicator) name:kNotifier_Facebook_Session_Closed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeLoginUsingAuthCredential:) name:kNotifier_Facebook_Session_Opened object:nil];
    BOOL isLogin = [AppLogin sharedAppLogin].isUserLoggedIn;
    if(isLogin){
        [RSActivityIndicator showIndicator];
        [[AppDelegate appDelegate] openSessionWithAllowLoginUI:YES];
//        NSString *strEmail = [AppLogin sharedAppLogin].userEmail; //@"admin@troyage.com"; //
//        NSString *strPassword = [AppLogin sharedAppLogin].password; //@"password" ; //
//        NSMutableDictionary *dictForLogin = [NSMutableDictionary dictionary];
//        [dictForLogin setObject:strEmail forKey:kUSER_NAME];
//        [dictForLogin setObject:strPassword forKey:kUSER_PASSWORD];
//        [self sendRequestForLoginUsingAuthCredential:dictForLogin];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - PrepareForSegue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotifier_Facebook_Session_Opened object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotifier_Facebook_Session_Closed object:nil];
}


#pragma mark - IBAction Methods
- (IBAction)fbLoginBtnTapped:(id)sender {
    strLoginPath = kResource_SignUp_Auth;
    if([[AppDelegate appDelegate]isNetworkReachableToInternet]){
        [RSActivityIndicator showIndicator];
        [[AppDelegate appDelegate] openSessionWithAllowLoginUI:YES];
    }else{
        [self networkNotReachable];
    }
}

#pragma mark - RestKit API Implementation
-(void)sendRequestForLoginUsingAuthCredential:(NSDictionary *)authDictionary{
    [RSActivityIndicator showIndicator];
    [[AppDelegate appDelegate].rkomForLogin postObject:nil path:strLoginPath parameters:authDictionary success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        if(operation.HTTPRequestOperation.responseData){
            NSDictionary *dictForResponse = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:NSJSONReadingMutableContainers error:&error];
            if(dictForResponse){
                if([[dictForResponse valueForKey:@"code"] integerValue] == kINVALID_USENAME_PASSWORD){
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Invalid_User delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                    return;
                }
            }else{
                if(error.code == -(kRequest_Server_Not_Rechable)){
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                    return;
                }else if(error.code == -(kRequest_TimeOut)){
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Request_TimeOut delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                    return;
                }
            }
        }else{
            if(error.code == -kCode_Network_Connection_Lost){
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:error.localizedDescription delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil]show];
            }
        }
        
        RKLogError(@"Operation failed with error: %@", error);
    }];
}
#pragma mark - Helper Methods

-(void)makeLoginUsingAuthCredential:(NSNotification *)notification {
    NSDictionary *loginAuthDictionary = notification.object;
    [self sendRequestForLoginUsingAuthCredential:loginAuthDictionary];
}

-(void)hideActivityIndicator{
    [RSActivityIndicator hideIndicator];
}

-(void)networkNotReachable{
    [RSActivityIndicator hideIndicator];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_NoInternet delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
    [alert show];
}

@end
