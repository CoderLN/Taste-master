//
//  UserTableViewCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "UserTableViewCell.h"
#import "UserModel.h"

@interface UserTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic, strong) UserModel *model;

@end

@implementation UserTableViewCell
- (IBAction)addCommentButtonClick:(id)sender {
    ((UIButton *)sender).selected = !((UIButton *)sender).selected;
    if (self.delegate != nil) {
        [self.delegate addCommentButtonClick:self.model cancel:((UIButton *)sender).selected ];
    }
}

- (void)updateWithModel:(UserModel *)model {
    self.model = model;
    NSString *imageStr = model.headimg;
    self.iconView.layer.cornerRadius = 25;
    self.iconView.layer.masksToBounds = YES;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[ParseData parseImageUrl:imageStr]] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Avatar.png"]];
    self.nameLabel.text = model.nickname;
    self.commentLabel.text = model.introduction;
}

@end
