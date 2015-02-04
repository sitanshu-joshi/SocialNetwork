//
//  NewsFeedViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 25/01/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityPageViewController.h"

@interface NewsFeedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, CustomSlideViewControllerDelegate,UISearchBarDelegate> {
    BOOL isInputViewVisible;
    NSString *strAddress;
    NSMutableArray *resultArray;
}

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@property (weak, nonatomic) IBOutlet UIButton *btnMainMenu;

@property (weak, nonatomic) IBOutlet UIView *containerViewForCityInput;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableViewForCityResult;

@end
