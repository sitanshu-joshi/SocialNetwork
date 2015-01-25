//
//  QuestionAnswerViewController.h
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionAnswerViewController : UIViewController<UITextViewDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITextView *txtViewForQuestion1;
@property (weak, nonatomic) IBOutlet UITextView *txtViewForAnswer1;
@property (weak, nonatomic) IBOutlet UITextView *txtViewForQuestion2;
@property (weak, nonatomic) IBOutlet UITextView *txtViewForAnswer2;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

- (IBAction)btnSkipTapped:(id)sender;
- (IBAction)btnSubmitTapped:(id)sender;
@end
