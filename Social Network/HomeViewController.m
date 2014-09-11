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
    [[AppDelegate appDelegate]openSessionWithAllowLoginUI:YES];
    [activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
}
#pragma mark - Push To Flight View Controller Method
-(void)pushToFlightViewController{
    [activityIndicator stopAnimating];
    self.view.userInteractionEnabled = YES;
    [self performSegueWithIdentifier:kPush_To_FlightVC_segue sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
