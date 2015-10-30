//
//  FBUtilNew.m
//  FacebookLibrary
//
//  Created by Parul Jain on 07/04/15.
//  Copyright (c) 2015 Parul Jain. All rights reserved.
//

#import "FBUtilNew.h"

//#import "ViewUtilities.h"
//#import "DDLog.h"
//#import "UserDefaultController.h"
//#if DEBUG
//static const int ddLogLevel = LOG_LEVEL_VERBOSE;
//#else
//static const int ddLogLevel = LOG_LEVEL_WARN;
//#endif
NSString *const PICTURE_KEY_FB = @"picture";
NSString *const CAPTION_KEY_FB = @"message";
NSString *const PARAMS_KEY_FB = @"params";
NSString *const IMAGE_KEY_FB = @"image";
NSString *const VIDEO_NAME_KEY_FB = @"video";
NSString *const DESCRIPTION_KEY_FB = @"description";
NSString *const PROFILE_IMAGE_KEY_FB = @"profileImage";
NSString *const IS_SILHOUETTE_FB = @"is_silhouette";
NSString *const PROFILE_URL_FB = @"url";
NSString *const FB_PERMISSONS_FB = @"FB_PERMISSONS";
NSString *const PICTURE_URL_FB = @"PICTURE_URL";
@implementation FBUtilNew
@synthesize delegate;
static NSArray *permissions = nil;
static NSArray *userfieldsArray = nil;

+(FBUtilNew*)sharedInstance {
    static FBUtilNew *sharedInstance = nil;
    @synchronized(self){
        if (!sharedInstance) {
            sharedInstance = [[FBUtilNew alloc]init];
        }
    }
    return sharedInstance;
}


+(NSArray *)getPermissionsArray:(NSArray *)permissionArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
     permissions = [[NSArray alloc] initWithArray:permissionArray];
        [[NSUserDefaults standardUserDefaults]setValue:permissions forKey:FB_PERMISSONS_FB];
         });
      return permissions;
    
}

+(void)logOutFromFacebook
{
    [FBSDKProfile setCurrentProfile:nil];
    [FBSDKAccessToken setCurrentAccessToken:nil];
     NSHTTPCookie *cookie;
     NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString *domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
}

+(NSArray *)getUserDataFieldsNeededAfterLogin:(NSArray *)fieldsArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userfieldsArray = [[NSArray alloc] initWithArray:fieldsArray];
        [[NSUserDefaults standardUserDefaults]setValue:permissions forKey:FB_PERMISSONS_FB];
    });
    return userfieldsArray;
}

+(void)loginWithFaceBookWithCompletionBlock:(FBCompletionBlock)fbResult {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    NSString * fieldString = [userfieldsArray componentsJoinedByString:@","];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:fieldString forKey:@"fields"];
    [loginManager logInWithReadPermissions:permissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (!error) {
            if ([FBSDKAccessToken currentAccessToken]) {
//                [[UserDefaultController getInstance] setFBToken:[FBSDKAccessToken currentAccessToken].tokenString];
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:dict]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id user, NSError *error) {
                     if (!error) {
                         fbResult(user,nil);
                     }
                     else {
//                          DDLogVerbose(@"%@",error);
                          fbResult(nil,error);
                     }
                }];
            }
        }
        else if (result.isCancelled) {
  //          DDLogVerbose(@"%@",error);
            fbResult(nil,error);

        }
        else {
      //      DDLogVerbose(@"%@",error);
            fbResult(nil,error);
        }
    }];
}

+(void)getProfilePicture:(NSString *)userId withWidth:(int)width andHeight:(int)height WithCompletionBlock:(FBCompletionBlock)fbResult
{
    if (userId) {
        
        if ([FBSDKAccessToken currentAccessToken]) {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@/picture?width=%d&height=%d&redirect=false",userId,width,height] parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSDictionary *picDetailDict = [result objectForKey:@"data"];
                     fbResult(picDetailDict,nil);
                 }
                 else {
          //           DDLogVerbose(@"%@",error);
                     fbResult(nil,error);
                 }
                 
             }];
        }
        
    }
}


+ (void)fetchFriendsWithLimit:(int)limit WithFBFriendCompletionBlock:(FBFriendCompletionBlock)fbFriends {
    [self getFriendsFriends:@"me" WithLimit:limit WithCompletionBlock:^(id response, NSError *error) {
        if (response) {
            fbFriends(response,nil);
        }
        else {
        //    DDLogVerbose(@"%@",error);
            fbFriends(nil,error);
        }

    }];
}


+(void)getFriendsFriends:(NSString *)userID WithLimit:(int)limit WithCompletionBlock:(FBCompletionBlock)fbResult
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"%@/friends?fields=picture.type(large),name&limit=%d",userID,limit] parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSArray* friends = [result objectForKey:@"data"];
                 fbResult(friends,nil);
             }
             else {
          //       DDLogVerbose(@"%@",error);
                 fbResult(nil,error);
             }
             
         }];
    }
}

+(void)getUserAlbumsWithCompletionBlock:(FBCompletionBlock)fbResult
{

  
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"me/albums/?fields=cover_photo,name,count"] parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSArray *arrAlums=[result objectForKey:@"data"];
                 fbResult(arrAlums,nil);             }
             else {
          //       DDLogVerbose(@"%@",error);
                 fbResult(nil,error);
             }
             
         }];
    }
}

+(void)getUserProfilePicturesAlbumsWithCompletionBlock:(FBCompletionBlock)fbResult
{

    
    [self getUserAlbumsWithCompletionBlock:^(id response, NSError *error) {
        if (!error) {
            if (response) {
                NSDictionary *dictPP=nil;
                for (NSDictionary *dict in response) {
                    if ([[dict objectForKey:@"name"]isEqualToString:@"Profile Pictures"]) {
                        dictPP=dict;
                    }
                }
                if (dictPP == nil) {
                    fbResult(nil,[NSError errorWithDomain:@"No Albums" code:900 userInfo:nil]);
                }else{
                    fbResult(dictPP,nil);
                }
            }
            else{
                fbResult(nil,[NSError errorWithDomain:@"No Albums" code:900 userInfo:nil]);
            }
        }
        else{
         //    DDLogVerbose(@"%@",error);
            fbResult(nil,error);
        }
    }];
}

+(void)getAlbumsPhotos:(NSString *)albumID WithCompletionBlock:(FBCompletionBlock)fbResult
{
    
    if (albumID) {
        if ([FBSDKAccessToken currentAccessToken]) {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"%@/photos?fields=source",albumID] parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSArray *arrPhotos=[result objectForKey:@"data"];
                     fbResult(arrPhotos,nil);
             }
                 else {
                //     DDLogVerbose(@"%@",error);
                     fbResult(nil,error);
                 }
                 
             }];
        }
    }
}



+(void)getAlbumsPhotos:(NSString *)albumID withLimit:(int)limit WithCompletionBlock:(FBCompletionBlock)fbResult
{
    
    if (albumID) {
        if ([FBSDKAccessToken currentAccessToken]) {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"%@/photos?fields=source&limit=%d",albumID,limit] parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSArray *arrPhotos=[result objectForKey:@"data"];
                     fbResult(arrPhotos,nil);
                 }
                 else {
              //       DDLogVerbose(@"%@",error);
                     fbResult(nil,error);
                 }
                 
             }];
        }
        
    }
}

+(void)getUserAlbumsPhotosWithLimit:(int)limit WithCompletionBlock:(FBCompletionBlock)fbResult
{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"me/albums?fields=photos.limit(%d),id,cover_photo,from,name,count",limit] parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSArray *arrAlums = [result objectForKey:@"data"];
                 fbResult(arrAlums,nil);
             }
             else {
       //          DDLogVerbose(@"%@",error);
                 fbResult(nil,error);
             }
             
         }];
    }
}

+(void)uploadPhotosToAlbum:(NSDictionary *)params WithAlbumID:(NSString *)albumId WithCompletionBlock:(FBCompletionBlock)fbResult {
    if (params) {
                
        if ([FBSDKAccessToken currentAccessToken]) {
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@/photos",albumId] parameters:params  HTTPMethod:@"POST"]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     fbResult(result,nil);
                 }
                 else {
               //      DDLogVerbose(@"%@",error);
                     fbResult(nil,error);
                 }
                 
             }];
            
        }
    }
}

-(void)shareWithURL:(NSString *)urlString :(NSString *)imageUrl :(NSString *)contentTitle :(NSString *)contentDescription fromViewController:(UIViewController *)viewController {
    FBSDKShareLinkContent *contents = [[FBSDKShareLinkContent alloc] init];
    contents.contentURL = [NSURL URLWithString:urlString];
    contents.contentTitle = contentTitle;
    contents.contentDescription = contentDescription;
    contents.imageURL = [NSURL URLWithString:imageUrl];
    [FBSDKShareDialog showFromViewController:viewController
                                 withContent:contents
                                    delegate:self];
}


-(void)uploadImageToFacebook:(NSMutableDictionary *)params fromViewController:(UIViewController *)viewController {
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    UIImage *img = params[PICTURE_KEY_FB];
    photo.image = img;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    [FBSDKShareDialog showFromViewController:viewController
                                 withContent:content
                                    delegate:self];
}

-(void)uploadVideo:(NSDictionary *)params fromViewController:(UIViewController *)viewController {
    FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
    video.videoURL = params[VIDEO_NAME_KEY_FB];
    FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
    content.video = video;
    [FBSDKShareDialog showFromViewController:viewController
                                 withContent:content
                                    delegate:self];

}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    [self.delegate postSharedResponse:results];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    [self.delegate failResponse:error];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    [self.delegate postCancelledResponse];
}

+(NSString*)activeSessionToken
{
    NSString *fbAccessToken = [NSString stringWithFormat:@"%@",[FBSDKAccessToken currentAccessToken].tokenString];
    if(!fbAccessToken) {
    //    fbAccessToken = [[UserDefaultController getInstance] getFBToken];
    }

    /*   [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/1376462852683422/picture?type=album&access_token=%@",fbAccessToken]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
     DataController *dataObj=[DataController getInstance];
     [dataObj setObject:data forKey:@"YoMan"];
     }];*/
    return fbAccessToken;
    
}



@end
