//
//  HeadViewCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "HeadViewCell.h"
#import "HomeMmodel.h"


@interface HeadViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, strong) HomeMmodel *model;

@end

@implementation HeadViewCell


- (void)updateWithModel:(HomeMmodel *)model {
    self.model = model;
    NSString *imageUrl = [ParseData parseImageUrl:model.pic];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
    self.nameLabel.text = model.kname;
    self.titleLabel.text = model.title;
    self.descLabel.text = model.short_content;
    if (![model.has_video integerValue]) {
        self.playButton.hidden = YES;
    }else {
        self.playButton.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.width = KScreenWidth;
    
}

- (void)awakeFromNib {
    
}

@end
