//
//  SettingViewController.m
//  Social Network
//
//  Created by Rushi on 05/02/15.
//  Copyright (c) 2015 Sitanshu Joshi. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize btnMainMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [btnMainMenu addTarget:self action: @selector(mainMenuBtnClickAtProfile) forControlEvents:UIControlEventTouchUpInside];
    self.revealViewController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mainMenuBtnClickAtProfile {
    [self.revealViewController revealToggle:self.btnMainMenu];
}

- (IBAction)logoutBtnTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Logout delegate:self cancelButtonTitle:kNoButton otherButtonTitles:kYesButton, nil];

    [alert show];
}

#pragma mark - UIAlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if([[AppDelegate appDelegate]isNetworkReachableToInternet]){
            [self sendRequestToLogout];
            [self closeSession];
        }else{
            [self networkNotReachable];
        }
    }
}

-(void)sendRequestToLogout{
    DataForResponse *data;
    [[[AppDelegate appDelegate]rkomForLogin]getObject:data path:kLogout parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [RSActivityIndicator hideIndicator];
        // Transport error or server error handled by errorDescriptor
        [RSActivityIndicator hideIndicator];
        NSLog(@"%@",operation.HTTPRequestOperation.responseString);
        if(error.code == -(kRequest_Server_Not_Rechable)){
            [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
        }else if(error.code == -(kRequest_TimeOut)){
            [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Request_TimeOut delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
        }else{
            if(operation.HTTPRequestOperation.responseData){
                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:NSJSONReadingAllowFragments error:&error];
                if(dictResponse){
                    if([[dictResponse valueForKey:@"code"] intValue] == kSusscessully_logout){
                         [self closeSession];
                         [[AppDelegate appDelegate] backToRootView];
                    }else{
                        [[[UIAlertView alloc]initWithTitle:kAppTitle message:[dictResponse valueForKey:@"msg"] delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                    }
                }else{
                    [[[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_Server_Not_Rechable delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:kAppTitle message:error.localizedDescription delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil,nil]show];
            }
        }
        RKLogError(@"Operation failed with error: %@", error);
    }];
   
}


-(void)closeSession{
    [[FBSession activeSession]closeAndClearTokenInformation];
    [[FBSession activeSession]close];
    [[AppUserInfo sharedAppUserInfo]clearUserDefaults];
    [[AppLogin sharedAppLogin] clearUserDefaults];
}

-(void)networkNotReachable{
    [RSActivityIndicator hideIndicator];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppTitle message:kAlert_NoInternet delegate:nil cancelButtonTitle:kOkButton otherButtonTitles:nil, nil];
    [alert show];
}


@end
