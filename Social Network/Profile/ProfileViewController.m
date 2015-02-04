//
//  ProfileViewController.m
//  Social Network
//
//  Created by Rushi on 04/02/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
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

@end
