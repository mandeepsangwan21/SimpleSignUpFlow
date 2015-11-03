//
//  LeftMenuData.h
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 31/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeftMenuData : NSObject
@property (nonatomic,strong) NSMutableArray *menuItems;
+(LeftMenuData *)getInstance;

@end
