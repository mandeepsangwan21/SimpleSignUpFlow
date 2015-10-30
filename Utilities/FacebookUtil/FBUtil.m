//
//  FBUtil.m
//  FacebookLibrary
//
//  Created by Parul Jain on 07/04/15.
//  Copyright (c) 2015 Parul Jain. All rights reserved.
//

#import "FBUtil.h"
#import <FacebookSDK/FacebookSDK.h>
//#import "MatchstixAppDelegate.h"
//#import "ViewUtilities.h"
//#import "DDLog.h"
//#import "UserDefaultController.h"
//#if DEBUG
//static const int ddLogLevel = LOG_LEVEL_VERBOSE;
//#else
//static const int ddLogLevel = LOG_LEVEL_WARN;
//#endif
NSString *const PICTURE_KEY = @"picture";
NSString *const CAPTION_KEY = @"message";
NSString *const PARAMS_KEY = @"params";
NSString *const IMAGE_KEY = @"image";
NSString *const VIDEO_NAME_KEY = @"video.mp4";
NSString *const DESCRIPTION_KEY = @"description";
NSString *const PROFILE_IMAGE_KEY = @"profileImage";
NSString *const IS_SILHOUETTE = @"is_silhouette";

@implementation FBUtil

//@"user_location",@"user_hometown",@"user_about_me",@"user_relationships",@"user_relationship_details",@"user_friends",@"publish_actions",@"user_likes",@"user_photos",@"user_about_me",@"user_birthday",@"email"
//

/*
 *@author - Parul Jain
 *get permissions from facebook
*/
+(NSArray *)getPermissionsArray
{
    static NSArray *permissions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
     permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"user_birthday",@"email",@"user_photos",nil];
         });
      return permissions;
    
}


/*
 *@author- Parul Jain
 *logout facebook 
 */


+(void)logOutFromFacebook
{
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
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

/*
 *@author- Parul Jain
 *login facebook with permissions
 */
+(void)loginWithFaceBookWithCompletionBlock:(FBCompletionBlock)fbResult {
    

    [FBSettings enablePlatformCompatibility:false];
    [[FBRequest requestForMe] overrideVersionPartWith:@"v2.3"];
    if(FBSession.activeSession.state == FBSessionStateOpen) {
        
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    
  //  DDLogVerbose( @"### running FB sdk version: %@", [FBSettings sdkVersion] );
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:[self getPermissionsArray]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [FBUtil sessionStateChanged:session state:state error:error WithCompletionBlock:^(id response, NSError *error){
                                 if (!error) {
                                    fbResult(response,nil);

                                 }
                                 else{
                                     fbResult(nil,error);
                                 }
                             }];
         }];
    }
    
}


+(void)sessionStateChanged :(FBSession *)session state:(FBSessionState) state error:(NSError *)error WithCompletionBlock:(FBCompletionBlock)fbResult
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
//        DDLogVerbose(@"Session opened");
        // Show the user the logged-in UI
        [self loginWithFBUserInfoWithCompletionBlock:^(id response, NSError *error){
                            if (!error) {
                                 fbResult(response,nil);
                            }
                            else{
                             fbResult(nil,error);
                            }
                        }];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
//        DDLogVerbose(@"Session closed");
        fbResult(nil,error);
    }
    
    // Handle errors
    if (error){
//        DDLogVerbose(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
//            [ViewUtilities showAlert:alertTitle :alertText];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
//                DDLogVerbose(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
//                [ViewUtilities showAlert:alertTitle :alertText];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
//                [ViewUtilities showAlert:alertTitle :alertText];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        fbResult(nil,error);
    }
    
}

+(void)loginWithFBUserInfoWithCompletionBlock:(FBCompletionBlock)fbResult
{
    
//     [[FBRequest requestForMe] startWithCompletionHandler:   ^(FBRequestConnection *connection,  NSDictionary<FBGraphUser> *user,  NSError *error)
    FBRequest* request = [[FBRequest alloc]initWithSession:FBSession.activeSession graphPath:[NSString stringWithFormat:@"me?fields=id,first_name,gender,last_name,name,link,birthday,email"]];
    [request startWithCompletionHandler:   ^(FBRequestConnection *connection,  NSDictionary<FBGraphUser> *user,  NSError *error)
     {
         if (error)
         {
             fbResult(nil,error);
//             DDLogVerbose(@"%@",error);
         }
         else
         {
            //get the user facebook profile-picture
            // NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectID]];             
//             NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=800&height=800", [user objectID]];
             [self getProfilePicture:[user objectID] WithCompletionBlock:^(NSDictionary* result, NSError *error) {
                 [user setObject:[result valueForKey:@"url"] forKey:PROFILE_IMAGE_KEY];
                 [user setObject:[result valueForKey:IS_SILHOUETTE] forKey:IS_SILHOUETTE];
                 fbResult(user,nil);
             }];
             //             [user setObject:userImageURL forKey:PROFILE_IMAGE_KEY];
            // fbResult(user,nil);
         }
     }];
    return;
}

+(void)getProfilePicture:(NSString *)userId WithCompletionBlock:(FBCompletionBlock)fbResult
{
    FBRequest* friendsRequest = [[FBRequest alloc]initWithSession:FBSession.activeSession graphPath:[NSString stringWithFormat:@"/%@/picture?width=800&height=800&redirect=false",userId]];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error)
     {
         if (!error) {
             NSDictionary *picDetailDict = [result objectForKey:@"data"];
             fbResult(picDetailDict,nil);
         }
         else{
             fbResult(nil,error);
         }
     }];
}

/*
 *@author - Parul Jain
 *get the user's friends detail who also use the app.
 *parameters :
 */
+ (void)fetchFriendsWithFBFriendCompletionBlock:(FBFriendCompletionBlock)fbFriends {
    [self getFriendsFriends:@"me" WithLimit:200 WithCompletionBlock:^(id response, NSError *error) {
        if (response) {
            fbFriends(response,nil);
        }
        else {
            fbFriends(nil,error);
        }
     
    }];
}

/*
 *@author - Parul Jain
 *get the user's friends detail who also use the app.
 *parameters : NSString(userID), int(limit)
 */
+(void)getFriendsFriends:(NSString *)userID WithLimit:(int)limit WithCompletionBlock:(FBCompletionBlock)fbResult
{
    if (FBSession.activeSession.isOpen) {
    FBRequest* friendsRequest = [[FBRequest alloc]initWithSession:FBSession.activeSession graphPath:[NSString stringWithFormat:@"%@/friends?fields=picture.type(large),name&limit=%d",userID,limit]];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error)
     {
         if (!error) {
             NSArray* friends = [result objectForKey:@"data"];
             fbResult(friends,nil);
         }
         else{
             fbResult(nil,error);
         }
     }];
    }
    else {
        
    }
}

/*
 *@author - Parul Jain
 *get the user's Album With Last Photo
 *parameters :
 */
+(void)getUserAlbumsListWithLastPhotoCompletionBlock:(FBCompletionBlock)fbResult
{
    FBRequest* friendsRequest = [[FBRequest alloc]initWithSession:FBSession.activeSession graphPath:[NSString stringWithFormat:@"me/albums?fields=photos.limit(1),id,cover_photo,from,name,count"]];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error)
     {
         if (!error) {
             NSArray *arrAlums=[result objectForKey:@"data"];
             fbResult(arrAlums,nil);
         }
         else{
             fbResult(nil,error);
         }
     }];
}

/*
 *@author - Parul Jain
 *get the user's facebook Album details
 *parameters :
 */
+(void)getUserAlbumsWithCompletionBlock:(FBCompletionBlock)fbResult
{
    FBRequest* friendsRequest = [[FBRequest alloc]initWithSession:FBSession.activeSession graphPath:[NSString stringWithFormat:@"me/albums/?fields=cover_photo,name,count"]];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error)
     {
         if (!error) {
             NSArray *arrAlums=[result objectForKey:@"data"];
             fbResult(arrAlums,nil);
         }
         else{
             fbResult(nil,error);
         }
     }];
}

/*
 *@author - Parul Jain
 *get the user's facebook Profile picture Album details
 *parameters :
 */
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
            fbResult(nil,error);
        }
    }];
}


/*
 *@author - Parul Jain
 *get the user's facebook Album Photos
 *parameters :NSString(albumID)
 */

+(void)getAlbumsPhotos:(NSString *)albumID WithCompletionBlock:(FBCompletionBlock)fbResult
{
    FBRequest* friendsRequest = [[FBRequest alloc]initWithSession:FBSession.activeSession graphPath:[NSString stringWithFormat:@"%@/photos?fields=source",albumID]];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error)
     {
         if (!error) {
             NSArray *arrPhotos=[result objectForKey:@"data"];
             fbResult(arrPhotos,nil);
         }
         else{
             fbResult(nil,error);
         }
     }];
}


/*
 *@author - Parul Jain
 *get the user's facebook Album Photos with particular limit
 *parameters :NSString(albumID) ,int(limit)
 */
+(void)getAlbumsPhotos:(NSString *)albumID withLimit:(int)limit WithCompletionBlock:(FBCompletionBlock)fbResult
{
    FBRequest* friendsRequest = [[FBRequest alloc]initWithSession:FBSession.activeSession graphPath:[NSString stringWithFormat:@"%@/photos?fields=source&limit=%d",albumID,limit]];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error)
     {
         if (!error) {
             NSArray *arrPhotos=[result objectForKey:@"data"];
             fbResult(arrPhotos,error);
         }
         else{
             fbResult(nil,error);
         }
     }];
}


/*
 *@author - Parul Jain
 *share link to facebook
 *parameters :NSString(link),NSString(caption),NSString(caption)
 */
+(void)shareWithURL:(NSString *)urlString :(NSString *)caption :(NSString *)lResUrl withBlock:(FBCompletionBlock)fbResult {
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:urlString];
    params.caption = caption;
    params.picture = [NSURL URLWithString:lResUrl];
    // If the Facebook app is installed and we can present the share dialog
    if (![FBDialogs canPresentShareDialogWithParams:params]) {
        [FBDialogs presentShareDialogWithParams:params
                                    clientState:nil
                                        handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                            if (error) {
                                                fbResult(nil,error);
                                           //     DDLogVerbose(@"Error: %@", error.description);
                                                
                                                
                                            } else {
                                          //      DDLogVerbose(@"Success!");
                                                fbResult(results,nil);
                                                
                                            }
                                        }];
        
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Appname", @"name",
                                       caption, @"caption",
                                       urlString, @"link",
                                       lResUrl, @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                     //     DDLogVerbose(@"Error publishing story: %@", error.description);
                                                          fbResult(nil,error);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                        //      DDLogVerbose(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                           //       DDLogVerbose(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                           //       DDLogVerbose(@"result %@", result);
                                                                  fbResult(result,nil);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}



/*---Method for parsing URL parameters returned by the Feed Dialog. ----*/
+ (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

/*
 *@author - Parul Jain
 *upload Image to users wall through share dialog
 *parameters :NSDictionary(image,caption)
*/
+(void)uploadImageWithShareDialog:(NSDictionary *)paramsDict withBlock:(FBCompletionBlock)fbResult{
    
    if([FBDialogs canPresentShareDialogWithPhotos]) {
    //    DDLogVerbose(@"canPresent");
        FBPhotoParams *params = [[FBPhotoParams alloc] init];
        UIImage *img = paramsDict[IMAGE_KEY];
        params.photos = @[img];
        [FBDialogs presentShareDialogWithPhotoParams:params
                                         clientState:nil
                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                 if (error) {
                                                     fbResult(nil,error);
                                               //      DDLogVerbose(@"Error: %@", error.description);
                                                 

                                                  } else {
                                               //      DDLogVerbose(@"Success!");
                                                     fbResult(results,nil);
                                                    
                                                 }
                                             }];
    }
}


/*
 *@author - Parul Jain
 *upload Image to users wall without share dialog
 *parameters :NSDictionary(image,caption)
 */
+(void)uploadImageToFacebook:(NSDictionary *)params withBlock:(FBCompletionBlock)fbResult{
    if (params) {
        
        NSArray* permissions = [NSArray arrayWithObjects:@"publish_actions", @"photo_upload",nil];
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceOnlyMe allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (!error) {
                [FBRequestConnection startWithGraphPath:@"me/photos"
                                             parameters:params
                                             HTTPMethod:@"POST"
                                      completionHandler:^(FBRequestConnection *connection,
                                                          id result,
                                                          NSError *error)
                 {
                     if (error) {
                         fbResult(nil,error);
                      } else {
                         fbResult(result,nil);
                      }
                 }];
            } else {
                fbResult(nil,error);
           //     DDLogVerbose(@"Error: %@", error.description);
            }
        }];
    }
    
}

#pragma mark - upload Video to facebook
/*
 *@author : Parul Jain
 *method to upload video to facebook
 *@params :->
 *videoData : @"video.mov",
 *@"video/quicktime": @"contentType",
 *@"Video Test Title": @"title",
 *@"Video Test Description": @"description",
 */

+(void)uploadVideo:(NSDictionary *)params WithCompletionBlock:(FBCompletionBlock)fbResult{
    NSArray *permissions = @[@"publish_stream",@"video_upload",@"publish_actions"];
    
    [FBSession openActiveSessionWithPublishPermissions:permissions
                                       defaultAudience:FBSessionDefaultAudienceEveryone
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                         /* handle success + failure in block */
                                         if(!error){
                                        //     DDLogVerbose(@"Success, upload starting");
                                             
                                             [self upload:params WithCompletionBlock:^(id response, NSError *error){
                                                         if (!error) {
                                                             /*if not error the video is uploaded*/
                                                        //      DDLogVerbose(@"%@",response);
                                                              fbResult(response,nil);
                                                         }
                                                         else{
                                                             /*if error then show error message*/
                                                             fbResult(nil,error);
                                                         }
                                             }];
                                         } else{
                                            fbResult(nil,error);
                                     //       DDLogVerbose(@"Write session failed");
                                         }
                                     }];
    
}

/*upload Video to facebook of mp4 Type make sure the video is in mp4 type else change internal details*/
+ (void)upload:(NSDictionary *)params WithCompletionBlock:(FBCompletionBlock)fbResult {
    
    /*Checks for connection open or not*/
    if (FBSession.activeSession.isOpen) {
        
        /*makes a request connection @found by babul*/
        [FBRequestConnection startWithGraphPath:@"me/videos" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            FBRequest *uploadRequest = [FBRequest requestWithGraphPath:@"me/videos"
                                                            parameters:params
                                                            HTTPMethod:@"POST"];
            /*uploads request*/
            [uploadRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    /*if not error the video is uploaded*/
             //       DDLogVerbose(@"Done: %@", result);
                    fbResult(result,nil);
                }
                else{
                    /*if error then show error message*/
               //     DDLogVerbose(@"Facebook video upload Error: %@", error.localizedDescription);
                    fbResult(nil,error);
                }
                
            }];
        }];
        
    }
}


+(NSString*)activeSessionToken
{
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
     /*   [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/1376462852683422/picture?type=album&access_token=%@",fbAccessToken]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        DataController *dataObj=[DataController getInstance];
        [dataObj setObject:data forKey:@"YoMan"];
    }];*/
    return fbAccessToken;
    
}

+(void)getMutualLikesAndFriendsForUserID:(NSString *)userID WithCompletionBlock:(FBCompletionBlock)fbResult
{
   
    FBRequest* friendsRequest = [[FBRequest alloc]initWithSession:[FBSession activeSession] graphPath:[NSString stringWithFormat:@"%@?fields=context.fields(mutual_likes,mutual_friends)",userID]];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error)
     {
         if (!error) {
             NSDictionary *mutualLikesDict = [result valueForKey:@"mutual_likes"];
             fbResult(mutualLikesDict,error);
             
         }
         else{
             fbResult(nil,error);
         }
     }];
}

+(void)getUserInterestPhotoFromFacebook:(NSString *)interestID WithCompletionBlock:(FBCompletionBlock)fbResult
{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:graph.facebook.com/%@/picture?type=small&access_token=%@",interestID,[self activeSessionToken]]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error) {
            fbResult(response,nil);
        }
        else{
            fbResult(nil,error);
        }

    }];

 
}

@end
