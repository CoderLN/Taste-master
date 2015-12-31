//
//  NumberTableViewCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "NumberTableViewCell.h"
#import "ShowModel.h"

@interface NumberTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *numberLbael;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *otherView;

@end

@implementation NumberTableViewCell

- (void)updateWithModel:(ShowModel *)model number:(NSInteger )number {
    self.iconView.layer.cornerRadius = 18;
    self.iconView.layer.masksToBounds = YES;
    self.numberLbael.text = [NSString stringWithFormat:@"%ld.",number];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[ParseData parseImageUrl:model.headimg]] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Avatar.png"]];
    self.nameLabel.text = model.nickname;
    [self.otherView sd_setImageWithURL:[NSURL URLWithString:[ParseData parseImageUrl:model.pic]]];
}

@end
