//
//  UserDefaultController.m
//  Matchstix
//
//  Created by craterzone on 16/05/15.
//  Copyright (c) 2015 craterzone. All rights reserved.
//

#import "UserDefaultController.h"
#import "Constants.h"

@implementation UserDefaultController

@synthesize standardUserDefaults;

-(void)setUserDefaults
{
    self.standardUserDefaults = [NSUserDefaults standardUserDefaults];
}

static UserDefaultController *instance=nil;


+(UserDefaultController *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [UserDefaultController new];
        }
    }
    return instance;
}


#pragma mark - Insertion Methods -

-(void)setMinimumAge :(id)value
{
    [self.standardUserDefaults setObject:value forKey:USER_NAME_KEY];
    
}

-(id)getMinimumAge
{
    return [self.standardUserDefaults objectForKey:USER_NAME_KEY];
    
}

-(void)setCreateAccountCompleted :(BOOL)value {
    [self.standardUserDefaults setBool:value forKey:CREATE_ACCOUNT_KEY];
}
-(BOOL)getCreateAccountCompleted {
    return [self.standardUserDefaults boolForKey:CREATE_ACCOUNT_KEY];
}

-(void)setUserName : (NSString*)name {
    [self.standardUserDefaults setObject:name forKey:USER_NAME_KEY];
}
-(NSString*)getUserName {
    return [self.standardUserDefaults objectForKey:USER_NAME_KEY];
}
-(void)setUserGender : (NSString*)gender {
    [self.standardUserDefaults setObject:gender forKey:USER_GENDER_KEY];
}
-(NSString*)getUserGender {
    return [self.standardUserDefaults objectForKey:USER_GENDER_KEY];
}
-(void)setUserEmail : (NSString*)email {
    [self.standardUserDefaults setObject:email forKey:USER_EMAIL_KEY];
}
-(NSString*)getUserEmail {
    return [self.standardUserDefaults objectForKey:USER_EMAIL_KEY];
}

-(void)setUserProfilePicURL : (NSString*)url {
    [self.standardUserDefaults setObject:url forKey:USER_PROFILE_PIC_URL_KEY];
}
-(NSString*)getUserProfilePicURL {
    return [self.standardUserDefaults objectForKey:USER_PROFILE_PIC_URL_KEY];
}

@end
