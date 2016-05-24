//
//  AppDelegate.m
//  AAAfanTi
//
//  Created by 尾巴超大号 on 16/2/19.
//  Copyright © 2016年 马了个马里奥. All rights reserved.
//

#import "AppDelegate.h"
#import "AFanTiNavigationController.h"
#import "ViewController.h"
#import "RESideMenu.h"
#import "SlideViewController.h"
#import "sqlite3.h"
#import "NSMutableDictionary+extension.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQhandler.h"
#import "JPUSHService.h"
#define DATABASENAME @"afanti.sqlite"

@interface AppDelegate ()

@property (nonatomic, readwrite, assign) sqlite3 *database;

@property (nonatomic, readwrite, assign) NSInteger type;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    [self.window makeKeyAndVisible];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
        [self createDatabase];
        [self createTable];
        [self insertData];
    }else{
        [self createDatabase];
        [self search];
    }
    
    application.applicationIconBadgeNumber = 0;
    
    ViewController *view = [[ViewController alloc]init];
    view.type = _type;
    AFanTiNavigationController *controller = [[AFanTiNavigationController alloc]initWithRootViewController:view];
    SlideViewController *leftViewController = [[SlideViewController alloc]init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc]initWithContentViewController:controller leftMenuViewController:leftViewController rightMenuViewController:nil];
    sideMenuViewController.scaleBackgroundImageView = NO;
    sideMenuViewController.scaleContentView = NO;
    sideMenuViewController.scaleMenuView = NO;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.3;
    sideMenuViewController.contentViewShadowRadius = 6;
    sideMenuViewController.contentViewShadowEnabled = YES;
    sideMenuViewController.contentViewInPortraitOffsetCenterX = 100;
    [self.window setRootViewController:sideMenuViewController];
    
#pragma mark - share
    [UMSocialData setAppKey:@"56a22f34e0f55aff5e000e7f"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1018861672" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialWechatHandler setWXAppId:@"wx5db2847b8e5ba43d" appSecret:@"e4fc15c11c106caae15eac0b70ec55ed" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"1105180446" appKey:@"NPRGlpeZAHntZpUa" url:@"http://www.umeng.com/social"];
    
#pragma mark - jpush
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:@"f48ee054a249206de8129d37" channel:@"App Store" apsForProduction:NO];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - share
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == false) {
        
    }
    return result;
}

#pragma mark create database
- (void)createDatabase
{
    NSString *database_path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DATABASENAME];
    if (sqlite3_open([database_path UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"database open failed");
    }
}

#pragma mark - create table
- (void)createTable
{
    NSString *createChannel = @"CREATE TABLE IF NOT EXISTS channel (type INTEGER,title TEXT,mine INTEGER,idx INTEGER,style INTEGER)";
    [self execSql:createChannel];
    
    NSString *createCollection = @"CREATE TABLE IF NOT EXISTS collection (id INTEGER PRIMARY KEY,readNum INTEGER,title TEXT,images TEXT,createtime TEXT)";
    [self execSql:createCollection];
    
    NSString *createCache = @"CREATE TABLE IF NOT EXISTS cache (idx INTEGER PRIMARY KEY,type INTEGER,readNum INTEGER,isCollected INTEGER,title TEXT,images TEXT,createtime TEXT)";
    [self execSql:createCache];
}

- (void)insertData
{
    NSString *first = [NSString stringWithFormat:@"INSERT INTO '%@' (type,title,mine,idx,style) VALUES(%d,'%@',%d,%d,%d)",@"channel",0,@"精品资讯",1,0,0];
    NSString *second = [NSString stringWithFormat:@"INSERT INTO '%@' (type,title,mine,idx,style) VALUES(%d,'%@',%d,%d,%d)",@"channel",1,@"作品回顾",1,1,1];
    NSString *third = [NSString stringWithFormat:@"INSERT INTO '%@' (type,title,mine,idx,style) VALUES(%d,'%@',%d,%d,%d)",@"channel",2,@"摄影技巧",1,2,2];
    NSString *forth = [NSString stringWithFormat:@"INSERT INTO '%@' (type,title,mine,idx,style) VALUES(%d,'%@',%d,%d,%d)",@"channel",3,@"旅游知识",1,3,3];
    [self execSql:first];
    [self execSql:second];
    [self execSql:third];
    [self execSql:forth];
}

- (void)search
{
    NSString *searchSQL = [NSString stringWithFormat:@"SELECT * FROM channel WHERE idx=%d",0];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [searchSQL UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSInteger type = sqlite3_column_int(statement, 0);
            _type = type;
        }
        sqlite3_finalize(statement);
    }
}

#pragma mark - sqlite3 exec
- (void)execSql:(NSString *)sql
{
    char *error;
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"     error:%s",error);
    }
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
