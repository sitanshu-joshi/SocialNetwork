//
//  QuestionAnswerViewController.m
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import "QuestionAnswerViewController.h"
#import <RestKit/RestKit.h>

@interface QuestionAnswerViewController ()

@end

@implementation QuestionAnswerViewController
@synthesize tableViewForResult,tagListView,scrollViewMain;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUserInterface];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    cityArray = [NSMutableArray array];
    [tableViewForResult setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [RSActivityIndicator hideIndicator];
    [self performSelector:@selector(hidekeyBoard) withObject:nil afterDelay:0.3];
    tableViewForResult = nil;
    [tagListView.tags removeAllObjects];
    tagListView = nil;
    scrollViewMain = nil;
    cityArray = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUpUserInterface{

    self.txtViewForQuestion1.layer.cornerRadius = 7.0;
    self.txtViewForQuestion1.layer.masksToBounds = YES;
    
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSkip.layer.cornerRadius = 5.0;
}

#pragma mark - IBAction Methods

- (IBAction)btnSkipTapped:(id)sender {
    [self performSegueWithIdentifier:kPush_To_SlideBar1 sender:nil];
    [self hidekeyBoard];
    [self scrollableOff];
}

- (IBAction)btnSubmitTapped:(id)sender {

}

#pragma mark - Table View delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultArray count]; /* return size of result array */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    Result *result = [resultArray objectAtIndex:indexPath.row];
    UILabel *lblAddress =(UILabel *)[cell.contentView viewWithTag:999];
    lblAddress.text = result.formatted_address;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Result *result = [resultArray objectAtIndex:indexPath.row];
    if(!cityArray){
        cityArray = [NSMutableArray array];
    }
    [cityArray addObject:result.formatted_address];
    [self updateSelectedCityToServerWithAddress:result.formatted_address];
    [self addCityTagWithAddress:result.formatted_address];
}
-(void)updateSelectedCityToServerWithAddress:(NSString *)address{
    
    if(![address isEqualToString:@""]){
        [RSActivityIndicator showIndicatorWithTitle:@"Please wait"];
        NSArray *arrOfAddress = [address componentsSeparatedByString:@","];
        NSString *strCity, *strCountry, *strState;
        strCountry = [NSString stringWithFormat:@"%@",[arrOfAddress lastObject]];
        strState = [NSString stringWithFormat:@"%@",[arrOfAddress objectAtIndex:[arrOfAddress count]-2]];
        if (arrOfAddress.count >= 3) {
            strCity = [NSString stringWithFormat:@"%@",[arrOfAddress objectAtIndex:[arrOfAddress count]-3]];
        }else{
            strCity = @"";
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
        [[[UIAlertView alloc]initWithTitle:kAppTitle message:@"Please Select City" delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil]show];
    }
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
    self.searchBar.text = @"";
    [self hidekeyBoard];
}


#pragma mark - UITextField Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//To search place
-(void)getPlaceTest:(NSString *)searchString {
    NSString *str = [NSString stringWithFormat:kResource_Place,searchString,kPlace_API_Key];
    [[AppDelegate appDelegate].rkomForPlaces getObject:nil path:str parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataFromGoogle *dataFromGoogle = [mappingResult firstObject];
        NSLog(@"%@",dataFromGoogle.results);
        resultArray = [NSMutableArray arrayWithArray:[dataFromGoogle.results allObjects]];
        [self.tableViewForResult reloadData];
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

//To add City Tags
-(void)addCityTagWithAddress:(NSString *)strAddress {
    if (strAddress.length > 0) {
        NSArray *arrayOfCurrentAddress =[NSArray arrayWithObject:strAddress];
        [tagListView addTags:arrayOfCurrentAddress withClose:YES color:tagColorForCity];
        [self.searchBar resignFirstResponder];
        [self hidekeyBoard];
    }
}


//To hide Keyboard
-(void)hidekeyBoard {
    [self.searchBar resignFirstResponder];
    [tableViewForResult setHidden:YES];
    [self scrollableOff];
}

#pragma mark Autoresizing
-(void)scrollableOn {
    if (self.view.frame.size.height == 568) {
        scrollViewMain.contentSize = (CGSize){1.0, self.view.frame.size.height-216-64};
        scrollViewMain.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-216-64);
    } else {
        scrollViewMain.contentSize = (CGSize){1.0, self.view.frame.size.height-216-64};
        scrollViewMain.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-216-64);
    }
}
-(void)scrollableOff {
    @autoreleasepool {
        scrollViewMain.contentSize = (CGSize){1.0, self.view.frame.size.height-64};
        scrollViewMain.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
        [tableViewForResult setHidden:YES];
        [self.searchBar resignFirstResponder];
    }
}
@end
