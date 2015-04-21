//
//  NotificationViewController.m
//  Social Network
//
//  Created by Sitanshu Joshi on 3/31/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCell.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize tableForNotification;
@synthesize lblNoData;

#pragma mark - LifeCycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [lblNoData setHidden:YES];
    [self getNotificationList];
    [self getReadNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods
-(IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayForNotification.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @autoreleasepool {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell_Notification forIndexPath:indexPath];
        // Array operation
        Notification *notification = [arrayForNotification objectAtIndex:indexPath.row];
        // Cell
        NotificationCell *cellNew = (NotificationCell *)cell;
        cellNew.lblName.text = [NSString stringWithFormat:@"%@ %@",notification.senderName,notification.activityType];
        
        
        return cell;
    }
}


#pragma mark - RestKit Request/Response Delegate Methods

-(void)getNotificationList {
    [[AppDelegate appDelegate].rkomForNotification getObjectsAtPath:kResource_NF_List parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSString *strResponse = operation.HTTPRequestOperation.responseString;
        NSLog(@"%@",strResponse);
        DataForResponse *data = [mappingResult.array firstObject];
        
        arrayForNotification = [[NSMutableArray alloc] initWithArray:[data.notification allObjects]];
        if (arrayForNotification.count == 0) {
            [lblNoData setHidden:NO];
            [tableForNotification setHidden:YES];
        } else {
            [tableForNotification setHidden:NO];
            [tableForNotification reloadData];
            [lblNoData setHidden:YES];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        if(error.code == -(kRequest_Server_Not_Rechable)){
            [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
        }else if(error.code == -(kRequest_TimeOut)){
            [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Request_TimeOut delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
        }else if(operation.HTTPRequestOperation.response.statusCode == kRequest_Forbidden_Unauthorized){
            [RSActivityIndicator showIndicatorWithTitle:@"Please Wait"];
            [[AppDelegate appDelegate] loginWithExistingCredential];
            sleep(5);
            [RSActivityIndicator hideIndicator];
            [self getNotificationList];
            return;
        }else{
            if(operation.HTTPRequestOperation.responseData){
                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:NSJSONReadingAllowFragments error:&error];
                if(dictResponse){
                    if ([[dictResponse valueForKey:@"code"] intValue] == kINVALID_SESSION){
                        [RSActivityIndicator showIndicatorWithTitle:@"Please Wait"];
                        [[AppDelegate appDelegate] loginWithExistingCredential];
                        sleep(5);
                        [RSActivityIndicator hideIndicator];
                        [self getNotificationList];
                        return;
                        
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                        [lblNoData setHidden:NO];
                        [tableForNotification setHidden:YES];
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_Operation_Complete){
                        NSLog(@"Opertaion Completed Successfully");
                    }
                }else{
                    [lblNoData setHidden:NO];
                    [tableForNotification setHidden:YES];
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [lblNoData setHidden:NO];
                [tableForNotification setHidden:YES];
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
    }];
}

-(void)getReadNotification {
    Notification *notificaion;
    [[AppDelegate appDelegate].rkomForNotification putObject:notificaion path:kResource_NF_Read_Count parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSString *strResponse = operation.HTTPRequestOperation.responseString;
        NSLog(@"%@",strResponse);
        DataForResponse *data = [mappingResult.array firstObject];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        if(error.code == -(kRequest_Server_Not_Rechable)){
            [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
        }else if(error.code == -(kRequest_TimeOut)){
            [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Request_TimeOut delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
        }else if(operation.HTTPRequestOperation.response.statusCode == kRequest_Forbidden_Unauthorized){
            [RSActivityIndicator showIndicatorWithTitle:@"Please Wait"];
            [[AppDelegate appDelegate] loginWithExistingCredential];
            sleep(5);
            [RSActivityIndicator hideIndicator];
            [self getReadNotification];
            return;
        }else{
            if(operation.HTTPRequestOperation.responseData){
                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:NSJSONReadingAllowFragments error:&error];
                if(dictResponse){
                    if ([[dictResponse valueForKey:@"code"] intValue] == kINVALID_SESSION){
                        [RSActivityIndicator showIndicatorWithTitle:@"Please Wait"];
                        [[AppDelegate appDelegate] loginWithExistingCredential];
                        sleep(5);
                        [RSActivityIndicator hideIndicator];
                        [self getReadNotification];
                        return;
                        
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                        NSLog(@"Data Not Exist");
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_Operation_Complete){
                        NSLog(@"Opertaion Completed Successfully");
                    }
                }else{
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
    }];
}

@end
