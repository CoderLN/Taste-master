//
//  CustomActivityView.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "CustomActivityView.h"

@interface CustomActivityView ()



@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CustomActivityView

+ (instancetype)sharedInstance {
    static CustomActivityView *s_dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_dbManager = [[CustomActivityView alloc]init];
        [s_dbManager setFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [s_dbManager customAnimaView];
    });
    return s_dbManager;
}
- (void)customAnimaView {
    self.backgroundColor = [UIColor clearColor];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.imageView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i <12 ; i++) {
        NSString *str = [NSString stringWithFormat:@"Img_Loaing_ActivityIndicator_%d",i];
        UIImage *image = [UIImage imageNamed:str];
        [arr addObject:image];
    }
    self.imageView.animationImages = arr;
    //设定动画的播放时间
    self.imageView.animationDuration=1.0;
    //设定重复播放次数
    self.imageView.animationRepeatCount=0;
    [self addSubview:self.imageView];
}


+ (void)startAnimating {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CustomActivityView *activityView = [self sharedInstance];
    [window addSubview:activityView];
    [activityView.imageView startAnimating];
}

+ (void)stopAnimating {
    CustomActivityView *activityView = [self sharedInstance];
    [activityView.imageView stopAnimating];
    [activityView removeFromSuperview];
}


@end
