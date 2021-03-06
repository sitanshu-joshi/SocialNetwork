//
//  CityPageViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSlideViewController.h"
#import "CommentsViewController.h"

@interface CityPageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate, CustomSlideViewControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    int page;
    NSString *cityIdForCurrentCity;
    NSMutableArray *arrOfCellHeight;
    NSMutableArray *arrayForCityPostList;
    UIImagePickerController *imagePicker;
    NSString *actionSheetButtonTitle;
    NSURL *videoURL, *imageURL;
    NSString *contentToPost;
    NSData *contentData;
    NSString *fileName;
    NSString *fileType;
    NSString *mediaType;
    UIImage *imageToPost;
    NSString* myFilePath;
    CommentsViewController *commentsViewController;
    Post *post;
    NSMutableDictionary *dictOfPost;
    UIButton *btnLike;
    UILabel *lblLikeCount;
    NSString *myPostId;
    NSString *strCity, *strCountry, *strState;
    BOOL isFullScreen;
    CGRect prevFrame;
    BOOL isNFCount;
    NSMutableDictionary *dictOfUpdatePostData;
}
@property (weak, nonatomic) IBOutlet UILabel *lblNoPostFound;
@property (strong, nonatomic) NSString *strCityId;
@property (strong,nonatomic) NSString *strAddress;
@property (weak, nonatomic) IBOutlet UITableView *tblForCityPostList;
@property (weak, nonatomic) IBOutlet UIButton *btnMainMenu;
@property (weak, nonatomic) IBOutlet UIView *containerViewForSharing;
@property (weak, nonatomic) IBOutlet UIButton *btnPhotoSharing;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UITextView *txtViewForPost;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoSharing;
@property (weak, nonatomic) IBOutlet UIView *viewForUpdatePost;
@property (weak, nonatomic) IBOutlet UITextView *txtViewForUpdatePost;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewForFullScreenImage;

// Top Bar
@property (weak, nonatomic) IBOutlet UIButton *btnBarNews;
@property (weak, nonatomic) IBOutlet UIButton *btnBarPost;
@property (weak, nonatomic) IBOutlet UIButton *btnBarNotification;
@property (weak, nonatomic) IBOutlet UIButton *btnBarNotificationCount;
@property (weak, nonatomic) IBOutlet UIView *viewForFullSizeImage;

- (IBAction)closeBtnTapped:(id)sender;
- (IBAction)uploadPhotoButtonTapped:(id)sender;
- (IBAction)uploadVideoButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)likeDislikeBtnTapped:(id)sender;
- (IBAction)deleteButtonTapped:(id)sender;
- (IBAction)updatePostBtnTapped:(id)sender;
- (IBAction)btnUpdatePostTapped:(id)sender;
- (IBAction)refreshBtnTapped:(id)sender;
- (IBAction)mediaBtnTapped:(UIButton *)sender;
-(IBAction)unwindSegueFromCommentController:(UIStoryboardSegue *)segue;


@end
