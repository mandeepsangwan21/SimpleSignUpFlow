//
//  VCCreateAccount.m
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 29/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//
/*
 #import "JACenterViewController.h"
 #import "JALeftViewController.h"
 #import "JARightViewController.h"
 
	self.viewController = [[JASidePanelController alloc] init];
 self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
 
	self.viewController.leftPanel = [[JALeftViewController alloc] init];
	self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[JACenterViewController alloc] init]];
	self.viewController.rightPanel = [[JARightViewController alloc] init];
	
	self.window.rootViewController = self.viewController;
 [self.window makeKeyAndVisible];

 */
#import "VCCreateAccount.h"
#import "FBUtilNew.h"
#import "JASidePanelController.h"
#import "VCLeftMenu.h"
#import "VCRightMenu.h"
#import "VCCenterDetails.h"
#import "AppDelegate.h"
#import "UserDefaultController.h"
@interface VCCreateAccount ()

@end

@implementation VCCreateAccount

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Bye-Bye-Bunny-Pancakes.jpg"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createAccountUsingFB:(id)sender {
    NSArray *permissionArray = @[@"public_profile",@"user_birthday",@"email",@"user_photos"];
    NSArray *fieldArray = @[@"email",@"id",@"name",@"first_name",@"birthday",@"last_name",@"gender",@"link",@"picture.height(600).width(590)"];
    [FBUtilNew getPermissionsArray:permissionArray];
    [FBUtilNew getUserDataFieldsNeededAfterLogin:fieldArray];
    [FBUtilNew loginWithFaceBookWithCompletionBlock:^(id fbResponse, NSError *error){
        if (fbResponse !=nil) {
            NSLog(@"%@",fbResponse);
   AppDelegate  *appD  = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appD.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
            appD.viewController.leftPanel = [[VCLeftMenu alloc] init];
            appD.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[VCCenterDetails alloc] init]];
            appD.viewController.rightPanel = [[VCRightMenu alloc] init];
            appD.window.rootViewController = appD.viewController;
            [appD.window makeKeyAndVisible];
            
            UserDefaultController *obj = [UserDefaultController getInstance];
            [obj setCreateAccountCompleted:YES];
            [obj setUserEmail:[fbResponse objectForKey:@"email"]];
            [obj setUserGender:[fbResponse objectForKey:@"gender"]];
            [obj setUserName:[fbResponse objectForKey:@"name"]];
            [obj setUserProfilePicURL:[[fbResponse objectForKey:@"picture"] objectForKeyedSubscript:@"url"]];
//            DDLogVerbose(@"%@",fbResponse);
//            [self storeUserInfo:fbResponse];
            //call web service
//            [self matchstixSignUp:fbResponse];
        }
        else{
//            DDLogVerbose(@"%@",error);
//            [self hideHud];
        }
    }];

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
