//
//  MenuOptionsViewController.h
//  SportzCal
//
//  Created by Sitanshu Joshi on 1/28/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.

#import <UIKit/UIKit.h>


@interface MenuOptionsViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imgViewForProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIView *viewForCityButton;
@property (weak, nonatomic) IBOutlet UIView *viewForNewsButton;
@property (weak, nonatomic) IBOutlet UIView *viewForProfileButton;
@property (weak, nonatomic) IBOutlet UIView *viewForLogoutButton;

@end
