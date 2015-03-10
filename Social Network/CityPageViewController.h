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
    NSMutableArray *arrayForCityPostList;
    NSString *strCityId;
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
    Post *selectedPost;
    NSMutableDictionary *dictOfPost;
}
@property (strong,nonatomic) NSString *strAddress;
@property (weak, nonatomic) IBOutlet UITableView *tblForCityPostList;
@property (weak, nonatomic) IBOutlet UIButton *btnMainMenu;
@property (weak, nonatomic) IBOutlet UIView *containerViewForSharing;
@property (weak, nonatomic) IBOutlet UIButton *btnPhotoSharing;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UITextView *txtViewForPost;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoSharing;

- (IBAction)uploadPhotoButtonTapped:(id)sender;
- (IBAction)uploadVideoButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)likeButtonTapped:(id)sender;
- (IBAction)deleteButtonTapped:(id)sender;


@end
