//
//  CityPageViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityPageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate, CustomSlideViewControllerDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (weak, nonatomic) IBOutlet UIButton *btnMainMenu;
@property (weak, nonatomic) IBOutlet UIView *containerViewForSharing;
@property (weak, nonatomic) IBOutlet UIButton *btnPhotoSharing;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UITextView *txtViewForPost;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoSharing;

@end
