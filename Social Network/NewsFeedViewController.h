//
//  NewsFeedViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 25/01/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, CustomSlideViewControllerDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@property (weak, nonatomic) IBOutlet UIButton *btnMainMenu;

@end
