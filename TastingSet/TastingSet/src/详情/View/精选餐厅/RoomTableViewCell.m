//
//  RoomTableViewCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "RoomTableViewCell.h"
#import "RoomModel.h"


@interface RoomTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UIView *starBgView;


@property (nonatomic, strong) RoomModel *model;

@end

@implementation RoomTableViewCell


- (void)updateWithModel:(RoomModel *)model {
    self.model = model;
    NSString *imageUrl = [ParseData parseImageUrl:model.pic];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
    self.nameLabel.text = model.name;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld人喜欢",model.colnum];
    self.moneyLabel.text = [NSString stringWithFormat:@"人均：%@%@%@",model.avgprice,@"  ",model.provineName];
    self.desLabel.text = model.shortinstruction;
    
    
    [self addStarView];
    [self setNeedsLayout];
}
- (void)addStarView {
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = nil;
        if (i < [self.model.star integerValue]) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_Generic_Detail_Star_HL"]];
        }else {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_Generic_Detail_Star"]];
        }
        imageView.frame = CGRectMake(i*(10+25), 0, 25, 25);
        [self.starBgView addSubview:imageView];
    }
}

- (void)layoutSubviews {
    CGSize size = [NSStringUinity contentWithBody:self.likeCountLabel.text width:MAXFLOAT height:30 fontsize:11];
    self.likeCountLabel.width = size.width + 5;
    [self.likeCountLabel setMarginX:self.width-size.width - 20 ];
}





@end
