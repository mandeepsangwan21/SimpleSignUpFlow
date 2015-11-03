//
//  VCProfile.m
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 31/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import "VCProfile.h"
#import "UserDefaultController.h"
@interface VCProfile ()
{
    UIBarButtonItem *editDone;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;

@end

@implementation VCProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    self.navigationController.navigationBarHidden = NO;
    self.title = @"Profile";
  //  [[self navigationController] setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleDone target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    editDone = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStyleDone target:self action:@selector(editAction)];
        self.navigationItem.rightBarButtonItem = editDone;

    [self setProfileInfo];
}
-(void)setProfileInfo {
    UserDefaultController *obj = [UserDefaultController getInstance];
    self.nameTextField.text = [obj getUserName];
    self.genderTextField.text = [obj getUserGender];
    self.emailTextField.text = [obj getUserEmail];
    
    //make textfields inactive initially
    self.nameTextField.enabled = NO;
    self.genderTextField.enabled = NO;
    self.emailTextField.enabled = NO;
    
    
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

- (IBAction)editAction
{
    if([editDone.title isEqual:@"Edit"]) {
      [editDone setTitle:@"Done"];
        self.nameTextField.enabled = YES;
        self.genderTextField.enabled = YES;
        self.emailTextField.enabled = YES;

    } else {
      [editDone setTitle:@"Edit"];
        self.nameTextField.enabled = NO;
        self.genderTextField.enabled = NO;
        self.emailTextField.enabled = NO;

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
      //  self.navigationController.navigationBarHidden = YES;
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
