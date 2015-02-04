//
//  SettingViewController.m
//  Social Network
//
//  Created by Rushi on 05/02/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize btnMainMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [btnMainMenu addTarget:self action: @selector(mainMenuBtnClickAtProfile) forControlEvents:UIControlEventTouchUpInside];
    self.revealViewController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mainMenuBtnClickAtProfile {
    [self.revealViewController revealToggle:self.btnMainMenu];
}

- (IBAction)logoutBtnTapped:(id)sender {
    [[FBSession activeSession]closeAndClearTokenInformation];
    [[FBSession activeSession]close];
    [[AppUserInfo sharedAppUserInfo]clearUserDefaults];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
