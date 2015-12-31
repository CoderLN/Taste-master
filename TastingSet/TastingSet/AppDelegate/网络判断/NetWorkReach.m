//
//  NetWorkReach.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "NetWorkReach.h"


#define kNetworkTestAddress @"www.baidu.com"

@interface NetWorkReach ()

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReachability;

@end

@implementation NetWorkReach


+ (instancetype)sharedInstance {
    static NetWorkReach *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[NetWorkReach alloc] init];
    });
    return sharedObject;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)initNetwork {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostname:kNetworkTestAddress];
    [self.hostReach startNotifier];
    [self updateInterfaceWithReachability:self.hostReach];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

- (void)reachabilityChanged:(NSNotification*) note {
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    self.isNoNetReachable = NO;
    if (reachability == self.hostReach)
    {
        BOOL connectionRequired = [reachability connectionRequired];
        
        if (connectionRequired) {
            [self showMessage:@"网络异常"];
            self.isNoNetReachable = YES;
        }else {
            self.isNoNetReachable = NO;
        }
    }else  {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        if (netStatus == NotReachable) {
            [self showMessage:@"网络异常"];
            self.isNoNetReachable = YES;
        }else {
            self.isNoNetReachable = NO;
        }
    }
}
//显示错误信息
- (void)showMessage:(NSString *)str {
    [WSProgressHUD setProgressHUDFont:[UIFont systemFontOfSize:16]];
    [WSProgressHUD showErrorWithStatus:str];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
}



@end
