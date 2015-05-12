//
//  CommentsViewController.m
//  Social Network
//
//  Created by Sitanshu Joshi on 2/4/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController
@synthesize tblViewForComments;
@synthesize post;
@synthesize btnLike,btnPost,lblCommentCount,txtViewForComment,txtViewForPostDetail;
@synthesize lblLikeCount,lblUserName,lblNoComments;
@synthesize imgPostContent,isNeedToRefreshPage;
@synthesize btnPlay;

#pragma mark - LifeCycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpUserInterface];
    if(self.post){
        [self getCommentsDetailsForPostId:post.ids];
    }
    isNeedToRefreshPage = false;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView DataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayOfComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell_Comment];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCell_Comment];
    }
    
    comment = [arrayOfComments objectAtIndex:indexPath.row];
    UITextView *txtView = (UITextView *)[cell viewWithTag:kCell_comment_text];
    txtView.text = comment.text;
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:kCell_Comment_name];
    lbl.text = comment.username;
    UIButton *btnDelete = (UIButton *)[cell viewWithTag:kCell_comment_delete];
    UIButton *btnEdit = (UIButton *)[cell viewWithTag:kCell_comment_edit];
    if([NSNumber numberWithBool:comment.isMyComment]) {
        btnDelete.tag = indexPath.row;
        [btnEdit setHidden:false];
        txtView.editable = false;
    } else {
        [btnDelete setHidden:YES];
        [btnEdit setHidden:NO];
        txtView.editable = false;
    }
    return cell;
}

#pragma mark IBAction Event

-(IBAction)btnPlayVideo:(id)sender {
    player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:test_mp4]];
    player.fullscreen = YES;
    [player setMovieSourceType:MPMovieSourceTypeStreaming];
    //    [self.view addSubview:player.view];
    
    [player play];
}

-(IBAction)btnDeleteActionEvent:(id)sender {
    comment = [arrayOfComments objectAtIndex:[sender tag]];
    [self deleteCommentForPost:post.ids withCommentId:comment.ids];
    /*
    [[AppDelegate appDelegate].rkomForComment deleteObject:comment path:[NSString stringWithFormat:kResource_DeleteComment,post.ids,comment.ids] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        [arrayOfComments removeObject:comment];
        int commentcount = [lblCommentCount.text intValue] - 1;
        lblCommentCount.text = [NSString stringWithFormat:@"%d",commentcount];
        [tblViewForComments reloadData];

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
            //[self getNewsForHomeTown];
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
                        //[self getNewsForHomeTown];
                        return;
                        
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                        //lblForMyPostNotFound.text = kLbl_Error_Message_MyPost;
                    }else{
                        //lblForMyPostNotFound.text = [dictResponse valueForKey:@"msg"];
                    }
                }else{
                    //lblForMyPostNotFound.text = kAlert_Server_Not_Rechable;
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
        [arrayOfComments removeObject:comment];
        int commentcount = [lblCommentCount.text intValue] - 1;
        lblCommentCount.text = [NSString stringWithFormat:@"%d",commentcount];
        [tblViewForComments reloadData];
    }];
    */
}
- (IBAction)btnEditTapped:(UIButton *)sender{
     NSIndexPath* indexPath = [self.tblViewForComments indexPathForRowAtPoint:[self.tblViewForComments convertPoint:sender.center fromView:sender.superview]];
    comment = [arrayOfComments objectAtIndex:indexPath.row];
    strCommentId = comment.ids;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewForEditComment.frame = CGRectMake(0,140, self.viewForEditComment.frame.size.width, self.viewForEditComment.frame.size.height);
        self.txtViewToUpdateComment.text = comment.text;
        [self.txtViewToUpdateComment becomeFirstResponder];
    }];
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnPostTapped:(id)sender {
    [txtViewForComment resignFirstResponder];
    strCommentText = self.txtViewForComment.text;
    txtViewForComment.text = @"";
    if(strCommentText){
       dictForPostComment = [NSDictionary dictionaryWithObject:strCommentText forKey:kCOMMENT_TEXT];
        [self addComment:dictForPostComment ForPost:post.ids];
    }else{
        [[[UIAlertView alloc]initWithTitle:kAppTitle message:@"Please add comment for given post" delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil]show];
    }
}
-(IBAction)btnLikeDislikeAction:(id)sender {
    if (btnLike.selected) {
        // Do it for dislike
        [self unLikePostwithPostId:post.ids];
    } else {
        // Do it for like
        [self likePostwithPostId:post.ids];
    }
}

- (IBAction)updateCommentBtnTapped:(id)sender {
    //Call update comment method
    dictForUpdateCommnent =[NSMutableDictionary dictionary];
    [dictForUpdateCommnent setObject:self.txtViewToUpdateComment.text forKey:kCOMMENT_TEXT];
    [self updateComment:dictForUpdateCommnent ForPost:self.post.ids withCommentId:strCommentId];
}

#pragma mark - UITextView Delegate Methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(textView == txtViewForPostDetail){
        return false;
    }
    return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.viewForEditComment.frame = CGRectMake(0, 700, self.viewForEditComment.frame.size.width, self.viewForEditComment.frame.size.height);
    }];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            self.viewForEditComment.frame = CGRectMake(0, 700, self.viewForEditComment.frame.size.width, self.viewForEditComment.frame.size.height);
        }];
        return false;
    }
    return true;
}

#pragma mark - RestKit Request/Response Delegate Methods

-(void)getCommentsDetailsForPostId:(NSString *)postId {
    [RSActivityIndicator showIndicator];
    NSString *strPath = [NSString stringWithFormat:kGetCommentsByPostId,postId];
    [[AppDelegate appDelegate].rkomForComment getObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *data  = [mappingResult.array objectAtIndex:0];
        arrayOfComments = [[NSMutableArray alloc] initWithArray:[data.comment allObjects]];
        if(arrayOfComments.count > 0){
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedDate" ascending:NO];
            NSArray *sortedArray = [arrayOfComments sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            arrayOfComments = [[NSMutableArray alloc] initWithArray:sortedArray];
            [tblViewForComments reloadData];
            [tblViewForComments setHidden:NO];
            [lblNoComments setHidden:YES];
        }else{
            [tblViewForComments setHidden:YES];
            [lblNoComments setHidden:NO];
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
            [self getCommentsDetailsForPostId:post.ids];
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
                        [self getCommentsDetailsForPostId:post.ids];
                        return;
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                        [tblViewForComments setHidden:YES];
                        [lblNoComments setHidden:NO];
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_Operation_Complete){
                        [tblViewForComments setHidden:NO];
                        [lblNoComments setHidden:YES];
                    }
                }else{
                    [tblViewForComments setHidden:YES];
                    [lblNoComments setHidden:NO];
                    lblNoComments.text = kAlert_Server_Not_Rechable;
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [tblViewForComments setHidden:YES];
                [lblNoComments setHidden:NO];
                lblNoComments.text = kAlert_Server_Not_Rechable;
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

/**
 *  It will add Comment for current post.
 */

-(void)addComment:(NSDictionary *)dict ForPost:(NSString *)postId {
    [RSActivityIndicator showIndicator];
    NSString *strPath = [NSString stringWithFormat:kAddComment,postId];
    DataForResponse *data;
    [[AppDelegate appDelegate].rkomForComment postObject:data path:strPath parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.comment);
        int commentcount = [lblCommentCount.text intValue] + 1;
        lblCommentCount.text = [NSString stringWithFormat:@"%d",commentcount];
        isNeedToRefreshPage = true;
        [self getCommentsDetailsForPostId:post.ids];
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
            [self addComment:dictForPostComment ForPost:post.ids];
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
                        [self addComment:dictForPostComment ForPost:post.ids];
                        return;
                        
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                        NSLog(@"Data Not Exist");
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_Operation_Complete){
                        dictForPostComment = nil;
                        isNeedToRefreshPage = true;
                        [[[UIAlertView alloc]initWithTitle:kAppTitle message:[dictResponse valueForKey:@"msg"] delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                        [self getCommentsDetailsForPostId:post.ids];
                    }
                }else{
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
        int commentcount = [lblCommentCount.text intValue] + 1;
        lblCommentCount.text = [NSString stringWithFormat:@"%d",commentcount];
        [self getCommentsDetailsForPostId:post.ids];
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

/**
 *  It will Delete Comment for current post.
 */

-(void)deleteCommentForPost:(NSString *)postId withCommentId:(NSString *)commentId {
    [RSActivityIndicator showIndicator];
    NSString *strPath = [NSString stringWithFormat:kResource_DeleteComment, postId, commentId];
    [[AppDelegate appDelegate].rkomForComment deleteObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.comment);
        isNeedToRefreshPage = true;
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
            [self deleteCommentForPost:post.ids withCommentId:comment.ids];
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
                        [self deleteCommentForPost:post.ids withCommentId:comment.ids];
                        return;
                        
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                        NSLog(@"Data Not Exist");
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_Operation_Complete){
                        [[[UIAlertView alloc]initWithTitle:kAppTitle message:[dictResponse valueForKey:@"msg"] delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                        [self getCommentsDetailsForPostId:post.ids];
                        isNeedToRefreshPage = true;
                    }
                }else{
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
        RKLogError(@"Operation failed with error: %@", error);
    }];
}


/**
 *  It will Update Comment for current post.
 */
-(void)updateComment:(NSDictionary *)dict ForPost:(NSString *)postId withCommentId:(NSString *)commentId {
    [RSActivityIndicator showIndicator];
    [self.txtViewToUpdateComment resignFirstResponder];
    NSString *strPath = [NSString stringWithFormat:kUpdateComment,postId,commentId];
    DataForResponse *data;
    [[AppDelegate appDelegate].rkomForComment putObject:data path:strPath parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
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
            [self updateComment:dictForUpdateCommnent ForPost:self.post.ids withCommentId:strCommentId];
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
                        [self updateComment:dictForUpdateCommnent ForPost:self.post.ids withCommentId:strCommentId];
                        return;
                        
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                         NSLog(@"Data Not Exist");
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_Operation_Complete){
                        [[[UIAlertView alloc]initWithTitle:kAppTitle message:[dictResponse valueForKey:@"msg"] delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                        [self getCommentsDetailsForPostId:post.ids];
                    }
                }else{
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
        RKLogError(@"Operation failed with error: %@", error);
    }];
}


/**
 *  This will set like post by logged in user
 *
 *  @param postId
 */
-(void)likePostwithPostId:(NSString *)postId{
    [RSActivityIndicator showIndicator];
    NSString *strPath = [NSString stringWithFormat:kResource_LikePost,postId];
    [[AppDelegate appDelegate].rkObjectManager postObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        int likecount = [lblLikeCount.text intValue] + 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:YES];
        isNeedToRefreshPage = true;
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
            [self likePostwithPostId:post.ids];
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
                        [self likePostwithPostId:post.ids];
                        return;
                        
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                        NSLog(@"Data Not Exist");
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_Operation_Complete){
                        [[[UIAlertView alloc]initWithTitle:kAppTitle message:[dictResponse valueForKey:@"msg"] delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                        [self getCommentsDetailsForPostId:post.ids];
                        isNeedToRefreshPage = true;
                    }
                }else{
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
        int likecount = [lblLikeCount.text intValue] + 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:YES];
    }];
}

/**
 *  It will set post unliked by current logged in user.
 *
 *  @param dict
 *  @param postId
 */
-(void)unLikePostwithPostId:(NSString *)postId{
    [RSActivityIndicator showIndicator];
    NSString *strPath = [NSString stringWithFormat:kResource_UnLikePost,postId];
    [[AppDelegate appDelegate].rkObjectManager postObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        int likecount = [lblLikeCount.text intValue] - 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:NO];
        isNeedToRefreshPage = true;
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
            [self unLikePostwithPostId:post.ids];
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
                        [self unLikePostwithPostId:post.ids];
                        return;
                        
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                        NSLog(@"Data Not Exist");
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_Operation_Complete){
                        [[[UIAlertView alloc]initWithTitle:kAppTitle message:[dictResponse valueForKey:@"msg"] delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                        [self getCommentsDetailsForPostId:post.ids];
                        isNeedToRefreshPage = true;
                    }
                }else{
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
        int likecount = [lblLikeCount.text intValue] - 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:NO];
    }];
}


#pragma mark - Helper Methods

-(void)setUpUserInterface{
    self.containerView.layer.borderColor = (__bridge CGColorRef)([UIColor colorWithRed:55.0/255.0 green:81.0/255.0 blue:255.0/255.0 alpha:1.0]);
    self.containerView.layer.borderWidth = 2.0;
    
    // Set Post content data to the UI
    [btnPlay setHidden:YES];
    txtViewForPostDetail.text = post.text;
    lblLikeCount.text = [NSString stringWithFormat:@"%@",post.likeCount];
    lblCommentCount.text = [NSString stringWithFormat:@"%@",post.commentCount];
    lblUserName.text = post.username;
    BOOL ismyLike = [post.isMyLike boolValue];
    if (ismyLike == true) {
        [btnLike setSelected:YES];
    } else {
        [btnLike setSelected:NO];
    }
    if([post.mediaType intValue] == 1){
        imgPostContent.image = [UIImage imageNamed:@"img_placeholder .jpg"];
        if (post.mediaUrl != nil) {
            BOOL isImage = [[UtilityMethods utilityMethods] isUrlForImage:post.mediaUrl];
            if (isImage == true) {
                NSString *strFileName = [[post.mediaUrl componentsSeparatedByString:@"/"] lastObject];
                if([[FileUtility utility] checkFileIsExistOnDocumentDirectoryFolder:[[[FileUtility utility] documentDirectoryPath] stringByAppendingString:kDD_Images] withFileName:strFileName]){
                    imgPostContent.image = [UIImage imageWithContentsOfFile:[[[FileUtility utility] documentDirectoryPath] stringByAppendingString:[NSString stringWithFormat:@"%@/%@",kDD_Images,strFileName]]];
                }
            } else {
                [self generateImage:post.mediaUrl];
            }
        }
    }else if ([post.mediaType intValue] == 2){
        imgPostContent.image = [UIImage imageNamed:@"video-placeholder.png"];
    }
}


/**
 *  This will generate thumbnail of live URL. 
 *
 */
-(void)generateImage:(NSString *)strUrl {
    
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:[NSURL URLWithString:strUrl] options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        } else {
            [btnPost setHidden:NO];
        }
        
        imgPostContent.image = [UIImage imageWithCGImage:im];
    };
    
    CGSize maxSize = CGSizeMake(320, 180);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
}



@end
