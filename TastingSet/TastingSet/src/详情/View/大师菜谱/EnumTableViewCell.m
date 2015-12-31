//
//  EnumTableViewCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "EnumTableViewCell.h"
#import "RoomModel.h"

@interface EnumTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *playView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic, strong) RoomModel *model;

@end

@implementation EnumTableViewCell

- (void)updateWithModel:(RoomModel *)model {
    self.model = model;
    NSString *imageUrl = [ParseData parseImageUrl:model.pic];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
    if ([model.has_video integerValue] != 1) {
        self.playView.hidden = YES;
    }else {
        self.playView.hidden = NO;
    }
    
    self.nameLabel.text = model.title;
    self.likeLabel.text = [NSString stringWithFormat:@"%ld人收藏",model.colnum];
    self.authorLabel.text = model.authorname;
    self.descLabel.text = model.materal;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    CGSize size = [NSStringUinity contentWithBody:self.likeLabel.text width:MAXFLOAT height:30 fontsize:11];
    self.likeLabel.width = size.width + 5;
    [self.likeLabel setMarginX:self.width-size.width - 20 ];
}


- (void)awakeFromNib {
    
}


@end
