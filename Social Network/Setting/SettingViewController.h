//
//  SettingViewController.h
//  Social Network
//
//  Created by Rushi on 05/02/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<CustomSlideViewControllerDelegate,UIAlertViewDelegate>{
}
@property (weak, nonatomic) IBOutlet UIButton *btnMainMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
- (IBAction)logoutBtnTapped:(id)sender;

@end
