//
//  NewsFeedViewController.m
//  Social Network
//
//  Created by Sagar Gondaliya on 25/01/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "NewsFeedViewController.h"

@interface NewsFeedViewController ()

@end

@implementation NewsFeedViewController
@synthesize btnMainMenu,containerViewForCityInput;
@synthesize newsTableView,tableViewForCityResult,lblNoNewsFound;
@synthesize arrayForNewsfeed,currentPageCount;


#pragma mark - LifeCycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitUI];
    arrOfCellHeight = [NSMutableArray array];
    currentPageCount = 1;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNewsForHomeTown];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods
-(void)setupInitUI {
    [btnMainMenu addTarget:self action: @selector(mainMenuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.revealViewController.delegate = self;
    containerViewForCityInput.layer.cornerRadius = 5.0;
    containerViewForCityInput.layer.masksToBounds = YES;
    self.tableViewForCityResult.layer.cornerRadius = 7.0;
    self.tableViewForCityResult.layer.masksToBounds = YES;
}

-(int)getCurrentPageNumber {
    currentPageCount = 1;
    return currentPageCount;
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
                            [newsTableView reloadData];
                        }];
                        [iconDownloader startDownload];
                    }
                }
            }
        }
    }
}

//Hide City Input View
-(void)hideCityInputView{
    [UIView animateWithDuration:0.5 animations:^{
        self.containerViewForCityInput.frame = CGRectMake(5, 1000, self.containerViewForCityInput.frame.size.width, self.containerViewForCityInput.frame.size.height);
    }];
    isInputViewVisible = NO;
    [self hidekeyBoard];
}

-(void)showCityInputView{
    [UIView animateWithDuration:0.5 animations:^{
        self.containerViewForCityInput.frame = CGRectMake(5, 72, self.containerViewForCityInput.frame.size.width, self.containerViewForCityInput.frame.size.height);
    }];
    isInputViewVisible = YES;
    [self.tableViewForCityResult setHidden:YES];
}

//To hide Keyboard
-(void)hidekeyBoard {
    
    [self.searchBar resignFirstResponder];
    [self.tableViewForCityResult setHidden:YES];
}

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

#pragma mark - IBAction Methods

-(void)mainMenuBtnClicked {
    [self hidekeyBoard];
    [self.revealViewController revealToggle:self.btnMainMenu];
}


- (IBAction)cityBtnTapped:(id)sender {
    if(!isInputViewVisible){
        [self showCityInputView];
    }else{
        [self hideCityInputView];
    }
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.tableViewForCityResult){
        return 1;
    }else{
        return arrayForNewsfeed.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tableViewForCityResult){
        return [resultArray count];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    static NSString *identifier = nil;
    CGRect frame;
    if(tableView == self.tableViewForCityResult) {
        identifier = kCell_Place_Newsfeed;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        Result *result = [resultArray objectAtIndex:indexPath.row];
        UILabel *lblAddress =(UILabel *)[cell.contentView viewWithTag:999];
        lblAddress.text = result.formatted_address;
    } else {
       identifier = kCell_Newsfeed;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        Post *post = [arrayForNewsfeed objectAtIndex:indexPath.section];
        UIImageView *imgBg = (UIImageView *)[cell viewWithTag:kCell_News_Feed_Background];
        UILabel *lblForNews = (UILabel *)[cell viewWithTag:kCell_News_Feed_postText];
        lblForNews.text = post.text;
        
        UILabel *lblForUserName = (UILabel *)[cell viewWithTag:kCell_News_Feed_username];
        lblForUserName.text = post.username;
        
        UILabel *lblLikeCount = (UILabel *)[cell viewWithTag:kCell_News_Feed_likecount];
        lblLikeCount.text = [NSString stringWithFormat:@"%@",post.likeCount];
        
        UILabel *lblCommentCount = (UILabel *)[cell viewWithTag:kCell_News_Feed_commentcount];
        lblCommentCount.text = [NSString stringWithFormat:@"%@",post.commentCount];
        
        UIButton *btn = (UIButton *)[cell viewWithTag:kCell_News_Feed_likebtn];
        BOOL like = [post.isMyLike boolValue];
        if(like == true) {
            [btn setSelected:YES];
        } else {
            [btn setSelected:NO];
        }
        
        UIImageView *imgMedia = (UIImageView *)[cell viewWithTag:kCell_News_Feed_imgContent];
        imgMedia.image = nil;
        
        frame = lblForNews.frame;
        int intBufferHeight = 8.0;
        //    if(IS_IPHONE_5){
        //        intBufferHeight = 28.0;
        //    }
        frame.size.height = [self calculateLabelHeightBasedOnString:[NSString stringWithFormat:@"%@",post.text]].size.height+intBufferHeight;
        [lblForNews setFrame:frame];
        lblForNews.text = nil;
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: [UIColor blackColor],
                                  NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:15.0]
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",post.text]
                                               attributes:attribs];
        lblForNews.attributedText = attributedText;
        lblForNews.layer.cornerRadius = 5.0;
        lblForNews.layer.masksToBounds = YES;
        lblForNews.lineBreakMode = NSLineBreakByWordWrapping;
        lblForNews.numberOfLines = 0;
        
        frame = imgMedia.frame;
        int intOriginY = 85.0;
        //    if(IS_IPHONE_5){
        //        intOriginY = 54.0f;
        //    }
        if([post.mediaType intValue] == 1){
            frame.origin.y = [self calculateLabelHeightBasedOnString:[NSString stringWithFormat:@"%@",post.text]].size.height+intOriginY + intBufferHeight;
            [imgMedia setFrame:frame];
            if([post.mediaUrl length]>0){
                [imgMedia sd_setImageWithURL:[NSURL URLWithString:post.mediaUrl]
                            placeholderImage:[UIImage imageNamed:@"img_placeholder "]
                                     options:SDWebImageRefreshCached];
                imgMedia.layer.borderColor = (__bridge CGColorRef)([UIColor whiteColor]);
                imgMedia.layer.borderWidth = 2.0;
                [imgMedia setHidden:NO];
            }else{
                [imgMedia setHidden:YES];
            }
            imgBg.frame = CGRectMake(imgBg.frame.origin.x, imgBg.frame.origin.y, imgBg.frame.size.width, imgMedia.frame.origin.y + imgMedia.frame.size.height + 5);
            imgBg.layer.cornerRadius = 5.0;
            imgBg.layer.masksToBounds = YES;
        }else if ([post.mediaType intValue] == 2){
            frame.origin.y = [self calculateLabelHeightBasedOnString:[NSString stringWithFormat:@"%@",post.text]].size.height+intOriginY;
            [imgMedia setFrame:frame];
            imgMedia.image = [UIImage imageNamed:@"video-placeholder.png"];
            imgMedia.layer.borderColor = (__bridge CGColorRef)([UIColor whiteColor]);
            imgMedia.layer.borderWidth = 2.0;
            imgBg.frame = CGRectMake(imgBg.frame.origin.x, imgBg.frame.origin.y, imgBg.frame.size.width, imgMedia.frame.origin.y + imgMedia.frame.size.height + 5);
            imgBg.layer.cornerRadius = 5.0;
            imgBg.layer.masksToBounds = YES;
        }else{
//            frame.origin.y = [self calculateLabelHeightBasedOnString:[NSString stringWithFormat:@"%@",post.text]].size.height;
//            [imgMedia setFrame:frame];
            [imgMedia setHidden:YES];
            imgBg.frame = CGRectMake(imgBg.frame.origin.x, imgBg.frame.origin.y, imgBg.frame.size.width,lblForNews.frame.origin.y + lblForNews.frame.size.height + 5.0);
            imgBg.layer.cornerRadius = 5.0;
            imgBg.layer.masksToBounds = YES;
        }
    }
    return cell;
}

#pragma mark - UITableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == newsTableView){
        CGFloat heightOfHeader;
        if(section == 0){
            heightOfHeader = 0.0;
        }else{
            heightOfHeader = 10.0;
        }
        return heightOfHeader;
    }else{
        return 0.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewForHeader;
    if(tableView == newsTableView){
        if(section == 0){
            viewForHeader = nil;
        }else{
            viewForHeader = [[UIView alloc] initWithFrame:CGRectZero];
        }
        return viewForHeader;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == newsTableView){
     return [[arrOfCellHeight objectAtIndex:indexPath.section] intValue];
    }else{
        return 40.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableViewForCityResult){
        [self hideCityInputView];
        Result *result = [resultArray objectAtIndex:indexPath.row];
        strAddress = result.formatted_address;
        strAddress = [strAddress stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self.tableViewForCityResult setHidden:YES];
        [self performSegueWithIdentifier:kPushToCityFromNews sender:self];
    } else {
//        Post *post = [arrayForNewsfeed objectAtIndex:indexPath.section];
//        selectedPost = post;
//        [self performSegueWithIdentifier:kPush_To_CommentFromNews sender:self];
    }
}

#pragma mark - Segue Identifier Method

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:kPushToCityFromNews]){
        CityPageViewController *cityViewController = (CityPageViewController *)[segue destinationViewController];
        cityViewController.strAddress = strAddress;
    } else if([segue.identifier isEqual:kPush_To_CommentFromNews]) {
        CommentsViewController *commentView = (CommentsViewController *)[segue destinationViewController];
        commentView.post = selectedPost;
    }
}

#pragma mark - UISearchBar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"============== %@",searchText);
    strSearchAddress = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self getPlaceForAddress:strSearchAddress];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar {
    [searchbar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchbar {
    [searchbar resignFirstResponder];
    self.searchBar.text = @"";
    [self hidekeyBoard];
    [self hideCityInputView];
}



#pragma mark - RestKit Request/Response Delegate Methods
-(void)getNewsForHomeTown{
    [RSActivityIndicator showIndicator];
    NSString *strPath = [NSString stringWithFormat:kResource_GetNewsFeed,(int)[self currentPageCount]];
    [[AppDelegate appDelegate].rkomForPost getObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        [arrOfCellHeight removeAllObjects];
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        if (dataResponse.post.count >= 1) {
            arrayForNewsfeed = [[NSMutableArray alloc] initWithArray:dataResponse.post.allObjects];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedDate" ascending:NO];
            NSArray *sortedArray = [arrayForNewsfeed sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            arrayForNewsfeed = [[NSMutableArray alloc] initWithArray:sortedArray];
            //[self downloadPostImages:arrayForNewsfeed];
            Post *currentPost;
            for (int i=0;i<[arrayForNewsfeed count]; i++) {
                currentPost = [arrayForNewsfeed objectAtIndex:i];
                
                NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [UIFont fontWithName:@"Helventica Neue" size:15], NSFontAttributeName,
                                                      nil];
                int intOfDefaultWidth = 300.0f;
                //                if(IS_IPHONE_5){
                //                    intOfDefaultWidth = 250.0f;
                //                }
                NSString *strDesc = [NSString stringWithFormat:@"%@",currentPost.text];
                CGRect rect = [strDesc boundingRectWithSize:CGSizeMake(intOfDefaultWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
                int intBufferSize = 85.0;
                int intBufferHeight = 8.0;
                //                if(IS_IPHONE_5){
                //                    intBufferSize = 88.0f;
                //                }
                int height = intBufferSize + intBufferHeight;
                height+=rect.size.height;
                if(currentPost.mediaUrl){
                    height = height + 128.0;
                }
                [arrOfCellHeight addObject:[NSString stringWithFormat:@"%d",height]];
            }
            [newsTableView reloadData];
            [lblNoNewsFound setHidden:YES];
            [newsTableView setHidden:NO];
        }else{
            [lblNoNewsFound setHidden:NO];
            [newsTableView setHidden:YES];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        if(error.code == -(kRequest_Server_Not_Rechable)){
            [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
        }else if(error.code == -(kRequest_TimeOut)){
            [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Request_TimeOut delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
        }else if(operation.HTTPRequestOperation.response.statusCode == kRequest_Forbidden_Unauthorized){
            [RSActivityIndicator showIndicatorWithTitle:@"Please Wait"];
            [[AppDelegate appDelegate] loginWithExistingCredential];
            sleep(5);
            [RSActivityIndicator hideIndicator];
            [self getNewsForHomeTown];
            return;
        }else{
            if(operation.HTTPRequestOperation.responseData){
                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:NSJSONReadingAllowFragments error:&error];
                if(dictResponse){
                    if ([[dictResponse valueForKey:@"code"] intValue] == kINVALID_SESSION){
                        [RSActivityIndicator showIndicatorWithTitle:@"Please Wait"];
                        [[AppDelegate appDelegate] loginWithExistingCredential];
                        sleep(5);
                        [RSActivityIndicator hideIndicator];
                        [self getNewsForHomeTown];
                        return;
                        
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                        [lblNoNewsFound setHidden:NO];
                        [newsTableView setHidden:YES];
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_Operation_Complete){
                        [lblNoNewsFound setHidden:YES];
                        [newsTableView setHidden:NO];
                    }
                }else{
                    [lblNoNewsFound setHidden:NO];
                    [newsTableView setHidden:YES];
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:error.localizedDescription delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

-(void)getPlaceForAddress:(NSString *)searchString {
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *str = [NSString stringWithFormat:kResource_Place,searchString,kPlace_API_Key];
    [[AppDelegate appDelegate].rkomForPlaces getObject:nil path:str parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataFromGoogle *dataFromGoogle = [mappingResult firstObject];
        NSLog(@"%@",dataFromGoogle.results);
        resultArray = [NSMutableArray arrayWithArray:[dataFromGoogle.results allObjects]];
        if (resultArray.count >= 7) {
            [self.tableViewForCityResult setFrame:CGRectMake(self.tableViewForCityResult.frame.origin.x, self.tableViewForCityResult.frame.origin.y, self.tableViewForCityResult.frame.size.width,240)];
            [self.tableViewForCityResult setHidden:NO];
        } else {
            [self.tableViewForCityResult setFrame:CGRectMake(self.tableViewForCityResult.frame.origin.x, self.tableViewForCityResult.frame.origin.y, self.tableViewForCityResult.frame.size.width, resultArray.count*40)];
            [self.tableViewForCityResult setHidden:NO];
        }
        [self.tableViewForCityResult reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        if(error.code == -(kRequest_Server_Not_Rechable)){
            [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
        }else if(error.code == -(kRequest_TimeOut)){
            [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Request_TimeOut delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
        }else if(operation.HTTPRequestOperation.response.statusCode == kRequest_Forbidden_Unauthorized){
            [RSActivityIndicator showIndicatorWithTitle:@"Please Wait"];
            [[AppDelegate appDelegate] loginWithExistingCredential];
            sleep(5);
            [RSActivityIndicator hideIndicator];
            [self getPlaceForAddress:strSearchAddress];
            return;
        }else{
            if(operation.HTTPRequestOperation.responseData){
                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:NSJSONReadingAllowFragments error:&error];
                if(dictResponse){
                    if ([[dictResponse valueForKey:@"code"] intValue] == kINVALID_SESSION){
                        [RSActivityIndicator showIndicatorWithTitle:@"Please Wait"];
                        [[AppDelegate appDelegate] loginWithExistingCredential];
                        sleep(5);
                        [RSActivityIndicator hideIndicator];
                        [self getPlaceForAddress:strSearchAddress];
                        return;
                        
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                        //lblForMyPostNotFound.text = kLbl_Error_Message_MyPost;
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_Operation_Complete){
                        //lblForMyPostNotFound.text = [dictResponse valueForKey:@"msg"];
                    }
                }else{
                    //lblForMyPostNotFound.text = kAlert_Server_Not_Rechable;
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:error.localizedDescription delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
        
    }];
}



@end
