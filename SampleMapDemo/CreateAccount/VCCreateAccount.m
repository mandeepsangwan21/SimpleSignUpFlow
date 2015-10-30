//
//  VCCreateAccount.m
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 29/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import "VCCreateAccount.h"
#import "FBUtilNew.h"
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
