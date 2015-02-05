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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [btnMainMenu addTarget:self action: @selector(mainMenuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.revealViewController.delegate = self;
    containerViewForCityInput.layer.cornerRadius = 5.0;
    containerViewForCityInput.layer.masksToBounds = YES;
    self.tableViewForCityResult.layer.cornerRadius = 7.0;
    self.tableViewForCityResult.layer.masksToBounds = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

}

-(void)quesionAnswerSuccess{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController.navigationBar setHidden:NO];
        self.newsTableView.alpha = 1;
    }];
}

-(void)mainMenuBtnClicked {
    [self.revealViewController revealToggle:self.btnMainMenu];
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tableViewForCityResult){
        return [resultArray count];
    }else{
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    static NSString *identifier = nil;
    if(tableView == self.tableViewForCityResult){
        identifier = @"resultCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        Result *result = [resultArray objectAtIndex:indexPath.row];
        UILabel *lblAddress =(UILabel *)[cell.contentView viewWithTag:999];
        lblAddress.text = result.formatted_address;
    }else{
       identifier = @"newsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    return cell;
}

#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableViewForCityResult){
        [self hideCityInputView];
        Result *result = [resultArray objectAtIndex:indexPath.row];
        strAddress = result.formatted_address;
        [self.tableViewForCityResult setHidden:YES];
        [self performSegueWithIdentifier:kPushToCityFromNews sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cityBtnTapped:(id)sender {
    if(!isInputViewVisible){
        [self showCityInputView];
    }else{
        [self hideCityInputView];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:kPushToCityFromNews]){
        CityPageViewController *cityViewController = (CityPageViewController *)[segue destinationViewController];
        cityViewController.strAddress = strAddress;
    }
}

#pragma mark - UISearchBar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"============== %@",searchText);
    [self getPlaceForAddress:searchText];
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

//To search place
-(void)getPlaceForAddress:(NSString *)searchString {
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
        // Transport error or server error handled by errorDescriptor
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        NSLog(@"%@",error.localizedDescription);
        NSString *errorMessage = [NSString stringWithFormat:@"%@",error.localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:errorMessage delegate:self cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
        [alert show];
    }];
}

#pragma mark - To get Post Data For Home Town
-(void)getNewsForHomeTown:(int)pageNumber{
    [RSActivityIndicator showIndicatorWithTitle:kActivityIndicatorMessage];
    NSString *strPath = [NSString stringWithFormat:kGetNews,pageNumber];
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

@end
