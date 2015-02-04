//
//  CommentsViewController.h
//  Social Network
//
//  Created by Sitanshu Joshi on 2/4/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController

- (IBAction)backButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UITextView *txtViewForComment;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
@property (weak, nonatomic) IBOutlet UITableView *tblViewForComments;

- (IBAction)btnPostTapped:(id)sender;

@end
