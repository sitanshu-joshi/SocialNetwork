//
//  MenuOptionsViewController.m
//  SportzCal
//
//  Created by Sitanshu Joshi on 1/28/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.

#import "MenuOptionsViewController.h"
#import "CustomSlideViewController.h"
@interface MenuOptionsViewController ()

@end


@implementation MenuOptionsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblName.layer.cornerRadius = 5.0;
    self.imgViewForProfile.layer.cornerRadius = (self.imgViewForProfile.frame.size.width/2);
    self.viewForCityButton.layer.cornerRadius = (self.viewForCityButton.frame.size.width/2);
    self.viewForLogoutButton.layer.cornerRadius = (self.viewForLogoutButton.frame.size.width/2);
    self.viewForNewsButton.layer.cornerRadius = (self.viewForNewsButton.frame.size.width/2);
    self.viewForProfileButton.layer.cornerRadius = (self.viewForProfileButton.frame.size.width/2);
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setUpUserInterface];
  
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    if ([segue isKindOfClass: [CustomSlideViewControllerSegue class]] ) {
        CustomSlideViewControllerSegue *swSegue = (CustomSlideViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(CustomSlideViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}

-(void)setUpUserInterface{
    self.lblName.text = [AppUserInfo sharedAppUserInfo].userName;
    NSURL *url;
    if([AppUserInfo sharedAppUserInfo].userId){
        
        url = [NSURL URLWithString:[NSString stringWithFormat:kFBProfilePicURL,[AppUserInfo sharedAppUserInfo].userId]];
        [self.imgViewForProfile sd_setImageWithURL:url
                                  placeholderImage:[UIImage imageNamed:@"profile_pic"]
                                           options:SDWebImageRefreshCached];
    }else{
        self.imgViewForProfile.image = [UIImage imageNamed:@"profile_pic"];
    }
    self.imgViewForProfile.layer.cornerRadius = (self.imgViewForProfile.frame.size.width/2);
    self.imgViewForProfile.layer.masksToBounds = YES;
}
@end
