//
//  UIView+size.h
//  堆糖
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 贵永冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (size)

/**
 *  宽
 */
- (CGFloat)width;
/**
 *  高
 */
- (CGFloat)height;
/**
 *  最大左边距
 */
- (CGFloat)maxX;
/**
 *  最大上边距
 */
- (CGFloat)maxY;
/**
 *  设置左边距
 */
- (void)setMarginX:(CGFloat)marginX;
/**
 *  设置上边距
 */
- (void)setMarginY:(CGFloat)marginY;
/**
 *  设置宽
 */
- (void)setWidth:(CGFloat)width;
/**
 *  设置高
 */
- (void)setHeight:(CGFloat)height;
/**
 *  尺寸
 */
- (CGSize)size;
/**
 *  设置尺寸
 */
- (void)setSize:(CGSize)size;
@end
