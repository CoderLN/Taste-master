//
//  ShowDetailCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "ShowDetailCell.h"

@interface ShowDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation ShowDetailCell

- (void)updateWithDic:(NSDictionary *)dic {
    NSString *imageStr = [dic objectForKey:@"headimg"];
    self.iconView.layer.cornerRadius = 25;
    self.iconView.layer.masksToBounds = YES;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[ParseData parseImageUrl:imageStr]] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Avatar.png"]];
    self.nameLabel.text = [dic objectForKey:@"nickname"];
    self.commentLabel.text = [dic objectForKey:@"content"];
    self.timeLabel.text = [self getTime:[[dic objectForKey:@"addtime"] integerValue]];
}
- (NSString *)getTime:(NSTimeInterval )lasttime {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval time2 = time - lasttime;
    
    int days= (int)(time2/(3600*24));
    int hours= ((int)time2)%(3600*24)/3600;
    int Minutes= (int)(time2)/60%60;
    if (days == 0 && hours == 0) {
        return [NSString stringWithFormat:@"%d分钟前",Minutes];
    }
    if (days == 0) {
        return [NSString stringWithFormat:@"%d小时前",hours];
    }else {
        return [NSString stringWithFormat:@"%d天前",days];
    }
}


@end
