//
//  RoomCollViewCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "RoomCollViewCell.h"
#import "InfoCollModel.h"

@interface RoomCollViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *starBGView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) InfoCollModel *model;

@end

@implementation RoomCollViewCell

- (void)updateWithModel:(InfoCollModel *)model {
    self.model = model;
    NSString *imageUrl = [ParseData parseImageUrl:model.pic];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"人均：%@",model.avgprice];
    [self addStarView:model];
}
- (void)addStarView:(InfoCollModel *)model {
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = nil;
        if (i < [model.star integerValue]) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_Generic_Detail_Star_HL"]];
        }else {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_Generic_Detail_Star"]];
        }
        imageView.frame = CGRectMake(i*(10+20), 2, 25, 25);
        [self.starBGView addSubview:imageView];
    }
}
- (void)showDeleteButton:(BOOL)res array:(NSMutableArray *)array{
    self.deleteArray = array;
    if (res) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 700;
        [self addSubview:view];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteButtonClick)];
        [view addGestureRecognizer:gesture];
        [UIView animateWithDuration:0.3 animations:^{
            [self.bgView setMarginX:60];
        }];
    }else {
        self.deleteButton.selected = NO;
        UIView *view = [self viewWithTag:700];
        [view removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            [self.bgView setMarginX:0];
        }];
    }
}
- (void)deleteButtonClick {
    self.deleteButton.selected = !self.deleteButton.selected;
    if (self.deleteButton.selected) {
        [self.deleteArray addObject:self.model.fid];
    }else {
        [self.deleteArray removeObject:self.model.fid];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
