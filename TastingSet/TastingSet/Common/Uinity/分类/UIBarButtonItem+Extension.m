//
//  UIImage+image.h
//  堆糖
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 贵永冬. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
/**
 *  穿件UIBarButtonItem(内部是按钮)
 *
 */
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action title:(NSString *)title {
    UIButton *button = [[UIButton alloc] init];
    if (imageName != nil) {
        [button setBackgroundImage:[UIImage imageWithOriginal:imageName] forState:UIControlStateNormal];
    }
    if (highImageName != nil) {
        [button setBackgroundImage:[UIImage imageWithOriginal:highImageName] forState:UIControlStateHighlighted];
    }
    // 设置按钮的尺寸为背景图片的尺寸
    button.size = CGSizeMake(25, 25);
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}




@end
