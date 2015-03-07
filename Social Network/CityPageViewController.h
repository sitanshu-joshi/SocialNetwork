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
    NSString *strVideoName, *strImageName;
    NSData *videoData ,*imageData;
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

/*
 Multipart Req with Restkit
 */
/*
 NSString* myFilePath = @"/some/path/to/picture.gif";
 RKParams* params = [RKParams params];
 
 // Set some simple values -- just like we would with NSDictionary
 [params setValue:@"Blake" forParam:@"name"];
 [params setValue:@"blake@restkit.org" forParam:@"email"];
 
 // Create an Attachment
 RKParamsAttachment* attachment = [params setFile:myFilePath forParam:@"image1"];
 attachment.MIMEType = @"image/gif";
 attachment.fileName = @"picture.gif";
 
 // Attach an Image from the App Bundle
 UIImage* image = [UIImage imageNamed:@"another_image.png"];
 NSData* imageData = UIImagePNGRepresentation(image);
 [params setData:imageData MIMEType:@"image/png" forParam:@"image2"];
 
 // Let's examine the RKRequestSerializable info...
 NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
 NSLog(@"RKParams HTTPHeaderValueForContentLength = %d", [params HTTPHeaderValueForContentLength]);
 
 // Send a Request!
 [[RKClient sharedClient] post:@"/uploadImages" params:params delegate:self];
 */
@end
