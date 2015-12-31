//
//  PlayViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "PlayViewController.h"
#import "VideoPlayView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface PlayViewController ()

@property (weak, nonatomic) IBOutlet VideoPlayView *playView;
//播放器，由他执行实际的播放
@property(nonatomic)AVPlayer *player;
@property (nonatomic) AVPlayerItem *playerItem;

@property(nonatomic)MPMoviePlayerViewController *mp;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CustomActivityView startAnimating];
    [self play];
}
- (IBAction)gotoBack:(id)sender {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)play {
    if(self.player != nil){
        //对于处于播放状态的播放器，再次调用play无影响
        [self.player play];
        return;
    }
    
    //AVURLAsset 代表一个播放的资源，可以使音频，可以是视频，可以是本地的，也可以是网络的
    AVURLAsset *netAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:self.playUrl]];
    
    //AVPlayerItem 是对资源的整体描述，可以获取资源的状态，可以得到资源长度等信心，使用AVURLAsset进行初始化
    self.playerItem = [[AVPlayerItem alloc]initWithAsset:netAsset];
    
    //生成播放器，使用AVPlayerItem进行初始化的时候，会对资源进行预加载分析
    //这个过程会修改playerItem的状态
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    //图像显示，需要播放器和layer关联起来
    [self.playView setPlayer:self.player];
    
    //使用kvo来检测playerItem 的状态信息，只有当状态变为ReadToPlay才可以播放资源
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //关注播放结束的通知,关注通知AVPlayerItemDidPlayToEndTimeNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
- (void)playEnd:(NSNotification*)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem*)object;
        if( playerItem.status == AVPlayerItemStatusReadyToPlay )
        {
            //资源已经准备好播放
            [self.player play];
            [CustomActivityView stopAnimating];

            [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                
            }];
        }else{
            [CustomActivityView stopAnimating];
            [CustomAlrter showFailedMessage:@"播放失败" time:2.0];
        }
    }
}




@end
