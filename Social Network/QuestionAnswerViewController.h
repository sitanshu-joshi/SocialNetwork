//
//  QuestionAnswerViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMTagListView.h"

@interface QuestionAnswerViewController : UIViewController<UITextViewDelegate>{
    UIEdgeInsets contentInsets;
    NSMutableArray *resultArray;
    NSMutableArray *cityArray;
    NSString *isVIsited , *wantsToVisit;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UITextView *txtViewForQuestion1;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet AMTagListView *tagListView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewForResult;

@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)btnSkipTapped:(id)sender;
- (IBAction)nextButtonTapped:(id)sender;
@end
