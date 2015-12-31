//
//  CustomAlrter.h
//  TastingSet
//
//  Created by qianfeng on 15/11/4.
//  Copyright © 2015年 贵永冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomAlrter : NSObject


+ (void)showSuccessMessage:(NSString *)str time:(NSInteger)time;
+ (void)showFailedMessage:(NSString *)str time:(NSInteger)time;
+ (void)showMessage:(NSString *)str time:(NSInteger)time;

@end
