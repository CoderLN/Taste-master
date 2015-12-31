//
//  NSStringUinity.m
//  SiCook
//
//  Created by qianfeng on 15/10/17.
//  Copyright (c) 2015年 贵永冬. All rights reserved.
//

#import "NSStringUinity.h"

@implementation NSStringUinity

+ (CGSize)contentWithBody:(NSString*)body width:(CGFloat)width height:(CGFloat)height fontsize:(CGFloat)size
{
    //计算字符串占用的大小
    CGRect rect = [body boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    return rect.size;
}

@end
