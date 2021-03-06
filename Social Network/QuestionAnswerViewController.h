//
//  QuestionAnswerViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuestionAnswerViewController : UIViewController<UITextViewDelegate,CustomSlideViewControllerDelegate>{
    UIEdgeInsets contentInsets;
    NSMutableArray *resultArray;
    NSMutableArray *cityArray;
    City *city;
    NSMutableArray *arrayOfVisited;
    NSMutableArray *arrayOfWantTovisit;
    NSMutableDictionary *dictForAnswer;
    int pageCount;
    NSIndexPath *indexToDelete;
}

@property (weak, nonatomic) IBOutlet UILabel *lblNoDataExist;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableViewForResult;
@property (weak, nonatomic) IBOutlet UITableView *tableViewForCityList;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentForCityType;

@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)btnSkipTapped:(id)sender;
- (IBAction)valueForSegmentChange:(id)sender;

@end
