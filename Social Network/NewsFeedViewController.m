//
//  NewsFeedViewController.m
//  Social Network
//
//  Created by Sagar Gondaliya on 25/01/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "NewsFeedViewController.h"

@interface NewsFeedViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    
    self.newsTableView.alpha = 0;
    [self.navigationController.navigationBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kNotification_LoginSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quesionAnswerSuccess) name:kNotification_QueAnsSuccess object:nil];
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_LoginSuccess object:nil];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_QueAnsSuccess object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if(![[AppLogin sharedAppLogin] isUserLoggedIn] && ![[AppLogin sharedAppLogin] isActiveSession]){
        
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
    }
    else{
        [self.navigationController.navigationBar setHidden:NO];
        self.newsTableView.alpha = 1;
    }
}

-(void)loginSuccess:(NSNotification *)notification{
    
    [RSActivityIndicator showIndicatorWithTitle:@"Please Wait..."];
    
    NSMutableDictionary *loginDict = [notification.userInfo mutableCopy];
    [self getFBData:loginDict];
}

-(void)quesionAnswerSuccess{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController.navigationBar setHidden:NO];
        self.newsTableView.alpha = 1;
    }];
}


#pragma mark Request Method
-(void)getFBData:(NSMutableDictionary *)dictionary {
    
    if(dictionary){
        [self makeLoginUsingAuthCredential:dictionary];
    }
}

-(void)makeLoginUsingAuthCredential:(NSMutableDictionary *)dict {
    
    [[AppDelegate appDelegate].rkomForLogin postObject:nil path:kResource_SignUp_Auth parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        [RSActivityIndicator hideIndicator];
        [self dismissViewControllerAnimated:NO completion:^{
            [self performSegueWithIdentifier:@"showQuestions" sender:nil];
        }];
        
        /*
         NSLog(@"%@",operation.HTTPRequestOperation.responseString);
         DataForResponse *data  = [mappingResult.array objectAtIndex:0];
         User *user  = [[data.user allObjects] firstObject];
         */
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
}


#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self performSegueWithIdentifier:kPush_To_City sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
