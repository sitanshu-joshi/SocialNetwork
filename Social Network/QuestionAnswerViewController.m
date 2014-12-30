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

@synthesize scrollViewContainer,pageControl,txtViewForAnswer,txtViewForQuestion;


- (void)viewDidLoad {
    [super viewDidLoad];
    txtViewForQuestion.layer.cornerRadius = 7.0;
    txtViewForAnswer.layer.cornerRadius = 7.0;
    txtViewForAnswer.layer.masksToBounds = YES;
    txtViewForQuestion.layer.masksToBounds = YES;
//    CGSize scrollViewContentSize = CGSizeMake(640, 404);
//    [self.scrollView setContentSize:scrollViewContentSize];
      scrollViewContainer.showsHorizontalScrollIndicator = NO;
 
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnContinueAction:(id)sender {
    [self performSegueWithIdentifier:kPush_To_CityPage sender:nil];
}

#pragma mark - UITextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollViewContainer.frame.size.width;
    float fractionalPage = scrollViewContainer.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}



@end
