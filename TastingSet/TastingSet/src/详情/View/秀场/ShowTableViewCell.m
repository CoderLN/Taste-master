//
//  ShowTableViewCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "ShowTableViewCell.h"
#import "ShowModel.h"

@interface ShowTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *userView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *otherUserLabel;

@property (nonatomic, strong) ShowModel *model;

@end

@implementation ShowTableViewCell


- (void)updateWithModel:(ShowModel *)model {
    self.model = model;
    NSString *imageUrl = [ParseData parseImageUrl:model.pic];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
    [self.userView sd_setImageWithURL:[NSURL URLWithString:[ParseData parseImageUrl:model.headimg]] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Avatar.png"]];
    self.userView.layer.cornerRadius = 18;
    self.userView.layer.masksToBounds = YES;
    self.usernameLabel.text = model.nickname;
    NSString *time = [self getTime:[model.addtime integerValue]];
    self.timeLabel.text = time;
    self.descLabel.text = model.title;
    NSMutableString *str = [NSMutableString string];
    for (NSString *s in model.pres) {
        [str appendString:[NSString stringWithFormat:@"%@,",s]];
    }
    self.otherUserLabel.text = str;
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


- (IBAction)likeButtonClick:(id)sender {
    if (self.delegate != nil) {
        [self.delegate likeButtonClick:self.model];
    }
}
- (IBAction)commentButtonClick:(id)sender {
    if (self.delegate != nil) {
        [self.delegate commentButtonClick:self.model];
    }
}
- (IBAction)moreButtonClick:(id)sender {
    if (self.delegate != nil) {
        [self.delegate moreButtonClick:self.model];
    }
}



@end
