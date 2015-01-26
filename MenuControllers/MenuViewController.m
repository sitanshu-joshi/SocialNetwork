//
//  MenuViewController.m
//  Social Network
//
//  Created by Sagar Gondaliya on 26/01/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"profile";
            break;
            
        case 1:
            CellIdentifier = @"news";
            break;
            
        case 2:
            CellIdentifier = @"city";
            break;
        case 3:
            CellIdentifier = @"logout";
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 140;
    }
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 3){
        [[FBSession activeSession] closeAndClearTokenInformation];
        [[FBSession activeSession] close];
        [[AppLogin sharedAppLogin] clearUserDefaults];
        [[AppUserInfo sharedAppUserInfo] clearUserDefaults];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"userLogout"])
    {
     
        [[FBSession activeSession] closeAndClearTokenInformation];
        [[FBSession activeSession] close];

        [[AppLogin sharedAppLogin] clearUserDefaults];
        [[AppUserInfo sharedAppUserInfo] clearUserDefaults];
    }
}

@end
