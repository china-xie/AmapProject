//
//  AppDelegate.m
//  AMapProject
//
//  Created by xie on 2017/8/9.
//  Copyright © 2017年 xie. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "leftViewController.h"
#import "rightViewController.h"
#import "RESideMenu/RESideMenu.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AMapServices sharedServices].apiKey =@"6d139784ca245365da2c18be95fe3064";
   
    self.window= [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];

    leftViewController *leftMenuViewController = [[leftViewController alloc] init];
    rightViewController *rightMenuViewController = [[rightViewController alloc] init];
    
    // Create side menu controller
    //
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:rightMenuViewController];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"1.jpg"];
    
    sideMenuViewController.parallaxEnabled = YES;
    
   sideMenuViewController.parallaxMenuMinimumRelativeValue = -15;
    sideMenuViewController.parallaxMenuMaximumRelativeValue = 15;
    sideMenuViewController.parallaxContentMinimumRelativeValue = -25;
    sideMenuViewController.parallaxContentMaximumRelativeValue = 25;
//    sideMenuViewController.menuPreferredStatusBarStyle=1;// UIStatusBarStyleLightContent
    sideMenuViewController.contentViewShadowEnabled = NO;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeZero;
    sideMenuViewController.contentViewShadowOpacity = 0.4f;
    sideMenuViewController.contentViewShadowRadius = 8.0f;
//    sideMenuViewController.delegate=self;
    sideMenuViewController.contentViewInLandscapeOffsetCenterX = 30.f;
    sideMenuViewController.contentViewInPortraitOffsetCenterX  = 30.f;
    sideMenuViewController.scaleContentView = YES;
    sideMenuViewController.contentViewScaleValue = 1.0f;
    
//    sideMenuViewController.contentViewShadowColor= [UIColor blackColor];
//    
//    sideMenuViewController.contentViewShadowOffset=CGSizeMake(0,0);
//    
//    sideMenuViewController.contentViewShadowOpacity=0.6;
//    
//    sideMenuViewController.contentViewShadowRadius=12;
//    
//    sideMenuViewController.contentViewShadowEnabled=NO;
    
    self.window.rootViewController= sideMenuViewController;
    
    self.window.backgroundColor= [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
