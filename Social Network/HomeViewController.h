//
//  HomeViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 20/08/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppLogin.h"
#import "AppUserInfo.h"


@interface HomeViewController : UIViewController<FBLoginViewDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UIButton *btnFbLogin;
- (IBAction)fbLoginBtnTapped:(id)sender;
@end
