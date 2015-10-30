//
//  FBUtilNew.h
//  FacebookLibrary
//
//  Created by Parul Jain on 07/04/15.
//  Copyright (c) 2015 Parul Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
extern NSString *const PICTURE_KEY_FB;
extern NSString *const CAPTION_KEY_FB;
extern NSString *const PARAMS_KEY_FB;
extern NSString *const IMAGE_KEY_FB;
extern NSString *const VIDEO_NAME_KEY_FB;
extern NSString *const DESCRIPTION_KEY_FB;
extern NSString *const PROFILE_IMAGE_KEY_FB;
extern NSString *const PROFILE_URL_FB;
extern NSString *const IS_SILHOUETTE_FB;
extern NSString *const PICTURE_URL_FB;
typedef void (^FBFriendCompletionBlock)(NSArray *friends, NSError *error);
typedef void (^FBCompletionBlock)(id response, NSError *error);
@protocol FacebookProtocol <NSObject>

@optional
-(void)postSharedResponse :(NSDictionary *)results;
-(void)postCancelledResponse;
-(void)failResponse:(NSError *)error;
@end

@interface FBUtilNew : NSObject<FBSDKSharingDelegate>
@property(nonatomic,strong)NSArray *myPermissions;
+(FBUtilNew*)sharedInstance;
@property(nonatomic,strong)id<FacebookProtocol>delegate;
/*
 *@author - Parul Jain
 *get permissions from facebook
 *parameters :
forexample:@"user_location",@"user_hometown",@"user_about_me",@"user_relationships",@"user_relationship_details",@"user_friends",@"publish_actions",@"user_likes",@"user_birthday",@"email",@"user_photos",@"user_about_me",@"read_stream",@"public_profile",@"publish_actions",@"photo_upload",@"video_upload",@"user_photos",@"publish_stream"
 */
+(NSArray *)getPermissionsArray:(NSArray *)permissionArray;

/*
 *@author- Parul Jain
 *logout facebook
 */
+(void)logOutFromFacebook;

/*
 *@author- Parul Jain
 *input fields needed during login
 eg.id,first_name,gender,last_name,name,link,birthday,email
 */
+(NSArray *)getUserDataFieldsNeededAfterLogin:(NSArray *)fieldsArray;

/*
 *@author- Parul Jain
 *login facebook with permissions and fields needed after login for eg.id,first_name,gender,last_name,name,link,birthday,email
 */
+(void)loginWithFaceBookWithCompletionBlock:(FBCompletionBlock)fbResult ;

/*
 *@author- Parul Jain
 *method to get profile picture of logged in user
 *parameter - userid of the logged in user ,width and height of profile pic in pixels for eg. 800*800 , 500*500
 */
+(void)getProfilePicture:(NSString *)userId withWidth:(int)width andHeight:(int)height WithCompletionBlock:(FBCompletionBlock)fbResult;

/*
 *@author - Parul Jain
 *get the user's friends detail who also use the app.
 *parameters :limit to friends to fetch (limit cannot be nil)
 */
+ (void)fetchFriendsWithLimit:(int)limit WithFBFriendCompletionBlock:(FBFriendCompletionBlock)fbFriends;

/*
 *@author - Parul Jain
 *get the user's facebook Album details
 *parameters :
 */
+(void)getUserAlbumsWithCompletionBlock:(FBCompletionBlock)fbResult;


/*
 *@author - Parul Jain
 *get the user's all Album Photos with limit
 *parameters :limit of photos to retrieve
 */
+(void)getUserAlbumsPhotosWithLimit:(int)limit WithCompletionBlock:(FBCompletionBlock)fbResult;

/*
 *@author - Parul Jain
 *get the user's facebook Profile picture Album details
 *parameters :
 */
+(void)getUserProfilePicturesAlbumsWithCompletionBlock:(FBCompletionBlock)fbResult;

/*
 *@author - Parul Jain
 *get the user's facebook Album Photos
 *parameters :NSString(albumID)
 */
+(void)getAlbumsPhotos:(NSString *)albumID WithCompletionBlock:(FBCompletionBlock)fbResult;

/*
 *@author - Parul Jain
 *get the user's facebook Album Photos with particular limit
 *parameters :NSString(albumID) ,int(limit)
 */
+(void)getAlbumsPhotos:(NSString *)albumID withLimit:(int)limit WithCompletionBlock:(FBCompletionBlock)fbResult;

//upload image , videos and url

/*
 *@author - Parul Jain
 *upload Image to users wall 
 Photos must be less than 12MB in size
 *parameters :NSDictionary(image(UIImage))
 */
-(void)uploadImageToFacebook:(NSMutableDictionary *)params fromViewController:(UIViewController *)viewController;

/*
 *@author - Parul Jain
 *share link to facebook
 *parameters :NSString(link),NSString(contentTitle),NSString(contentDescription), view controller
 */
-(void)shareWithURL:(NSString *)urlString :(NSString *)imageUrl :(NSString *)contentTitle :(NSString *)contentDescription fromViewController:(UIViewController *)viewController;

/*
 *@author : Parul Jain
 *method to upload video to facebook
 The videos must be less than 12MB in size.
 *@params :->
 *videoData : @"video url",
 URL that points to the location of the video on disk
 */

-(void)uploadVideo:(NSDictionary *)params fromViewController:(UIViewController *)viewController;


/*
 *@author - Parul Jain
 *method to upload photo from app to facebook
 *parameters :param like url of the photo or source encoded as form data,description of photo, album id 
 */
+(void)uploadPhotosToAlbum:(NSDictionary *)params WithAlbumID:(NSString *)albumId WithCompletionBlock:(FBCompletionBlock)fbResult ;

+(NSString*)activeSessionToken;
@end
