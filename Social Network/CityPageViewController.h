//
//  CityPageViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityPageViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *txtViewForDetail;

- (IBAction)btnBackEvent:(id)sender;

@end
