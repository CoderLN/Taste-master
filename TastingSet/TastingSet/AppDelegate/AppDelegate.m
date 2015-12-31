//
//  AppDelegate.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "NetWorkReach.h"
//#import "UMSocial.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    RootViewController *rootVC = [[RootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    nav.navigationBar.hidden = YES;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    //友盟
//    [UMSocialData setAppKey:@"5641c4bd67e58ef51f003243"];
    
    //判断用户是否是第一次启动程序
    BOOL isFirstLauch = [[NSUserDefaults standardUserDefaults] boolForKey:@"isNoFirstLauch"];
    if (!isFirstLauch) {
        [self showChannelView];
    }
    
    
    //初始化网络判断
    NetWorkReach *netWorkReach = [NetWorkReach sharedInstance];
    [netWorkReach initNetwork];
    
    
    //获取用户信息
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:ISUSERLOGIN];
    if (isLogin) {
        [self getUserInfo];
    }
    
    return YES;
}

- (void)getUserInfo {
    NSError *error = nil;
    NSString *uid = [SSKeychain passwordForService:@"com.qianfeng.TastingSet" account:@"uid" error:&error];
    NSString *uuid = [SSKeychain passwordForService:@"com.qianfeng.TastingSet" account:@"uuid" error:&error];
    NSString *d_type = [SSKeychain passwordForService:@"com.qianfeng.TastingSet" account:@"d_type" error:&error];
    NSString *cid = [SSKeychain passwordForService:@"com.qianfeng.TastingSet" account:@"cid" error:&error];

    UserModel *userModel = [UserModel sharedInstance];
    userModel.uid = [uid integerValue];
    userModel.uuid = uuid;
    userModel.d_type = d_type;
    userModel.cid = cid;
}

//显示引导页
- (void)showChannelView {
    
    NSArray *arr=[NSArray arrayWithObjects:@"IMG_AD_1.png",@"IMG_AD_2.png",@"IMG_AD_3.png",@"IMG_AD_4.png",@"IMG_AD_5.png",nil];
    //通过scrollView 将这些图片添加在上面，从而达到滚动这些图片
    UIScrollView *scr=[[UIScrollView alloc] initWithFrame:self.window.bounds];
    scr.contentSize=CGSizeMake(KScreenWidth*arr.count, KScreenHeight);
    scr.pagingEnabled=YES;
    scr.tag = 7000;
    scr.bounces = NO;
    scr.showsHorizontalScrollIndicator = NO;
    [self.window addSubview:scr];
    for (int i=0; i<arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*KScreenWidth, 0, KScreenWidth, KScreenHeight)];
        NSString *path = [[NSBundle mainBundle] pathForResource:arr[i] ofType:nil];
        img.image=[UIImage imageWithContentsOfFile:path];
        if (i == arr.count - 1) {
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenLauchView)];
            img.userInteractionEnabled = YES;
            [img addGestureRecognizer:gesture];
        }
        [scr addSubview:img];
    }
}
- (void)hiddenLauchView {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNoFirstLauch"];
    
    UIScrollView *scrollView = (UIScrollView *)[self.window viewWithTag:7000];

    //设置滑动图消失的动画效果图
    [UIView animateWithDuration:1.0f animations:^{
        scrollView.alpha = 0;
    } completion:^(BOOL finished) {
        [scrollView removeFromSuperview];
    }];
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
