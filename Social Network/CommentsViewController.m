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
@synthesize lblLikeCount,lblUserName;
@synthesize imgPostContent;

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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUserInterface{
    self.containerView.layer.borderColor = (__bridge CGColorRef)([UIColor colorWithRed:55.0/255.0 green:81.0/255.0 blue:255.0/255.0 alpha:1.0]);
    self.containerView.layer.borderWidth = 2.0;
    
    // Set Post content data to the UI
    txtViewForPostDetail.text = post.text;
    lblLikeCount.text = [NSString stringWithFormat:@"%@",post.likeCount];
    lblCommentCount.text = [NSString stringWithFormat:@"%@",post.commentCount];
    lblUserName.text = post.username;
    if (post.isMyLike == [NSNumber numberWithBool:true] || post.isMyLike == [NSNumber numberWithInt:1]) {
        [btnLike setSelected:YES];
    } else {
        [btnLike setSelected:NO];
    }
    NSString *strFileName = [[post.mediaUrl componentsSeparatedByString:@"/"] lastObject];
    if([[FileUtility utility] checkFileIsExistOnDocumentDirectoryFolder:[[[FileUtility utility] documentDirectoryPath] stringByAppendingString:kDD_Images] withFileName:strFileName]){
        imgPostContent.image = [UIImage imageWithContentsOfFile:[[[FileUtility utility] documentDirectoryPath] stringByAppendingString:[NSString stringWithFormat:@"%@/%@",kDD_Images,strFileName]]];
    }
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
    
    Comment *comment = [arrayOfComments objectAtIndex:indexPath.row];
    UITextView *txtView = (UITextView *)[cell viewWithTag:kCell_comment_text];
    txtView.text = comment.text;
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:kCell_Comment_name];
    lbl.text = comment.username;
    UIButton *btn = (UIButton *)[cell viewWithTag:kCell_comment_delete];
    if([NSNumber numberWithBool:comment.isMyComment]) {
        btn.tag = indexPath.row;
    } else {
        [btn setHidden:YES];
    }
    
    return cell;
}

#pragma mark IBAction Event
-(IBAction)btnDeleteActionEvent:(id)sender {
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    Comment *comment = [arrayOfComments objectAtIndex:[sender tag]];
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
        [arrayOfComments removeObject:comment];
        int commentcount = [lblCommentCount.text intValue] - 1;
        lblCommentCount.text = [NSString stringWithFormat:@"%d",commentcount];
        [tblViewForComments reloadData];
    }];
    

}
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnPostTapped:(id)sender {
    [txtViewForComment resignFirstResponder];
    NSString *strCommentText = self.txtViewForComment.text;
    txtViewForComment.text = @"";
    if(strCommentText){
        NSDictionary *dict = [NSDictionary dictionaryWithObject:strCommentText forKey:kCOMMENT_TEXT];
        [self addComment:dict ForPost:post.ids];
    }else{
        [[[UIAlertView alloc]initWithTitle:kAppTitle message:@"Please add comment for given post" delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil]show];
    }
}
-(IBAction)btnLikeDislikeAction:(id)sender {
    if (btnLike.selected) {
        // Do it for dislike
        [self unLikePostwithPostId:post.ids];
    } else {
        // Do it for dislike
        [self likePostwithPostId:post.ids];
    }
}

#pragma mark - To get Comment
-(void)getCommentsDetailsForPostId:(NSString *)postId {
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kGetCommentsByPostId,postId];
    [[AppDelegate appDelegate].rkomForComment getObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *data  = [mappingResult.array objectAtIndex:0];
        arrayOfComments = [[NSMutableArray alloc] initWithArray:[data.comment allObjects]];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updatedDate" ascending:NO];
        NSArray *sortedArray = [arrayOfComments sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        arrayOfComments = [[NSMutableArray alloc] initWithArray:sortedArray];
        
        [tblViewForComments reloadData];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
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
    [[AppDelegate appDelegate].rkObjectManager postObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        int likecount = [lblLikeCount.text intValue] + 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        int likecount = [lblLikeCount.text intValue] + 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:YES];
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
    [[AppDelegate appDelegate].rkObjectManager postObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        int likecount = [lblLikeCount.text intValue] - 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:NO];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        int likecount = [lblLikeCount.text intValue] - 1;
        lblLikeCount.text = [NSString stringWithFormat:@"%d",likecount];
        [btnLike setSelected:NO];
    }];
}

#pragma mark - To Add Comment
-(void)addComment:(NSDictionary *)dict ForPost:(NSString *)postId {
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kAddComment,postId];
    DataForResponse *data;
    [[AppDelegate appDelegate].rkomForComment postObject:data path:strPath parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.comment);
        int commentcount = [lblCommentCount.text intValue] + 1;
        lblCommentCount.text = [NSString stringWithFormat:@"%d",commentcount];
        [self getCommentsDetailsForPostId:post.ids];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        int commentcount = [lblCommentCount.text intValue] + 1;
        lblCommentCount.text = [NSString stringWithFormat:@"%d",commentcount];
        [self getCommentsDetailsForPostId:post.ids];
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

#pragma mark - To Delete Comment
-(void)deleteCommentForPost:(NSString *)postId withCommentId:(NSString *)commentId {
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kResource_DeleteComment, postId, commentId];
    [[AppDelegate appDelegate].rkomForComment deleteObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.comment);
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


#pragma mark - To Update Comment
-(void)updateComment:(NSDictionary *)dict ForPost:(NSString *)postId withCommentId:(NSString *)commentId {
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kUpdateComment,postId,commentId];
    DataForResponse *data;
    [[AppDelegate appDelegate].rkomForComment putObject:data path:strPath parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.comment);
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
