//
//  VideoPlayView.h
//  MyPlayerDemo
//
//  Created by lijinghua on 15/9/22.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayView : UIView

//设置AVPlayer和AVPlayerLayer之间的关联
- (void)setPlayer:(AVPlayer*)player;
@end
