//
//  AppDelegate.m
//  SampleMapDemo
//
//  Created by SitesSimply PTY. LTD on 21/10/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MapsSelector.h"
#import "VCLandiScreen.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UserDefaultController.h"
#import "VCLeftMenu.h"
#import "VCRightMenu.h"
#import "VCCenterDetails.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    	self.viewController = [[JASidePanelController alloc] init];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [GMSServices provideAPIKey:@"AIzaSyDsufJZAeoMspS5UCgRFSyEnhc0d8gCZIs"];
    [self decideLandingScreen];
    return YES;
}

-(void)decideLandingScreen {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UserDefaultController *obj = [UserDefaultController getInstance];
    [obj setUserDefaults];
    if([obj getCreateAccountCompleted]) {
        self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
        self.viewController.leftPanel = [[VCLeftMenu alloc] init];
        self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[VCCenterDetails alloc] init]];
        self.viewController.rightPanel = [[VCRightMenu alloc] init];
        self.window.rootViewController = self.viewController;
        [self.window makeKeyAndVisible];
        return;
    }
    VCLandiScreen *baseViewController = [[VCLandiScreen alloc] initWithNibName:@"VCLandiScreen" bundle:nil];
    self.window.rootViewController = baseViewController;
    self.navigationController=[[UINavigationController alloc] initWithRootViewController:baseViewController];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:baseViewController]];
    [self.window addSubview:[self.navigationController view]];
    [self.window makeKeyAndVisible];

    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

@end
