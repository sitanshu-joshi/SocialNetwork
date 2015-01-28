//
//  QuestionAnswerViewController.m
//  Social Network
//
//  Created by Sagar Gondaliya on 24/12/14.
//  Copyright (c) 2014 Sitanshu Joshi. All rights reserved.
//

#import "QuestionAnswerViewController.h"

@interface QuestionAnswerViewController ()

@end

@implementation QuestionAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contentInsets = self.scrollView.contentInset;
    
    [self setUpUserInterface];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUpUserInterface{
    self.txtViewForAnswer1.layer.cornerRadius = 7.0;
    self.txtViewForAnswer1.layer.masksToBounds = YES;
    
    self.txtViewForAnswer2.layer.cornerRadius = 7.0;
    self.txtViewForAnswer2.layer.masksToBounds = YES;
    
    self.txtViewForQuestion1.layer.cornerRadius = 7.0;
    self.txtViewForQuestion1.layer.masksToBounds = YES;
    
    self.txtViewForQuestion2.layer.cornerRadius = 7.0;
    self.txtViewForQuestion2.layer.masksToBounds = YES;
    
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSkip.layer.cornerRadius = 5.0;
    
}

#pragma mark - IBAction Methods

- (IBAction)btnSkipTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPush_To_SlideBar1 object:nil];
}

- (IBAction)btnSubmitTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPush_To_SlideBar1 object:nil];
}


#pragma mark - UITextField Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    self.scrollView.contentOffset = CGPointMake(0, textView.frame.origin.y - textView.frame.size.height/2);
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointZero;

}

@end
