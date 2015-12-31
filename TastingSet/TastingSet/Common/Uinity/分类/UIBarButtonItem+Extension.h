//
//  UIImage+image.h
//  堆糖
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 贵永冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
/**
 *  穿件UIBarButtonItem(内部是按钮)
 *
 */
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action title:(NSString *)title;

@end
