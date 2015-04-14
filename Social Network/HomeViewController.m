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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideActivityIndicator) name:kNotifier_Facebook_Session_Closed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeLoginUsingAuthCredential:) name:kNotifier_Facebook_Session_Opened object:nil];
    BOOL isLogin = [AppLogin sharedAppLogin].isUserLoggedIn;
    if(isLogin){
         [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
        [self loginWithExistingCredential];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

#pragma mark - Helper Methods
-(void)hideActivityIndicator{
    [RSActivityIndicator hideIndicator];
}


@end
