//
//  EnumCollViewCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "EnumCollViewCell.h"
#import "InfoCollModel.h"

@interface EnumCollViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *materalLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) InfoCollModel *model;

@end
@implementation EnumCollViewCell


- (void)updateWithModel:(InfoCollModel *)model {
    self.model = model;
    NSString *imageUrl = [ParseData parseImageUrl:model.pic];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
    self.nameLabel.text = model.title;
    self.likeLabel.text = [NSString stringWithFormat:@"%ld人收藏",model.colnum];
    self.descLabel.text = model.short_content;
    self.materalLabel.text = [NSString stringWithFormat:@"%@人收藏",model.materal];
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
