//
//  UserDefaultController.h
//  Matchstix
//
//  Created by craterzone on 16/05/15.
//  Copyright (c) 2015 craterzone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultController : NSObject
{
    NSUserDefaults *standardUserDefauts;
}
@property (nonatomic,strong) NSUserDefaults *standardUserDefaults;
+(UserDefaultController*)getInstance;
-(void)setUserDefaults;
-(void)setMinimumAge :(id)value;
-(id)getMinimumAge;
-(void)setCreateAccountCompleted :(BOOL)value;
-(BOOL)getCreateAccountCompleted;
-(void)setUserName : (NSString*)name;
-(NSString*)getUserName;
-(void)setUserGender : (NSString*)gender;
-(NSString*)getUserGender;
-(void)setUserEmail : (NSString*)email;
-(NSString*)getUserEmail;
-(void)setUserProfilePicURL : (NSString*)url;
-(NSString*)getUserProfilePicURL;

@end
