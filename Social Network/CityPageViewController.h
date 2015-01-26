//
//  CityPageViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface CityPageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tblView;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)btnAddTapped:(id)sender;

@end
