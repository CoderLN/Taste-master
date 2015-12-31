//
//  UIImage+image.h
//  堆糖
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 贵永冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image)

/**
 *  原图输出图片
 *
 */
+ (UIImage *)imageWithOriginal:(NSString *)imageName;
/**
 *  拉伸图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/**
 *  给图片添加文字
 */
- (UIImage *)setTitle:(NSString *)text;

/**
 *  给图片添加图片
 */
- (UIImage *)addChildIMage:(UIImage *)image;

/**
 *压缩图片
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;




@end
