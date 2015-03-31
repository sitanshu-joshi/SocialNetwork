//
//  NotificationViewController.h
//  Social Network
//
//  Created by Sitanshu Joshi on 3/31/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *arrayForNotification;
}


@property (weak, nonatomic) IBOutlet UITableView *tableForNotification;
@property (weak, nonatomic) IBOutlet UILabel *lblNoData;

-(IBAction)btnBackAction:(id)sender;

@end
