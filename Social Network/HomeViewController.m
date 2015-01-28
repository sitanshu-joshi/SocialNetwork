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
    [self setFBLoginView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)setFBLoginView{
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)),self.view.center.y);
    loginView.readPermissions = @[@"public_profile", @"email", @"user_friends",@"user_birthday"];
    loginView.delegate = self;
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - FBLoginView Delegate Methods
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user{
    if([FBSession activeSession].isOpen){
        
//        loginView.hidden = YES;
        //set AppUserInfo
    
        [[AppUserInfo sharedAppUserInfo] setUserName:user.name];
        [[AppUserInfo sharedAppUserInfo] setFirstName:user.first_name];
        [[AppUserInfo sharedAppUserInfo] setLastName:user.last_name];
        [[AppUserInfo sharedAppUserInfo] setBirthday:user.birthday];
        
        //set AppLogin Details
        
        NSString *strToken  = [NSString stringWithFormat:@"%@",[FBSession activeSession].accessTokenData.accessToken];
        NSString *strPassword = [strToken substringFromIndex:[strToken length] - 8];
        [[AppLogin sharedAppLogin] setUserEmail:[user objectForKey:@"email"]];
        [[AppLogin sharedAppLogin] setPassword:strPassword];
        [[AppLogin sharedAppLogin] setIsUserLoggedIn:TRUE];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:user.username forKey:kUSER_NAME];
        [dict setValue:user.first_name forKey:kUSER_FIRST_NAME];
        [dict setValue:user.last_name forKey:kUSER_LAST_NAME];
        [dict setValue:[user objectForKey:@"email"] forKey:kUSER_EMAIL];
        [dict setValue:[FBSession activeSession].accessTokenData.accessToken forKey:kUSER_AUTH_TOKEN];
        [dict setValue:kAuth_FB forKey:kUSER_TYPE];
        [dict setValue:[[NSTimeZone localTimeZone] name] forKey:kUSER_TIMEZONE];
        [dict setValue:user.birthday forKey:kUSER_BDAY];
        
        [self makeLoginUsingAuthCredential:dict];
    }
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error{
        NSLog(@"%@",error.description);
}

-(void)makeLoginUsingAuthCredential:(NSMutableDictionary *)dict {
    
    [[AppDelegate appDelegate].rkomForLogin postObject:nil path:kResource_SignUp_Auth parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        [RSActivityIndicator hideIndicator];
        
        [self performSegueWithIdentifier:kPush_To_SlideBar sender:nil];
    
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *data  = [mappingResult.array objectAtIndex:0];
        User *user  = [[data.user allObjects] firstObject];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

@end
