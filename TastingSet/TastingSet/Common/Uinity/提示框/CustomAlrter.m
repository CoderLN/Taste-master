//
//  CustomAlrter.m
//  TastingSet
//
//  Created by qianfeng on 15/11/4.
//  Copyright © 2015年 贵永冬. All rights reserved.
//

#import "CustomAlrter.h"

@implementation CustomAlrter

+ (void)showSuccessMessage:(NSString *)str time:(NSInteger)time {
    [WSProgressHUD setProgressHUDFont:[UIFont systemFontOfSize:16]];
    [WSProgressHUD showSuccessWithStatus:str];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
}

+ (void)showMessage:(NSString *)str time:(NSInteger)time {
    [WSProgressHUD setProgressHUDFont:[UIFont systemFontOfSize:16]];
    [WSProgressHUD showWithStatus:str];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
}


+ (void)showFailedMessage:(NSString *)str time:(NSInteger)time {
    [WSProgressHUD setProgressHUDFont:[UIFont systemFontOfSize:16]];
    [WSProgressHUD showErrorWithStatus:str];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
}


@end
