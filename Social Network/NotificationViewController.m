//
//  NotificationViewController.m
//  Social Network
//
//  Created by Sitanshu Joshi on 3/31/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize tableForNotification;
@synthesize lblNoData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [lblNoData setHidden:YES];
    [self getNotificationList];
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
}


#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayForNotification.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell_Notification forIndexPath:indexPath];
    
    Notification *notification = [arrayForNotification objectAtIndex:indexPath.row];
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:kCell_Noti_user_name];
    lbl.text = notification.ids;
    
    return cell;
}


#pragma mark Get Notification 
-(void)getNotificationList {
    [[AppDelegate appDelegate].rkomForNotification getObjectsAtPath:kResource_NF_List parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSString *strResponse = operation.HTTPRequestOperation.responseString;
        NSLog(@"%@",strResponse);
        arrayForNotification = [[NSMutableArray alloc] initWithArray:mappingResult.array];
        if (arrayForNotification.count == 0) {
            [lblNoData setHidden:NO];
            [tableForNotification setHidden:YES];
        } else {
            [tableForNotification setHidden:NO];
            [tableForNotification reloadData];
            [lblNoData setHidden:YES];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSString *strResponse = operation.HTTPRequestOperation.responseString;
        NSLog(@"%@",strResponse);
        
    }];
}

-(IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
