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
    
    self.txtViewForAnswer.layer.cornerRadius = 7.0;
    self.txtViewForAnswer.layer.masksToBounds = YES;
    
    self.tblViewForResult.layer.cornerRadius = 7.0;
    self.tblViewForResult.layer.masksToBounds  =YES;
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSkip.layer.cornerRadius = 5.0;
}

#pragma mark - IBAction Methods

- (IBAction)btnSkipTapped:(id)sender {
    [self performSegueWithIdentifier:kPush_To_SlideBar1 sender:nil];
}

- (IBAction)btnSubmitTapped:(id)sender {
    NSString *strResult;
    if(![self.txtViewForAnswer.text isEqualToString:@""]){
        strResult = [NSString stringWithFormat:@"%@",self.txtViewForAnswer.text];
        NSArray *arrOfAddress = [strResult componentsSeparatedByString:@","];
        NSString *strCity, *strCountry, *strState;
        strCountry = [NSString stringWithFormat:@"%@",[arrOfAddress lastObject]];
        strState = [NSString stringWithFormat:@"%@",[arrOfAddress objectAtIndex:[arrOfAddress count]-2]];
        if (arrOfAddress.count >= 3) {
            strCity = [NSString stringWithFormat:@"%@",[arrOfAddress objectAtIndex:[arrOfAddress count]-3]];
        }else{
            strCountry = @"";
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:strCity forKey:kCITY_NAME];
        [dict setValue:strState forKey:kSTATE];
        [dict setValue:strCountry forKey:kCOUNTRY];
        [dict setValue:@"Description" forKey:kDESCRIPTION];
        [dict setObject:@"true" forKey:kIS_VISITED];
        [dict setObject:@"false" forKey:kWANTS_TO_VISIT];
        [self submitAnswer:dict];
    }else{
        [[[UIAlertView alloc]initWithTitle:kAppTitle message:@"Please enter answer" delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil]show];
    }
    
}

#pragma mark - Table View delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultArray count]; /* return size of result array */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    
    Result *result = [resultArray objectAtIndex:indexPath.row];
    cell.textLabel.text = result.formatted_address;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
     return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Result *result = [resultArray objectAtIndex:indexPath.row];
    self.txtViewForAnswer.text = result.formatted_address;
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


-(void)submitAnswer:(NSMutableDictionary *)dict {
    [RSActivityIndicator showIndicatorWithTitle:@"Please wait"];
    [[AppDelegate appDelegate].rkomForLogin postObject:nil path:kAddCity parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        [self performSegueWithIdentifier:kPush_To_SlideBar1 sender:nil];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
        //NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSLog(@"%@",error.localizedDescription);
        [RSActivityIndicator hideIndicator];
        NSString *errorMessage = [NSString stringWithFormat:@"%@",error.localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:errorMessage delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
        [alert show];
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

@end
