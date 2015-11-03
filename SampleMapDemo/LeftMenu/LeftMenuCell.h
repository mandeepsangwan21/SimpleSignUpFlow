//
//  LeftMenuCell.h
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 31/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *menuItem;
-(void)setCellData : (NSString*) friendsDetails;
@end
