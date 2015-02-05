//
//  ProfileViewController.m
//  Social Network
//
//  Created by Rushi on 04/02/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize btnMainMenu;
@synthesize lblName,lblBirthday,lblCity,lblEmail,imgViewForProPic;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [btnMainMenu addTarget:self action: @selector(mainMenuBtnClickAtProfile) forControlEvents:UIControlEventTouchUpInside];
    self.revealViewController.delegate = self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([[AppDelegate appDelegate]isNetworkReachableToInternet]){
            if([FBSession activeSession].isOpen){
                [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
                    [self getProfileInfo];
                }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_NoInternet delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mainMenuBtnClickAtProfile {
    [self.revealViewController revealToggle:self.btnMainMenu];
}

-(void)getProfileInfo{
    self.lblName.text = [AppUserInfo sharedAppUserInfo].userName;
    self.lblEmail.text = [AppUserInfo sharedAppUserInfo].userEmail;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kFBProfilePicURL,[AppUserInfo sharedAppUserInfo].userId]];
    [imgViewForProPic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile_pic"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                             }];
    imgViewForProPic.layer.cornerRadius = (imgViewForProPic.frame.size.width/2);
    imgViewForProPic.layer.masksToBounds = YES;
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
        [RSActivityIndicator hideIndicator];
        if (!error) {
            NSLog(@"Facebook User Information:%@",user);
            NSString *strLocation,*strGender,*strBirthDate;
            
            if([[user valueForKey:kUserLocation]valueForKey:kLocationName]){
                strLocation = [NSString stringWithFormat:@"%@",[[user valueForKey:kUserLocation]valueForKey:kLocationName]];
            }else{
                strLocation = @"--";
            }
            
            if([user valueForKey:kUserGender]){
                strGender = [NSString stringWithFormat:@"%@",[[user valueForKey:kUserGender]capitalizedString]];
            }else{
                strGender = @"--";
            }
            
            if([user valueForKey:kUserBirthDate]){
                strBirthDate = [NSString stringWithFormat:@"%@",[user valueForKey:kUserBirthDate]];
            }else{
                strBirthDate = @"--";
            }
            lblBirthday.text = strBirthDate;
            lblCity.text = strLocation;
        }else if ([error code] == -(kCode_NSURLErrorNotConnectedToInternet)){
            [self networkNotReachable];
            return;
        }
    }];
}

-(void)networkNotReachable{
    [RSActivityIndicator hideIndicator];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_NoInternet delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
    [alert show];
}

@end
