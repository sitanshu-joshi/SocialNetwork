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
@synthesize btnVideoSharing,btnPhotoSharing,btnShare,btnMainMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    [btnMainMenu addTarget:self action: @selector(mainMenuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.revealViewController.delegate = self;
    NSLog(@"Address:%@",self.strAddress);
    NSArray *arrOfAddress = [self.strAddress componentsSeparatedByString:@","];
    NSString *strCity, *strCountry, *strState;
    strCountry = [NSString stringWithFormat:@"%@",[[arrOfAddress lastObject]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    strState = [[NSString stringWithFormat:@"%@",[arrOfAddress objectAtIndex:[arrOfAddress count]-2]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (arrOfAddress.count >= 3) {
        strCity = [NSString stringWithFormat:@"%@",[[arrOfAddress objectAtIndex:[arrOfAddress count]-3]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }else{
        strCity = @"";
    }
    [self getCityIdWithCountry:strCountry State:strState City:strCity];
    page = 1;
    strCityId = @"";    //set city id here
    //[self getPostDetailsForCity:strCityId pageNumber:page];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpUserInterface];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.txtViewForPost resignFirstResponder];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}
#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:kPush_To_Comment sender:self];
    [self.txtViewForPost resignFirstResponder];
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
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
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        // Handle a movie capture
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[info objectForKey:UIImagePickerControllerMediaURL] options:nil];
            NSTimeInterval durationInSeconds = 0.0;
            if (asset)
                durationInSeconds = CMTimeGetSeconds(asset.duration);
            NSLog(@"duration: %.2f", durationInSeconds);
            if(durationInSeconds < 20.0){
                NSString *moviePath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
                videoURL = [NSURL fileURLWithPath:moviePath];
                NSDateFormatter *myDateFormat= [[NSDateFormatter alloc]init];
                [myDateFormat setDateFormat:@"ddMMYYYYHHmmss"];
                NSString *date=[myDateFormat stringFromDate:[NSDate date]];
                strVideoName = [NSString stringWithFormat:@"%@%@",date,[[videoURL path] lastPathComponent]];
                videoData = nil;
                videoData = [NSData dataWithContentsOfURL:videoURL];
                [imagePicker dismissViewControllerAnimated:YES completion:nil];
            }else if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo){
                    NSString *imagePath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
                    imageURL = [NSURL fileURLWithPath:imagePath];
                    NSDateFormatter *myDateFormat= [[NSDateFormatter alloc]init];
                    [myDateFormat setDateFormat:@"ddMMYYYYHHmmss"];
                    NSString *date=[myDateFormat stringFromDate:[NSDate date]];
                    strImageName = [NSString stringWithFormat:@"%@%@",date,[[imageURL path] lastPathComponent]];
                    imageData = nil;
                    imageData = [NSData dataWithContentsOfURL:imageURL];
                    [imagePicker dismissViewControllerAnimated:YES completion:nil];
            }else{
                //Alert
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:kAppTitle message:kVideoLengthAlert delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
                [alertView show];
                alertView.tag = 6;
            }
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
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.post);
        mutArrOfPost = [NSMutableArray arrayWithArray:[dataResponse.post allObjects]];
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
        [self getPostDetailsForCity:cityId pageNumber:page];
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

#pragma mark - To Post Data on City Wall
-(void)postOnCityWall:(NSDictionary *)dict withCityId:(NSString *)cityId{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kWallPostOnUserCity,cityId];
    DataForResponse *data;
    [[AppDelegate appDelegate].rkomForPost postObject:data path:strPath parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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

#pragma mark - To Update Wall Post
-(void)updateWallPost:(NSDictionary *)dict withPostId:(NSString *)postId{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kUpdateWallPost,postId];
    DataForResponse *data;
    [[AppDelegate appDelegate].rkomForPost putObject:data path:strPath parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
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
-(void)likePost:(NSDictionary *)dict withPostId:(NSString *)postId{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kLikePost,postId];
    DataForResponse *data;
    [[AppDelegate appDelegate].rkomForPost postObject:data path:strPath parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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

#pragma mark - To UnLike Post
-(void)unLikePost:(NSDictionary *)dict withPostId:(NSString *)postId{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kUnLikePost,postId];
    DataForResponse *data;
    [[AppDelegate appDelegate].rkomForPost postObject:data path:strPath parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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

#pragma mark - To get Like Count
-(void)getLikeCountForPost:(NSString *)postId{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kGetLikeCount,postId];
    [[AppDelegate appDelegate].rkomForPost getObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.post);
        mutArrOfPost = [NSMutableArray arrayWithArray:[dataResponse.post allObjects]];
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

@end
