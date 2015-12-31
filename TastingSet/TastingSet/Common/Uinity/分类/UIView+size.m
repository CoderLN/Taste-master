//
//  UIView+size.m
//  堆糖
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 贵永冬. All rights reserved.
//

#import "UIView+size.h"

@implementation UIView (size)

- (CGFloat)width {
    return self.frame.size.width;
}
- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
- (void)setMarginX:(CGFloat)marginX {
    CGRect rect = self.frame;
    rect.origin.x = marginX;
    self.frame = rect;
}
- (void)setMarginY:(CGFloat)marginY {
    CGRect rect = self.frame;
    rect.origin.y = marginY;
    self.frame = rect;
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}


@end
