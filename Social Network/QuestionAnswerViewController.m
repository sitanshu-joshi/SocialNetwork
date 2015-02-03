//
//  QuestionAnswerViewController.m
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import "QuestionAnswerViewController.h"

@interface QuestionAnswerViewController ()

@end

@implementation QuestionAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contentInsets = self.scrollView.contentInset;
    [self setUpUserInterface];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUpUserInterface{

    self.txtViewForQuestion1.layer.cornerRadius = 7.0;
    self.txtViewForQuestion1.layer.masksToBounds = YES;
    
    self.tblViewForResult.layer.cornerRadius = 7.0;
    self.tblViewForResult.layer.masksToBounds  =YES;
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSkip.layer.cornerRadius = 5.0;
}

#pragma mark - IBAction Methods

- (IBAction)btnSkipTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPush_To_SlideBar1 object:nil];
}

- (IBAction)btnSubmitTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPush_To_SlideBar1 object:nil];
}
#pragma mark - Table View delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultArray count]; /* return size of result array */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    
    Result *result = [resultArray objectAtIndex:indexPath.row];
    cell.textLabel.text = result.formatted_address;
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[resultArray objectAtIndex:indexPath.row] valueForKey:@"formatted_address"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /* set dynamic height for cell */
//    FAQModel *modelObject = [tableDataArray objectAtIndex:indexPath.row];
//    
//    CGSize constraint = CGSizeMake(FAQ_CELL_LABEL_WIDTH, FAQ_CELL_MAX_ROW_HEIGHT);
//    
//    CGSize size = [modelObject.faqTitle sizeWithFont:FAQ_QUESTION_TITLE_FONT constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//    
//    CGFloat height = MAX(size.height+FAQ_CELL_ROW_TOP_BOTTOM_PADDING, FAQ_CELL_SINGLE_LINE_ROW_HEIGHT);
//    
//    if(height > FAQ_CELL_MAX_ROW_HEIGHT) return FAQ_CELL_MAX_ROW_HEIGHT;
    
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Result *result = [resultArray objectAtIndex:indexPath.row];
    self.searchBar.text = result.formatted_address;
}


#pragma mark - UISearchBar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"============== %@",searchText);
    [self getPlaceTest:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar {
    [searchbar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchbar {
    [searchbar resignFirstResponder];
    [self getPlaceTest:searchbar.text];
    [self.tblViewForResult reloadData];
}


#pragma mark - UITextField Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    self.scrollView.contentOffset = CGPointMake(0, textView.frame.origin.y - textView.frame.size.height/2);
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointZero;

}

//To search place
-(void)getPlaceTest:(NSString *)searchString {
    NSString *str = [NSString stringWithFormat:kResource_Place,searchString,kPlace_API_Key];
    [[AppDelegate appDelegate].rkomForPlaces getObject:nil path:str parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataFromGoogle *dataFromGoogle = [mappingResult firstObject];
        NSLog(@"%@",dataFromGoogle.results);
        resultArray = [NSMutableArray arrayWithArray:[dataFromGoogle.results allObjects]];
        [self.tblViewForResult reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSLog(@"%@",error.localizedDescription);
    }];
}
@end
