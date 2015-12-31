//
//  VideoPlayView.m
//  MyPlayerDemo
//
//  Created by lijinghua on 15/9/22.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import "VideoPlayView.h"

@implementation VideoPlayView

//要想让画面显示在view上，该view对应的layer必须为AVPlayerLayer
//要让一个view使用对应的layer，需要重写layerClass方法
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (void)setPlayer:(AVPlayer*)player
{
    AVPlayerLayer* layer = (AVPlayerLayer*)self.layer;
    //把layer的player属性设置为我们的播放器
    //这样播放器提供内容，layer负责渲染，这样view就可以显示出图像
    [layer setPlayer:player];
    //layer.videoGravity = AVLayerVideoGravityResize;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
