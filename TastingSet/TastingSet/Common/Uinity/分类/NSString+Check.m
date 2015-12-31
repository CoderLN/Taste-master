//
//  NSString+Check.m
//  TastingSet
//
//  Created by qianfeng on 15/11/3.
//  Copyright © 2015年 贵永冬. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)


-(BOOL)checkPhoneNumInput{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:self];
}

@end
