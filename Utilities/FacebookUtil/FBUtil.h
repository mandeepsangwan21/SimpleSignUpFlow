//
//  FBUtil.h
//  FacebookLibrary
//
//  Created by Parul Jain on 07/04/15.
//  Copyright (c) 2015 Parul Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const PICTURE_KEY;
extern NSString *const CAPTION_KEY;
extern NSString *const PARAMS_KEY;
extern NSString *const IMAGE_KEY;
extern NSString *const VIDEO_NAME_KEY;
extern NSString *const DESCRIPTION_KEY;
extern NSString *const PROFILE_IMAGE_KEY;
typedef void (^FBFriendCompletionBlock)(NSArray *friends, NSError *error);
typedef void (^FBCompletionBlock)(id response, NSError *error);

@interface FBUtil : NSObject
+(void)logOutFromFacebook;
+(void)loginWithFaceBookWithCompletionBlock:(FBCompletionBlock)fbResult ;

+(void)fetchFriendsWithFBFriendCompletionBlock:(FBFriendCompletionBlock)fbFriends;
+(void)getUserAlbumsListWithLastPhotoCompletionBlock:(FBCompletionBlock)fbResult;
+(void)getUserAlbumsWithCompletionBlock:(FBCompletionBlock)fbResult;
+(void)getUserProfilePicturesAlbumsWithCompletionBlock:(FBCompletionBlock)fbResult;
+(void)getAlbumsPhotos:(NSString *)albumID WithCompletionBlock:(FBCompletionBlock)fbResult;
+(void)getAlbumsPhotos:(NSString *)albumID withLimit:(int)limit WithCompletionBlock:(FBCompletionBlock)fbResult;

//upload image , videos and url 
+(void)uploadImageWithShareDialog:(NSDictionary *)paramsDict withBlock:(FBCompletionBlock)fbResult;
+(void)uploadImageToFacebook:(NSDictionary *)params withBlock:(FBCompletionBlock)fbResult;
+(void)shareWithURL:(NSString *)urlString :(NSString *)caption :(NSString *)lResUrl withBlock:(FBCompletionBlock)fbResult;
+(void)uploadVideo:(NSDictionary *)params WithCompletionBlock:(FBCompletionBlock)fbResult;
+(NSString*)activeSessionToken;
+(void)getMutualLikesAndFriendsForUserID:(NSString *)userID WithCompletionBlock:(FBCompletionBlock)fbResult;
+(void)getUserInterestPhotoFromFacebook:(NSString *)interestID WithCompletionBlock:(FBCompletionBlock)fbResult;
@end
