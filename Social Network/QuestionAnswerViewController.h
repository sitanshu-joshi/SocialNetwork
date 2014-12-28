//
//  QuestionAnswerViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionAnswerViewController : UIViewController<UITextFieldDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UIButton *btnContinue;

-(IBAction)btnContinueAction:(id)sender;


@end
