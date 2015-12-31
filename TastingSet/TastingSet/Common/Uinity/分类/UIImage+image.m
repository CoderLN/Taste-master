//
//  UIImage+image.m
//  堆糖
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 贵永冬. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (image)

+ (UIImage *)imageWithOriginal:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageWithOriginal:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

- (UIImage *)setTitle:(NSString *)text {
    //1.获取上下文
    UIGraphicsBeginImageContext(self.size);
    
    //2.绘制图片
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    //3.绘制文字
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    
    //文字的属性
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:14],
                          NSParagraphStyleAttributeName:style,
                          NSForegroundColorAttributeName:[UIColor whiteColor]
                        };
    //将文字绘制上去
    [text drawInRect:rect withAttributes:dic];
    
    //4.获取绘制到得图片
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.结束图片的绘制
    UIGraphicsEndImageContext();
    
    return watermarkImage;
}
- (UIImage *)addChildIMage:(UIImage *)image {
    
    CGSize size = CGSizeMake(image.size.width, image.size.height + self.size.height);
    
    //1.获取上下文
    UIGraphicsBeginImageContext(size);
    
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    //4.获取绘制到得图片
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.结束图片的绘制
    UIGraphicsEndImageContext();
    
    return watermarkImage;
}


+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}



@end
