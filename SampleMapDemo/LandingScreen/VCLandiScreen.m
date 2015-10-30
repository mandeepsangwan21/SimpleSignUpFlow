//
//  VCLandiScreen.m
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 29/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import "VCLandiScreen.h"
#import "VCCreateAccount.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface VCLandiScreen ()

@end

@implementation VCLandiScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"LandingScreen.jpeg"]];
    // Do any additional setup after loading the view from its nib.
    
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createAccount:(id)sender {
    
    VCCreateAccount *createAccountObj = [[VCCreateAccount alloc] initWithNibName:@"VCCreateAccount" bundle:nil];
    [self.navigationController pushViewController:createAccountObj animated:YES];
}
- (IBAction)loginAction:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
