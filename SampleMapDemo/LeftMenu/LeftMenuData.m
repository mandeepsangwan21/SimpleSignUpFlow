//
//  LeftMenuData.m
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 31/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import "LeftMenuData.h"

@implementation LeftMenuData

static LeftMenuData *instance = nil;

+(LeftMenuData *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [LeftMenuData new];
        }
    }
    return instance;
}



@end
