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
@synthesize tableViewForResult,mainMenuButton,tableViewForCityList,lblQuestion,lblNoDataExist;
@synthesize segmentForCityType;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
    [mainMenuButton addTarget:self action: @selector(mainMenuBtnClickd) forControlEvents:UIControlEventTouchUpInside];
    self.revealViewController.delegate = self;
    [self setTableViewHeightZero];
    pageCount = 1;
    cityArray = [NSMutableArray array];
    lblQuestion.text = Question1;
    [tableViewForCityList setHidden:YES];
    //[self sendRequestToGetCityListFromDatabase];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.btnNext.layer.cornerRadius = 5.0;
    tableViewForResult.layer.cornerRadius = 7.0;
    tableViewForResult.layer.masksToBounds = YES;
    [self getMyListOfCities];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [RSActivityIndicator hideIndicator];
    [self performSelector:@selector(hidekeyBoard) withObject:nil afterDelay:0.3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction Methods

-(void)mainMenuBtnClickd {
    [self.revealViewController revealToggle:self.mainMenuButton];
}

- (IBAction)btnSkipTapped:(id)sender {
    [self pushToNewsContoller];
}

- (IBAction)valueForSegmentChange:(id)sender {
    if (segmentForCityType.selectedSegmentIndex == 0) {
        lblQuestion.text =Question1;
    } else if (segmentForCityType.selectedSegmentIndex == 1) {
        lblQuestion.text =Question2;
    }
}

- (IBAction)btnDeleteCityAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [tableViewForCityList indexPathForCell:cell];
    
    if (indexPath.section == 0) {
        city = [arrayOfWantTovisit objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        city = [arrayOfVisited objectAtIndex:indexPath.row];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppTitle message:kConfirmAert delegate:self cancelButtonTitle:kNoButton otherButtonTitles:kYesButton, nil];
    alert.tag = 1;
    [alert show];
}


#pragma mark - UITableView DataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == tableViewForResult){
        return 1;
    }else{
        return 2;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == tableViewForResult){
        return [resultArray count]; /* return size of result array */
    }else{
        if (section == 0) {
           return arrayOfWantTovisit.count;
        } else {
           return arrayOfVisited.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(tableView == tableViewForResult){
        cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
        if(!cell){
            cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
        }
        Result *result = [resultArray objectAtIndex:indexPath.row];
        UILabel *lblAddress =(UILabel *)[cell.contentView viewWithTag:999];
        lblAddress.text = result.formatted_address;
        CGRect frame = [tableView frame];
        if(frame.size.height < 100){
            [tableView setFrame:CGRectMake(frame.origin.x,
                                           frame.origin.y,
                                           frame.size.width,
                                           frame.size.height + cell.frame.size.height)];
        }
        return cell;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
        if(!cell){
            cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
        }
        UILabel *lblName = (UILabel *)[cell viewWithTag:501];
        if(indexPath.section == 0){
            city = [arrayOfWantTovisit objectAtIndex:indexPath.row];
            lblName.text = city.desc;
        
        }else{
            city = [arrayOfVisited objectAtIndex:indexPath.row];
            lblName.text = city.desc;
        }
        return cell;
    }
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == tableViewForResult){
        [self setTableViewHeightZero];
        tableViewForCityList.userInteractionEnabled = YES;
        [tableViewForResult setHidden:YES];
        [self.searchBar resignFirstResponder];
        self.searchBar.text = nil;
        Result *result = [resultArray objectAtIndex:indexPath.row];
        [self updateSelectedCityToServerWithAddress:result.formatted_address];
    }else{
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     CGFloat heightOfHeader;
    if(tableView == tableViewForCityList){
            heightOfHeader = 20.0;
    }else{
         heightOfHeader = 0.0;
    }
    return heightOfHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewForHeader = [[UIView alloc] initWithFrame:CGRectZero];
    viewForHeader.backgroundColor = [UIColor blackColor];
    UILabel *lblHeader = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width, 20)];
    lblHeader.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    lblHeader.backgroundColor = [UIColor clearColor];
    lblHeader.textColor = [UIColor whiteColor];
    if(tableView == tableViewForCityList){
        if(section == 0){
            lblHeader.text = @"Want to Visit City";
            [viewForHeader addSubview:lblHeader];
        }else{
            lblHeader.text = @"Visited City";
            [viewForHeader addSubview:lblHeader];
        }
    }else{
        lblHeader = nil;
    }
    return viewForHeader;
}


#pragma mark - UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1){
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:kNoButton])
        {   [RSActivityIndicator hideIndicator];
            [tableViewForCityList reloadData];
        }
        else if([title isEqualToString:kYesButton])
        {
            if([[AppDelegate appDelegate]isNetworkReachableToInternet]){
                [self deleteCity:city];
            }else{
                [RSActivityIndicator hideIndicator];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_NoInternet delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}

#pragma mark - Helper Methods

//To hide Keyboard
-(void)hidekeyBoard {
    [self.searchBar resignFirstResponder];
    [self setTableViewHeightZero];
}

//To push To News Controller
-(void)pushToNewsContoller{
    [self performSegueWithIdentifier:kPush_To_SlideBar1 sender:nil];
    [self hidekeyBoard];
}


-(void)setTableViewHeightZero{
    tableViewForResult.frame = CGRectMake(tableViewForResult.frame.origin.x, tableViewForResult.frame.origin.y, tableViewForResult.frame.size.width, 0);
}


-(void)updateSelectedCityToServerWithAddress:(NSString *)address{
    if([[AppDelegate appDelegate]isNetworkReachableToInternet]){
        if(![address isEqualToString:@""]){
            [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
            NSArray *arrOfAddress = [address componentsSeparatedByString:@","];
            NSString *strCity, *strCountry, *strState;
            strCountry = [NSString stringWithFormat:@"%@",[arrOfAddress lastObject]];
            strState = [NSString stringWithFormat:@"%@",[arrOfAddress objectAtIndex:[arrOfAddress count]-2]];
            if (arrOfAddress.count >= 3) {
                strCity = [NSString stringWithFormat:@"%@",[arrOfAddress objectAtIndex:[arrOfAddress count]-3]];
            }else{
                strCity = @"";
            }
            dictForAnswer = [[NSMutableDictionary alloc] init];
            [dictForAnswer setValue:strCity forKey:kCITY_NAME];
            [dictForAnswer setValue:strState forKey:kSTATE];
            [dictForAnswer setValue:strCountry forKey:kCOUNTRY];
            [dictForAnswer setValue:address forKey:kDESCRIPTION];
            if (segmentForCityType.selectedSegmentIndex == 0) {
                [dictForAnswer setObject:@"true" forKey:kWANTS_TO_VISIT];
                [dictForAnswer setObject:@"false" forKey:kIS_VISITED];
            } else if (segmentForCityType.selectedSegmentIndex == 1) {
                [dictForAnswer setObject:@"false" forKey:kWANTS_TO_VISIT];
                [dictForAnswer setObject:@"true" forKey:kIS_VISITED];
            }
            [self submitAnswer:dictForAnswer];
        }else{
            [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Enter_City delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil]show];
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:kAppTitle message:kAlert_NoInternet delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil] show];
    }
    
}

#pragma mark - UISearchBar Delegate Methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.tableViewForCityList.userInteractionEnabled = NO;
    [self.view bringSubviewToFront:self.tableViewForResult];
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"============== %@",searchText);
    NSString *str = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self getPlaceForAddress:str];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar {
    [searchbar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchbar {
    [searchbar resignFirstResponder];
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

#pragma mark  - Google Place API Request
-(void)getPlaceForAddress:(NSString *)searchString {
    NSString *str = [NSString stringWithFormat:kResource_Place,searchString,kPlace_API_Key];
    [[AppDelegate appDelegate].rkomForPlaces getObject:nil path:str parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataFromGoogle *dataFromGoogle = [mappingResult firstObject];
        NSLog(@"%@",dataFromGoogle.results);
        resultArray = [NSMutableArray arrayWithArray:[dataFromGoogle.results allObjects]];
        if (resultArray.count >= 7) {
            [tableViewForResult setFrame:CGRectMake(tableViewForResult.frame.origin.x, tableViewForResult.frame.origin.y, tableViewForResult.frame.size.width, 240)];
            [tableViewForResult setHidden:NO];
        } else {
            [tableViewForResult setFrame:CGRectMake(tableViewForResult.frame.origin.x, tableViewForResult.frame.origin.y, tableViewForResult.frame.size.width, resultArray.count*40)];
            [tableViewForResult setHidden:NO];
        }
        [self.tableViewForResult reloadData];
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
            //[self deleteCity:city];
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
                        //[self deleteCity:city];
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




#pragma mark - RestKit Request/Response Delegate Methods
-(void)getMyListOfCities {
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    [[AppDelegate appDelegate].rkomForCity getObjectsAtPath:kGetMyListOfCity parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse = [mappingResult.array firstObject];
        NSArray *arrayForCity = [dataResponse.city allObjects];
        if(arrayForCity.count > 0){
            arrayOfWantTovisit = [NSMutableArray array];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wantsToVisit == true"];
            arrayOfWantTovisit = [[NSMutableArray alloc] initWithArray:[arrayForCity filteredArrayUsingPredicate:predicate]];
            predicate = [NSPredicate predicateWithFormat:@"isVisitedCity == true"];
            arrayOfVisited = [[NSMutableArray alloc] initWithArray:[arrayForCity filteredArrayUsingPredicate:predicate]];
            [tableViewForCityList reloadData];
            [tableViewForCityList setHidden:NO];
            [lblNoDataExist setHidden:YES];
        }else{
            [tableViewForCityList setHidden:YES];
            lblNoDataExist.text = @"City list not found.";
            [lblNoDataExist setHidden:NO];
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
            [self getMyListOfCities];
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
                        [self getMyListOfCities];
                        return;
                        
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kDATA_NOT_EXIST){
                        [tableViewForCityList setHidden:YES];
                        lblNoDataExist.text = @"Data Not Found.";
                        [lblNoDataExist setHidden:NO];
                    }else if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_Operation_Complete){
                    }
                }else{
                    [tableViewForCityList setHidden:YES];
                    lblNoDataExist.text = kAlert_Server_Not_Rechable;
                    [lblNoDataExist setHidden:NO];
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:error.localizedDescription delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

-(void)sendRequestToGetCityListFromDatabase{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kGetListOfCity,pageCount];
    [[AppDelegate appDelegate].rkomForPost getObject:nil path:strPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        if (dataResponse.post.count >= 1) {
            cityArray = [[NSMutableArray alloc] initWithArray:dataResponse.post.allObjects];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // Transport error or server error handled by errorDescriptor
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
            [self sendRequestToGetCityListFromDatabase];
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
                        [self sendRequestToGetCityListFromDatabase];
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
        RKLogError(@"Operation failed with error: %@", error);
    }];
}

-(void)deleteCity:(City *)selectedCity {
    [RSActivityIndicator showIndicator];
    [[AppDelegate appDelegate].rkomForCity deleteObject:selectedCity path:[NSString stringWithFormat:kResource_mycity_delete,city.ids] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
       [RSActivityIndicator hideIndicator];
        [self getMyListOfCities];
        
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
            [self deleteCity:city];
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
                        [self deleteCity:city];
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


-(void)submitAnswer:(NSMutableDictionary *)dict {
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    [[AppDelegate appDelegate].rkomForLogin postObject:nil path:kAddCity parameters:dict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        DataForResponse *dataResponse  = [mappingResult.array objectAtIndex:0];
        NSLog(@"%@",dataResponse.city);
        
        [self getMyListOfCities];
        //City *city = [[dataResponse.city allObjects]firstObject];
        
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
            [self submitAnswer:dictForAnswer];
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
                        [self submitAnswer:dictForAnswer];
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
        RKLogError(@"Operation failed with error: %@", error);
    }];
}



@end
