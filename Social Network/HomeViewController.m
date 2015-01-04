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
    [[AppDelegate appDelegate] openSessionWithAllowLoginUI:YES];
    [activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
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

-(void)makeLoginUsingAuthCredential {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kUSER_NAME] forKey:kUSER_NAME];
    [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kUSER_FIRST_NAME] forKey:kUSER_FIRST_NAME];
    [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kUSER_LAST_NAME] forKey:kUSER_LAST_NAME];
    [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kUSER_EMAIL] forKey:kUSER_EMAIL];
    [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:kUSER_AUTH_TOKEN] forKey:kUSER_AUTH_TOKEN];
    [dict setValue:[[NSTimeZone localTimeZone] name] forKey:kUSER_TIMEZONE];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[DataForResponse objectMappingForDataResponse:LOGIN] method:RKRequestMethodPOST pathPattern:nil keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[AppDelegate appDelegate].rkomForLogin addResponseDescriptor:responseDescriptor];
    
    
    [[AppDelegate appDelegate].rkomForLogin postObject:nil path:@"login" parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        // Handled with articleDescriptor
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *data  = [mappingResult.array objectAtIndex:0];
        User *user  = [[data.user allObjects] firstObject];
        //        User *user = [data valueForKey:@"user"];
        NSLog(@"%@",[user email]);
        NSLog(@"%ld",operation.HTTPRequestOperation.response.statusCode);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
}


@end
