//
//  VCLeftMenu.m
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 30/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import "VCLeftMenu.h"
#import "LeftMenuCell.h"
#import "LeftMenuData.h"
#import "VCProfile.h"
CGFloat const HEIGHT_OF_ROW1 = 90.0;
static NSString *cellIdentifier;
@interface VCLeftMenu () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *menuList;
}
@property (weak, nonatomic) IBOutlet UITableView *menuListTable;
@end

@implementation VCLeftMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"food5.jpg"]];
    LeftMenuData *leftMenuDatAObj = [LeftMenuData getInstance];
    leftMenuDatAObj.menuItems = [[NSMutableArray alloc] initWithObjects:@"Profile",@"Starters",@"Dinner", nil];
    menuList = leftMenuDatAObj.menuItems;
    self.menuListTable.delegate = self;
    self.menuListTable.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark- Tablew view delegates and data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT_OF_ROW1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuList count];
}


- (LeftMenuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cellIdentifier = @"Cell";
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // Allocating New Memory until the cell is NIL else Reusing Cell
    if (cell == nil) {
        cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //Setting cell Data
    [cell setCellData :[menuList objectAtIndex:indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    switch (indexPath.row) {
        case 0:
        {
            VCProfile *profileObj = [[VCProfile alloc]initWithNibName:@"VCProfile" bundle:nil];
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:profileObj];
            
            //now present this navigation controller modally
            [self presentViewController:navigationController
                               animated:YES
                             completion:^{
                                 
                             }];
        }
            break;
            
        default:
            break;
    }
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
