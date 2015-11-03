//
//  LeftMenuCell.m
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 31/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import "LeftMenuCell.h"

@implementation LeftMenuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"LeftMenuCell" owner:nil options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

-(void)setCellData : (NSString*) itemName {
    self.menuItem.text = itemName;
}

@end
