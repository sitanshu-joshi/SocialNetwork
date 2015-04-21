//
//  CommentsViewController.h
//  Social Network
//
//  Created by Sitanshu Joshi on 2/4/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate> {
    NSMutableArray *arrayOfComments;
    MPMoviePlayerController *player;
    NSString *strCommentId;
    NSString *strCommentText;
    NSDictionary *dictForPostComment;
    NSMutableDictionary *dictForUpdateCommnent;
    Comment *comment;
}

@property (strong,nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UILabel *lblNoComments;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imgPostContent;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextView *txtViewForPostDetail;
@property (weak, nonatomic) IBOutlet UITextView *txtViewToUpdateComment;
@property (nonatomic) BOOL isNeedToRefreshPage;
@property (weak, nonatomic) IBOutlet UITextView *txtViewForComment;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UILabel *lblLikeCount;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentCount;
@property (weak, nonatomic) IBOutlet UITableView *tblViewForComments;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIView *viewForEditComment;

- (IBAction)btnEditTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;
- (IBAction)btnPostTapped:(id)sender;
-(IBAction)btnLikeDislikeAction:(id)sender;
- (IBAction)updateCommentBtnTapped:(id)sender;

@end
