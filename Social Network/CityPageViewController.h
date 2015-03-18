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
    UIButton *btnLike;
    UILabel *lblLikeCount;
    NSString *myPostId;
}
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


- (IBAction)uploadPhotoButtonTapped:(id)sender;
- (IBAction)uploadVideoButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)likeButtonTapped:(id)sender;
- (IBAction)deleteButtonTapped:(id)sender;
- (IBAction)updatePostBtnTapped:(id)sender;
- (IBAction)btnUpdatePostTapped:(id)sender;


/*
 #pragma mark - UITableView DataSorce Methods
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 return [arrayOfNewsResponse count];
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 newsData = [arrayOfNewsResponse objectAtIndex:section];
 return [[newsData articles]count];
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:kCell_Identifier_NewsList];
 if(aCell == nil){
 aCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCell_Identifier_NewsList];
 }
 aCell.backgroundColor = [UIColor whiteColor];
 newsData = [arrayOfNewsResponse objectAtIndex:indexPath.section];
 UILabel *labeDescription =(UILabel *)[aCell.contentView viewWithTag:9999];
 NSString *strNewsDescription = [[[newsData articles]objectAtIndex:indexPath.row]valueForKey:@"description"];
 [labeDescription setFont:Font_Roboto_Condensed_16];
 NSDictionary *attributesDictionaryForDescription = [NSDictionary dictionaryWithObjectsAndKeys:  Font_Roboto_Condensed_16, NSFontAttributeName,
 Color_OF_Link_URL, NSForegroundColorAttributeName,nil];
 CGRect rectForDescription = [strNewsDescription boundingRectWithSize:CGSizeMake(280.f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributesDictionaryForDescription context:nil];
 if (rectForDescription.size.height < 100) {
 if(rectForDescription.size.height < 25){
 labeDescription.frame = CGRectMake(labeDescription.frame.origin.x, labeDescription.frame.origin.y, labeDescription.frame.size.width, 25);
 }else{
 labeDescription.frame = CGRectMake(labeDescription.frame.origin.x, labeDescription.frame.origin.y, labeDescription.frame.size.width, rectForDescription.size.height);
 }
 }else{
 labeDescription.frame = CGRectMake(labeDescription.frame.origin.x, labeDescription.frame.origin.y, labeDescription.frame.size.width, 100);
 }
 
 labeDescription.text = strNewsDescription;
 labeDescription.textColor = [UIColor blackColor];
 labeDescription.lineBreakMode = NSLineBreakByTruncatingTail;
 labeDescription.numberOfLines = 4;
 UIButton *btnMore = (UIButton *)[aCell.contentView viewWithTag:99];
 btnMore.layer.cornerRadius = 2.5;
 btnMore.titleLabel.textColor = Color_OF_Header;
 btnMore.backgroundColor = [UIColor clearColor];
 if([[[[newsData articles]objectAtIndex:indexPath.row]valueForKey:@"url"] isEqualToString:@""]){
 [btnMore setHidden:YES];
 } else {
 [btnMore setHidden:NO];
 }
 //To change Title according to Section.
 NSArray *arrary = [tblOfList indexPathsForVisibleRows];
 if(indexPath.section > 0){
 NSIndexPath *index =  [arrary objectAtIndex:0];
 if([arrOfTitle objectAtIndex:index.section] != nil){
 lblTitle.text = [arrOfTitle objectAtIndex:index.section];
 }
 }
 return aCell;
 }
 
 //This will create Header of Sections.
 -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 UIView *headerView = [[UIView alloc]init];
 headerView.backgroundColor = Color_OF_Header;
 aStrToReturn = [[arrayOfHeader objectAtIndex:section]uppercaseString];
 NSDictionary *attributesDictionaryForHeading = [NSDictionary dictionaryWithObjectsAndKeys:  Font_Roboto_Bold_16, NSFontAttributeName,
 Color_OF_Link_URL, NSForegroundColorAttributeName,nil];
 CGRect rectForHeading = [aStrToReturn boundingRectWithSize:CGSizeMake(280.f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributesDictionaryForHeading context:nil];
 
 if(rectForHeading.size.height < 30){
 headerView.frame = CGRectMake(15,5, 300, 30);
 }else{
 headerView.frame = CGRectMake(15,5, 300, rectForHeading.size.height);
 }
 UILabel *lblOfHeader;
 lblOfHeader = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, headerView.frame.size.width - 8, headerView.frame.size.height)];
 lblOfHeader.backgroundColor = [UIColor clearColor] ;
 // [label setFont:Font_Roboto_Bold_18];
 lblOfHeader.textAlignment = NSTextAlignmentLeft;
 lblOfHeader.numberOfLines = 0;
 lblOfHeader.lineBreakMode = NSLineBreakByWordWrapping;
 [lblOfHeader setText:aStrToReturn];
 CGRect bounds = headerView.bounds;
 UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
 byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
 cornerRadii:CGSizeMake(5.0, 5.0)];
 CAShapeLayer *maskLayer = [CAShapeLayer layer];
 maskLayer.frame = bounds;
 maskLayer.path = maskPath.CGPath;
 headerView.layer.mask = maskLayer;
 lblOfHeader.textColor = [UIColor whiteColor];
 [lblOfHeader setNeedsDisplay];
 [headerView addSubview:lblOfHeader];
 return headerView;
 }
 
 //To set height of Row
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 newsData = [arrayOfNewsResponse objectAtIndex:indexPath.section];
 NSString *strNewsDescription = [[[newsData articles]objectAtIndex:indexPath.row]valueForKey:@"description"];
 NSDictionary *attributesDictionaryForDescription = [NSDictionary dictionaryWithObjectsAndKeys:  Font_Roboto_Condensed_16, NSFontAttributeName,
 Color_OF_Link_URL, NSForegroundColorAttributeName,nil];
 
 CGRect rectForDescription = [strNewsDescription boundingRectWithSize:CGSizeMake(280.f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributesDictionaryForDescription context:nil];
 if(rectForDescription.size.height < 100){
 if(rectForDescription.size.height < 30){
 return 30;
 }else{
 return rectForDescription.size.height+5;
 }
 }else{
 return 105;
 }
 
 }
 
 //To set height of header.
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 aStrToReturn = [[arrayOfHeader objectAtIndex:section]uppercaseString];
 NSDictionary *attributesDictionaryForHeading = [NSDictionary dictionaryWithObjectsAndKeys:  Font_Roboto_Bold_16, NSFontAttributeName,
 Color_OF_Link_URL, NSForegroundColorAttributeName,nil];
 CGRect rectForHeading = [aStrToReturn boundingRectWithSize:CGSizeMake(280.f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributesDictionaryForHeading context:nil];
 if(rectForHeading.size.height <30){
 return 30;
 }else{
 return rectForHeading.size.height;
 }
 }
 */

@end
