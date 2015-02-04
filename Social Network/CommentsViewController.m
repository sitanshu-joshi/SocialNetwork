//
//  CommentsViewController.m
//  Social Network
//
//  Created by Sitanshu Joshi on 2/4/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUserInterface];
    [self getCommentsDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUserInterface{
    self.containerView.layer.borderColor = (__bridge CGColorRef)([UIColor colorWithRed:55.0/255.0 green:81.0/255.0 blue:255.0/255.0 alpha:1.0]);
    self.containerView.layer.borderWidth = 2.0;
    
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"commentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnPostTapped:(id)sender {
}

#pragma mark - To get Post Data
-(void)getCommentsDetails{
    NSString *strPath = [NSString stringWithFormat:@"%@ %d",kGetCommentsByPostId,1];
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
