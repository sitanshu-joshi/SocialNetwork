//
//  HomeViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 20/08/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<FBLoginViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//Action Methods
-(IBAction)btnLoginTapped:(id)sender;
-(void)pushToFlightViewController;
@end
