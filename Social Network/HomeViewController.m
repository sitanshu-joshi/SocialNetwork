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
    [activityIndicator startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFBData:) name:kNotification_FB object:nil];
    [[AppDelegate appDelegate] openSessionWithAllowLoginUI:YES];
}
#pragma mark - Push To Flight View Controller Method
-(void)pushToFlightViewController{
    [activityIndicator stopAnimating];
    self.view.userInteractionEnabled = YES;
    // Statis
    [self performSegueWithIdentifier:kPush_To_Interest_Segue sender:self];
    //Dynamic
//    [self makeLoginUsingAuthCredential];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
        NSLog(@"%ld",operation.HTTPRequestOperation.response.statusCode);
        [self performSelector:@selector(pushToFlightViewController) withObject:nil afterDelay:0.5];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [activityIndicator stopAnimating];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
}


@end
