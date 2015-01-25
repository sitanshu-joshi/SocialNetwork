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
@synthesize activityIndicator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - UIViewController Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)),self.view.center.y);
    loginView.readPermissions = @[@"public_profile", @"email", @"user_friends",@"user_birthday"];
    loginView.delegate = self;
    [self.view addSubview:loginView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFBData:) name:kNotification_FB object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
//Facebook Login Method
- (IBAction)btnLoginTapped:(id)sender {
    [activityIndicator startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFBData:) name:kNotification_FB object:nil];
    [[AppDelegate appDelegate] openSessionWithAllowLoginUI:YES];
}

#pragma mark - FBLoginView Delegate Methods
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user{
    if([FBSession activeSession]){
        
        [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:kUSER_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:user.first_name forKey:kUSER_FIRST_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:user.last_name forKey:kUSER_LAST_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:user.birthday forKey:kUSER_BDAY];
        
        [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"email"] forKey:kLogin_User_Email];
        NSString *strToken  = [NSString stringWithFormat:@"%@",[FBSession activeSession].accessTokenData.accessToken];
        NSString *strPassword = [strToken substringFromIndex:[strToken length] - 8];
        [[NSUserDefaults standardUserDefaults]setObject:strPassword forKey:kLogin_User_Password];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:user.username forKey:kUSER_NAME];
        [dict setValue:user.first_name forKey:kUSER_FIRST_NAME];
        [dict setValue:user.last_name forKey:kUSER_LAST_NAME];
        [dict setValue:[user objectForKey:@"email"] forKey:kUSER_EMAIL];
        [dict setValue:[FBSession activeSession].accessTokenData.accessToken forKey:kUSER_AUTH_TOKEN];
        [dict setValue:kAuth_FB forKey:kUSER_TYPE];
        [dict setValue:[[NSTimeZone localTimeZone] name] forKey:kUSER_TIMEZONE];
        [dict setValue:user.birthday forKey:kUSER_BDAY];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_FB object:dict];
    }
    NSLog(@"user : %@",user);
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error{
    NSLog(@"%@",error.description);
}

#pragma mark - Push To Flight View Controller Method
-(void)pushToFlightViewController{
    self.view.userInteractionEnabled = YES;
    // Statis
    [self performSegueWithIdentifier:kPush_To_Interest sender:nil];
    //Dynamic
//    [self makeLoginUsingAuthCredential];
}

#pragma mark Request Method
-(void)getFBData:(NSNotification *)notificationObjForCustomers {
    // Remove Notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_FB object:nil];
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[notificationObjForCustomers object];
    if(dictionary){
        [self makeLoginUsingAuthCredential:dictionary];
    }
}

-(void)makeLoginUsingAuthCredential:(NSMutableDictionary *)dict {
    
    [[AppDelegate appDelegate].rkomForLogin postObject:nil path:kResource_SignUp_Auth parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        // Handled with articleDescriptor
        [activityIndicator stopAnimating];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *data  = [mappingResult.array objectAtIndex:0];
        User *user  = [[data.user allObjects] firstObject];
        //        User *user = [data valueForKey:@"user"];
        NSLog(@"%@",[user email]);
        NSLog(@"%ld",(long)operation.HTTPRequestOperation.response.statusCode);
        [self performSelector:@selector(pushToFlightViewController) withObject:nil afterDelay:0.0];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [activityIndicator stopAnimating];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
}


@end
