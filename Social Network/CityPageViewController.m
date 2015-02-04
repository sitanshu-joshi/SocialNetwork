//
//  CityPageViewController.m
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import "CityPageViewController.h"

@interface CityPageViewController ()

@end

@implementation CityPageViewController
@synthesize btnVideoSharing,btnPhotoSharing,btnShare,btnMainMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    [btnMainMenu addTarget:self action: @selector(mainMenuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.revealViewController.delegate = self;
    [self getPostDetails];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpUserInterface];
}
-(void)mainMenuBtnClicked {
    [self.revealViewController revealToggle:btnMainMenu];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUserInterface{
    btnShare.layer.cornerRadius = 7.0;
}
#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.txtViewForPost resignFirstResponder];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}
#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:kPush_To_Comment sender:self];
    [self.txtViewForPost resignFirstResponder];
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - To get Post Data
-(void)getPostDetails{
    NSString *strPath = [NSString stringWithFormat:@"%@ %d",kGetPost,1];
    
    [[AppDelegate appDelegate].rkomForPost postObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *data  = [mappingResult.array objectAtIndex:0];
        User *user  = [[data.user allObjects] firstObject];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

- (IBAction)cityBtnTapped:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.containerViewForCityInput.frame = CGRectMake(5, 72, self.containerViewForCityInput.frame.size.width, self.containerViewForCityInput.frame.size.height);
    }];
}

- (IBAction)doneBtnTapped:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.containerViewForCityInput.frame = CGRectMake(5, 1000, self.containerViewForCityInput.frame.size.width, self.containerViewForCityInput.frame.size.height);
    }];
    [self performSegueWithIdentifier:@"pushToNewsFromCity" sender:self];
}

@end
