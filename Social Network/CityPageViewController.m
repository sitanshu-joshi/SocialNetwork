//
//  CityPageViewController.m
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import "CityPageViewController.h"

@interface CityPageViewController ()

@end

@implementation CityPageViewController
@synthesize btnVideoSharing,btnPhotoSharing,btnShare,btnMainMenu,btnBarNews,btnBarNotification,btnBarNotificationCount,btnBarPost;
@synthesize tblForCityPostList;

- (void)viewDidLoad {
    [super viewDidLoad];
    arrOfCellHeight = [NSMutableArray array];
    [btnMainMenu addTarget:self action: @selector(mainMenuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.revealViewController.delegate = self;
    NSLog(@"Address:%@",self.strAddress);
    dictOfPost = [NSMutableDictionary dictionary];
    [tblForCityPostList setHidden:YES];
    btnBarNotificationCount.layer.cornerRadius = 14.0;
    [btnBarNotificationCount setHidden:YES];
    page = 1;
    if(self.strAddress){
        NSArray *arrOfAddress = [self.strAddress componentsSeparatedByString:@","];
        
        strCountry = [NSString stringWithFormat:@"%@",[[arrOfAddress lastObject]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        strState = [[NSString stringWithFormat:@"%@",[arrOfAddress objectAtIndex:[arrOfAddress count]-2]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (arrOfAddress.count >= 3) {
            strCity = [NSString stringWithFormat:@"%@",[[arrOfAddress objectAtIndex:[arrOfAddress count]-3]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }else{
            strCity = @"";
        }
        [self getCityIdWithCountry:strCountry State:strState City:strCity];
    }else{
        strCountry = @"India";
        strState = @"Gujarat";
        strCity = @"Ahmedabad";
        [self getCityIdWithCountry:strCountry State:strState City:strCity];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpUserInterface];
    [self performSelector:@selector(getNotificationCount) withObject:nil afterDelay:20.0];
    
    
}
-(void)mainMenuBtnClicked {
    [self.revealViewController revealToggle:btnMainMenu];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUserInterface{
    btnShare.layer.cornerRadius = 7.0;
}


#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [arrayForCityPostList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect frame;
    static NSString *identifier = @"cell";
    [self.txtViewForPost resignFirstResponder];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    Post *post = [arrayForCityPostList objectAtIndex:indexPath.section];
    UIImageView *imgBg = (UIImageView *)[cell viewWithTag:kCell_city_user_Background];
    //UIImageView *imgProfile = (UIImageView *)[cell viewWithTag:kCell_city_user_profile];
    UILabel *lblUserName = (UILabel *)[cell viewWithTag:kCell_city_user_name];
    UILabel *lblTime = (UILabel *)[cell viewWithTag:kCell_city_user_time];
    UILabel *lblForPost = (UILabel *)[cell viewWithTag:kCell_city_post_text];
    UIImageView *imgMedia = (UIImageView *)[cell viewWithTag:kCell_city_post_image];
    UILabel *lblCommentCount = (UILabel *)[cell viewWithTag:kCell_city_post_commentcount];
    //UIButton *btnComment = (UIButton *) [cell.contentView viewWithTag:kCell_city_post_Comment];
    btnLike = (UIButton *)[cell viewWithTag:kCell_city_post_isMyLike];
    lblLikeCount = (UILabel *)[cell viewWithTag:kCell_city_post_likecount];
    UIButton *btnDelete = (UIButton *)[cell viewWithTag:kCell_city_post_delete];
    UIButton *btnEdit = (UIButton *) [cell.contentView viewWithTag:kCell_city_post_Update];
    
    lblUserName.text = post.username;
    lblTime.text = [NSString stringWithFormat:@"%@",post.createdDate];
    
    frame = lblForPost.frame;
    int intBufferHeight = 8.0;
//    if(IS_IPHONE_5){
//        intBufferHeight = 28.0;
//    }
    frame.size.height = [self calculateLabelHeightBasedOnString:[NSString stringWithFormat:@"%@",post.text]].size.height+intBufferHeight;
    [lblForPost setFrame:frame];
    lblForPost.text = nil;
    
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: [UIColor whiteColor],
                              NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:15.0]
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",post.text]
                                           attributes:attribs];
    lblForPost.attributedText = attributedText;
    lblForPost.layer.cornerRadius = 5.0;
    lblForPost.layer.masksToBounds = YES;
    lblForPost.lineBreakMode = NSLineBreakByWordWrapping;
    lblForPost.numberOfLines = 0;
    
    frame = imgMedia.frame;
    int intOriginY = 123.0;
//    if(IS_IPHONE_5){
//        intOriginY = 54.0f;
//    }
    
    if([post.mediaType intValue] == 1){
        frame.origin.y = [self calculateLabelHeightBasedOnString:[NSString stringWithFormat:@"%@",post.text]].size.height+intOriginY;
        [imgMedia setFrame:frame];
        imgMedia.image = [UIImage imageNamed:@"img_placeholder .jpg"];
        NSString *strFileName = [[post.mediaUrl componentsSeparatedByString:@"/"] lastObject];
        if([post.mediaUrl length]>0){
            if([[FileUtility utility] checkFileIsExistOnDocumentDirectoryFolder:[[[FileUtility utility] documentDirectoryPath] stringByAppendingString:kDD_Images] withFileName:strFileName]){
                imgMedia.image = [UIImage imageWithContentsOfFile:[[[FileUtility utility] documentDirectoryPath] stringByAppendingString:[NSString stringWithFormat:@"%@/%@",kDD_Images,strFileName]]];
            }
            imgMedia.layer.borderColor = (__bridge CGColorRef)([UIColor blackColor]);
            imgMedia.layer.borderWidth = 10.0;
            [imgMedia setHidden:NO];
        }else{
            [imgMedia setHidden:YES];
        }
    }else if([post.mediaType intValue] == 2){
        frame.origin.y = [self calculateLabelHeightBasedOnString:[NSString stringWithFormat:@"%@",post.text]].size.height+intOriginY;
        [imgMedia setFrame:frame];
        imgMedia.image = [UIImage imageNamed:@"video-placeholder.png"];
        imgMedia.layer.borderColor = (__bridge CGColorRef)([UIColor whiteColor]);
        imgMedia.layer.borderWidth = 2.0;
    }else{
        [imgMedia setHidden:YES];
        frame.origin.y = [self calculateLabelHeightBasedOnString:[NSString stringWithFormat:@"%@",post.text]].size.height;
        [imgMedia setFrame:frame];
    }
    imgMedia.layer.cornerRadius = 5.0;
    imgMedia.layer.masksToBounds = YES;
    lblCommentCount.text = [NSString stringWithFormat:@"%@",post.commentCount];
    [btnLike addTarget:self
                 action:@selector(btnLikeDislikeAction:)
       forControlEvents:UIControlEventTouchUpInside];
    BOOL ismyLike = [post.isMyLike boolValue];
    if (ismyLike == true) {
        [btnLike setSelected:YES];
    } else {
        [btnLike setSelected:NO];
    }
    lblLikeCount.text = [NSString stringWithFormat:@"%@",post.likeCount];
    BOOL ismyPost = [post.isMyPost boolValue];
    if(ismyPost == true) {
        [btnDelete setHidden:NO];
        [btnEdit setHidden:NO];
    } else {
        [btnDelete setHidden:YES];
        [btnEdit setHidden:YES];
    }
    imgBg.frame = CGRectMake(imgBg.frame.origin.x, imgBg.frame.origin.y, imgBg.frame.size.width, imgMedia.frame.origin.y + imgMedia.frame.size.height + 5);
    imgBg.layer.cornerRadius = 5.0;
    imgBg.layer.masksToBounds = YES;
    return cell;
}
#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.txtViewForPost resignFirstResponder];
    //Get Post id of selected Post and pass to comment page to get comments for particular post
    Post *post = [arrayForCityPostList objectAtIndex:indexPath.section];
    selectedPost = post;
    [self performSegueWithIdentifier:kPush_To_Comment sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:kPush_To_Comment]){
        commentsViewController = (CommentsViewController *)[segue destinationViewController];
        commentsViewController.post = selectedPost;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    Post *post = [arrayForCityPostList objectAtIndex:indexPath.row];
//    NSString *postText = post.text;
//    NSDictionary *attributesDictionaryForDescription = [NSDictionary dictionaryWithObjectsAndKeys:  Font_Roboto_Condensed_16, NSFontAttributeName,[UIColor blackColor], NSForegroundColorAttributeName,nil];
//    CGRect rectForDescription = [postText boundingRectWithSize:CGSizeMake(300.f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributesDictionaryForDescription context:nil];
//    CGFloat heightOfCell = rectForDescription.origin.y + rectForDescription.size.height + 240;
//    return heightOfCell;
//    
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[arrOfCellHeight objectAtIndex:indexPath.section] intValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat heightOfHeader;
    if(section == 0){
        heightOfHeader = 0.0;
    }else{
        heightOfHeader = 10.0;
    }
    return heightOfHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewForHeader;
    if(section == 0){
        viewForHeader = nil;
    }else{
        viewForHeader = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return viewForHeader;
}

#pragma mark - UITextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if([textView isEqual:self.txtViewForUpdatePost]){
            [UIView animateWithDuration:0.5 animations:^{
                self.viewForUpdatePost.frame = CGRectMake(0, 700, self.viewForUpdatePost.frame.size.width, self.viewForUpdatePost.frame.size.height);
            }];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.viewForUpdatePost.frame = CGRectMake(0, 700, self.viewForUpdatePost.frame.size.width, self.viewForUpdatePost.frame.size.height);
    }];
    return YES;
}


- (IBAction)captureVideoBtnTapped:(UIButton *)button{
    //[self hideKeyboard];
    @autoreleasepool {
        if(button.tag == 0){
           //Photo
           
        }else{
        //Video
           
        }
       
    }
}

- (IBAction)uploadPhotoButtonTapped:(id)sender {
     actionSheetButtonTitle = kPhotoLibrary;
    [UIView animateWithDuration:0.5 animations:^{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:kTakePhoto delegate:self cancelButtonTitle:kCancelButton destructiveButtonTitle:nil otherButtonTitles:actionSheetButtonTitle,kCamera,nil];
        [actionSheet showInView:self.view];
    }];
}

- (IBAction)uploadVideoButtonTapped:(id)sender {
     actionSheetButtonTitle = kVideoLibrary;
    [UIView animateWithDuration:0.5 animations:^{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:kTakeVideo delegate:self cancelButtonTitle:kCancelButton destructiveButtonTitle:nil otherButtonTitles:actionSheetButtonTitle,kCamera,nil];
        [actionSheet showInView:self.view];
    }];
}

- (IBAction)shareButtonTapped:(id)sender {

    [dictOfPost setObject:self.txtViewForPost.text forKey:kPost_Text];
    [self postOnCityWall:dictOfPost withCityId:self.strCityId];
}

- (IBAction)likeButtonTapped:(id)sender {
}

- (IBAction)deleteButtonTapped:(UIButton *)sender {
    NSIndexPath* indexPath = [self.tblForCityPostList indexPathForRowAtPoint:[self.tblForCityPostList convertPoint:sender.center fromView:sender.superview]];
    Post *post = [arrayForCityPostList objectAtIndex:indexPath.row];
    [self deleteWallPost:post.ids];
}

- (IBAction)updatePostBtnTapped:(id)sender {
    NSMutableDictionary *dictOfPostData =[NSMutableDictionary dictionary];
    [dictOfPostData setObject:self.txtViewForUpdatePost.text forKey:kPost_Text];
    [self updateWallPost:dictOfPostData withPostId:myPostId];
}



- (IBAction)btnUpdatePostTapped:(UIButton *)sender {
    NSIndexPath* indexPath = [self.tblForCityPostList indexPathForRowAtPoint:[self.tblForCityPostList convertPoint:sender.center fromView:sender.superview]];
    Post *post = [arrayForCityPostList objectAtIndex:indexPath.row];
   myPostId= post.ids;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewForUpdatePost.frame = CGRectMake(0,140, self.viewForUpdatePost.frame.size.width, self.viewForUpdatePost.frame.size.height);
        self.txtViewForUpdatePost.text = post.text;
        [self.txtViewForUpdatePost becomeFirstResponder];
    }];
}

- (IBAction)refreshBtnTapped:(id)sender {
   [self getCityIdWithCountry:strCountry State:strState City:strCity];
}

-(IBAction)btnLikeDislikeAction:(UIButton *)sender {
    NSIndexPath* indexPath = [self.tblForCityPostList indexPathForRowAtPoint:[self.tblForCityPostList convertPoint:sender.center fromView:sender.superview]];
    Post *post = [arrayForCityPostList objectAtIndex:indexPath.row];
    if (sender.selected) {
        // Do it for dislike
        [self unLikePostwithPostId:post.ids];
    } else {
        // Do it for dislike
        [self likePostwithPostId:post.ids];
    }
}

#pragma mark - UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        @autoreleasepool {
            //PHOTO ALBUM
            if([actionSheetButtonTitle isEqualToString:kPhotoLibrary]){
                [self startCameraControllerFromViewController:self usingDelegate:self sourceType:(int)buttonIndex selectedSource:kPhotoLibrary];
            }else if([actionSheetButtonTitle isEqualToString:kVideoLibrary]){
                [self startCameraControllerFromViewController:self usingDelegate:self sourceType:(int)buttonIndex selectedSource:kVideoLibrary];
            }
        }
    }else if(buttonIndex == 1){
        @autoreleasepool {
            //CAMERA
            [self startCameraControllerFromViewController:self usingDelegate:self sourceType:(int)buttonIndex selectedSource:kCamera];
        }
    }
}

//This will call to capture video from camera or import from Library
-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller usingDelegate:(id )delegate sourceType:(int)source selectedSource:(NSString *)strSourceType
{
    @autoreleasepool {
        // Get image picker
        imagePicker = [[UIImagePickerController alloc] init];
        //To Check SourceType
        if(source == 0){
            //Photo Album
            // 1 - Validations
            if([strSourceType isEqualToString:kPhotoLibrary]){
                if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO) || (delegate == nil) || (controller == nil)) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:kAppTitle message:kCameraAlert delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
                    [alertView show];
                    return NO;
                }else{
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeImage, nil];
                    // Hides the controls for moving & scaling pictures, or for
                    // trimming movies. To instead show the controls, use YES.
                    imagePicker.allowsEditing = NO;
                    imagePicker.delegate = delegate;
                    // 3 - Display image picker
                    [controller presentViewController: imagePicker animated:YES completion:nil];
                    return YES;
                }
            }else if ([strSourceType isEqualToString:kVideoLibrary]){
                if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO) || (delegate == nil) || (controller == nil)) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:kAppTitle message:kCameraAlert delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
                    [alertView show];
                    return NO;
                }else{
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
                    // Hides the controls for moving & scaling pictures, or for
                    // trimming movies. To instead show the controls, use YES.
                    imagePicker.allowsEditing = NO;
                    imagePicker.delegate = delegate;
                    // 3 - Display image picker
                    [controller presentViewController: imagePicker animated:YES completion:nil];
                    return YES;
                }
            }
        }else if(source == 1){
            //Camera
            // 1 - Validations
            if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil)) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:kAppTitle message:kCameraAlert delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
                [alertView show];
                return NO;
            }else{
                //[self performSegueWithIdentifier:kPushToCamera sender:self];
                return YES;
            }
        }
        return YES;
    }
}

#pragma mark - UIImagePickerController Delegate Methods
//THis will call when Video Captured.
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    @autoreleasepool {
        NSString *media = [info objectForKey: UIImagePickerControllerMediaType];
        // Handle a movie capture
        if (CFStringCompare ((__bridge CFStringRef) media, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[info objectForKey:UIImagePickerControllerMediaURL] options:nil];
            NSTimeInterval durationInSeconds = 0.0;
            if (asset)
                durationInSeconds = CMTimeGetSeconds(asset.duration);
            NSLog(@"duration: %.2f", durationInSeconds);
            if(durationInSeconds < 20.0){
                NSString *moviePath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
                //myFilePath = moviePath;
                videoURL = [NSURL fileURLWithPath:moviePath];
                NSDateFormatter *myDateFormat= [[NSDateFormatter alloc]init];
                [myDateFormat setDateFormat:@"ddMMYYYYHHmmss"];
                NSString *date=[myDateFormat stringFromDate:[NSDate date]];
                fileName = [NSString stringWithFormat:@"%@%@",date,[[videoURL path] lastPathComponent]];
                fileType = @"video/quicktime";
                mediaType = @"2";
                contentData = nil;
                contentData = [NSData dataWithContentsOfURL:videoURL];
                [imagePicker dismissViewControllerAnimated:YES completion:nil];
            }else{
                //Alert
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:kAppTitle message:kVideoLengthAlert delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
                [alertView show];
                alertView.tag = 6;
            }
        }else if (CFStringCompare ((__bridge CFStringRef) media, kUTTypeImage, 0) == kCFCompareEqualTo){
            //NSString *imagePath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaType] path];
            imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
            //myFilePath = imagePath;
            imageToPost = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
            //imageURL = [NSURL fileURLWithPath:imagePath];
            NSDateFormatter *myDateFormat= [[NSDateFormatter alloc]init];
            [myDateFormat setDateFormat:@"ddMMYYYYHHmmss"];
            NSString *date=[myDateFormat stringFromDate:[NSDate date]];
            fileName = [NSString stringWithFormat:@"%@%@",date,[[imageURL path] lastPathComponent]];
            fileType = @"image/jpeg";
            mediaType = @"1";
            contentData = nil;
            contentData =  UIImageJPEGRepresentation(imageToPost, 1.0);
            //contentData = [NSData dataWithContentsOfURL:imageURL];
            [imagePicker dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - To get Post Data
-(void)getPostDetailsForCity:(NSString *)cityId pageNumber:(int)pageNumber{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kGetPost,cityId,pageNumber];
    [[AppDelegate appDelegate].rkomForPost getObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        [arrOfCellHeight removeAllObjects];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.post);
        arrayForCityPostList = [NSMutableArray arrayWithArray:[dataResponse.post allObjects]];
        if (arrayForCityPostList.count >= 1) {
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedDate" ascending:NO];
            NSArray *sortedArray = [arrayForCityPostList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            arrayForCityPostList = [[NSMutableArray alloc] initWithArray:sortedArray];
            [self downloadPostImages:arrayForCityPostList];
            for (int i=0;i<[arrayForCityPostList count]; i++) {
                Post *post = [arrayForCityPostList objectAtIndex:i];
                
                NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [UIFont fontWithName:@"Helventica Neue" size:13], NSFontAttributeName,
                                                      nil];
                int intOfDefaultWidth = 300.0f;
//                if(IS_IPHONE_5){
//                    intOfDefaultWidth = 250.0f;
//                }
                NSString *strDesc = [NSString stringWithFormat:@"%@",post.text];
                CGRect rect = [strDesc boundingRectWithSize:CGSizeMake(intOfDefaultWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
                int intBufferSize = 125.0;
//                if(IS_IPHONE_5){
//                    intBufferSize = 88.0f;
//                }
                int height = intBufferSize;
                height+=rect.size.height;
                if(post.mediaUrl){
                    height = height + 128.0;
                }
                [arrOfCellHeight addObject:[NSString stringWithFormat:@"%d",height]];
            }
            [tblForCityPostList setHidden:NO];
            [tblForCityPostList reloadData];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSData *responseData = [[NSString stringWithFormat:@"%@",operation.HTTPRequestOperation.responseString]dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSString *errorMessage = [responseDict valueForKey:@"msg"];
        //NSString *errorMessage = [NSString stringWithFormat:@"%@",error.localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:errorMessage delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
        [alert show];
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

-(void)downloadPostImages:(NSMutableArray *)array {
    for (int iForElse = 0; iForElse<[array count]; iForElse++) {
        @autoreleasepool {
            Post *post = [array objectAtIndex:iForElse];
            NSString *strFileName = [[post.mediaUrl componentsSeparatedByString:@"/"] lastObject];
            if([post.mediaUrl length]>0){
                if(![[FileUtility utility] checkFileIsExistOnDocumentDirectoryFolder:[[[FileUtility utility] documentDirectoryPath] stringByAppendingString:kDD_Images] withFileName:strFileName]){
                    IconDownloader *iconDownloader;
                    if (iconDownloader == nil) {
                        iconDownloader = [[IconDownloader alloc] init];
                        iconDownloader.strIconURL = post.mediaUrl;
                        [iconDownloader setCompletionHandler:^(UIImage *image){
                            NSData *data = UIImagePNGRepresentation(image);
                            
                            [[FileUtility utility] createFile:strFileName atFolder:[[[FileUtility utility] documentDirectoryPath] stringByAppendingString:kDD_Images] withData:data];
                            [tblForCityPostList reloadData];
                        }];
                        [iconDownloader startDownload];
                    }
                }
            }
        }
    }
}


#pragma mark - To get City List
-(void)getListOfCities:(int)pageNumber{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kGetListOfCity,pageNumber];
    [[AppDelegate appDelegate].rkomForPost getObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.post);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSString *errorMessage = [NSString stringWithFormat:@"%@",error.localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:errorMessage delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
        [alert show];
        RKLogError(@"Operation failed with error: %@", error);
    }];
}


#pragma mark - To get City Id
-(void)getCityIdWithCountry:(NSString *)country State:(NSString *)state City:(NSString *)city{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kGetCityId,city,state,country];
    [[AppDelegate appDelegate].rkomForCity getObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //[RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.city);
        City *city = [[dataResponse.city allObjects]firstObject];
        NSString *cityId = city.ids;
        self.strCityId = cityId;
        [self getPostDetailsForCity:cityId pageNumber:page];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:NSJSONReadingMutableContainers error:&error];
        if(dictResponse){
            NSString *message = [NSString stringWithFormat:@"%@",[dictResponse valueForKey:@"msg"]];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:message delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
            [alert show];
        }
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

#pragma mark - To Post Data on City Wall
-(void)postOnCityWall:(NSDictionary *)dict withCityId:(NSString *)cityId{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kWallPostOnUserCity,cityId];
    
    //UIImage *image = imageToPost;
    
    // Serialize the Article attributes then attach a file
    NSString *strTextToPost = self.txtViewForPost.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    mediaType ? [params setObject:mediaType forKey:@"MEDIA_TYPE"] : @"";
    strTextToPost ? [params setObject:strTextToPost forKey:@"POST_TEXT"] : @"" ;
    
    NSMutableURLRequest *request = [[AppDelegate appDelegate].rkomForPost multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:strPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:contentData
                                    name:@"FILE"
                                fileName:fileName
                                mimeType:fileType];
    }];
    
    RKObjectRequestOperation *operation = [[AppDelegate appDelegate].rkomForPost objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
    }];
    [[AppDelegate appDelegate].rkomForPost enqueueObjectRequestOperation:operation];
}

#pragma mark - To Update Wall Post
-(void)updateWallPost:(NSDictionary *)dict withPostId:(NSString *)postId{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    [self.txtViewForUpdatePost resignFirstResponder];
    NSString *strPath = [NSString stringWithFormat:kUpdateWallPost,postId];
    DataForResponse *data;
    [[AppDelegate appDelegate].rkomForPost putObject:data path:strPath parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSData *data = [operation.HTTPRequestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if([[dict valueForKey:@"code"]integerValue] == 2000){
            NSString *message = [dict valueForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:message delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
            [alert show];
            [self getPostDetailsForCity:self.strCityId pageNumber:page];
        }
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

#pragma mark - To Delete Wall Post
-(void)deleteWallPost:(NSString *)postId {
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kDeleteWallPost,postId];
    [[AppDelegate appDelegate].rkomForPost deleteObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.post);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSString *errorMessage = [NSString stringWithFormat:@"%@",error.localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:errorMessage delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
        [alert show];
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

#pragma mark - To Like Post
/**
 *  This will set like post by logged in user
 *
 *  @param postId
 */
-(void)likePostwithPostId:(NSString *)postId{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kResource_LikePost,postId];
    DataForResponse *data;
    [[AppDelegate appDelegate].rkomForPost postObject:data path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.post);
        int likecount = [lblLikeCount.text intValue] + 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:YES];
        [self.tblForCityPostList reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSString *errorMessage = [NSString stringWithFormat:@"%@",error.localizedDescription];
        int likecount = [lblLikeCount.text intValue] + 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:YES];
        [self.tblForCityPostList reloadData];
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

#pragma mark - To UnLike Post
/**
 *  It will set post unliked by current logged in user.
 *
 *  @param dict
 *  @param postId
 */
-(void)unLikePostwithPostId:(NSString *)postId{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kResource_UnLikePost,postId];
    DataForResponse *data;
    [[AppDelegate appDelegate].rkomForPost postObject:data path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.post);
        int likecount = [lblLikeCount.text intValue] - 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:NO];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSString *errorMessage = [NSString stringWithFormat:@"%@",error.localizedDescription];
        int likecount = [lblLikeCount.text intValue] - 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:NO];
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

#pragma mark - To get Like Count
-(void)getLikeCountForPost:(NSString *)postId{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kGetLikeCount,postId];
    [[AppDelegate appDelegate].rkomForPost getObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.post);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSString *errorMessage = [NSString stringWithFormat:@"%@",error.localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:errorMessage delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
        [alert show];
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

-(void)getNotificationCount {
    [[AppDelegate appDelegate].rkomForNotification getObjectsAtPath:kResource_NF_count parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSString *strResponse = operation.HTTPRequestOperation.responseString;
         NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        NSArray *nfCount = [[jsonObject valueForKey:@"data"] valueForKey:@"count"];
        btnBarNotificationCount.titleLabel.text = [NSString stringWithFormat:@"%@",[nfCount firstObject]];
        NSLog(@"%@",[[jsonObject valueForKey:@"data"] valueForKey:@"count"]);
        [btnBarNotificationCount setHidden:NO];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSString *strResponse = operation.HTTPRequestOperation.responseString;
        NSLog(@"%@",strResponse);
        
        
        
    }];
}

#pragma mark - Dynamic Height Calculation Method

-(CGRect)calculateLabelHeightBasedOnString:(NSString *)strDesc {
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Helventica Neue" size:15.0], NSFontAttributeName,
                                          nil];
    int intOfDefaultWidth = 300.0;
//    if(IS_IPHONE_5){
//        intOfDefaultWidth = 250.0f;
//    }
    CGRect rect = [strDesc boundingRectWithSize:CGSizeMake(intOfDefaultWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
    return rect;
}

@end
