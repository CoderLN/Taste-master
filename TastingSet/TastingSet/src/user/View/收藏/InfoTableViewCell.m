//
//  InfoTableViewCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "InfoTableViewCell.h"
#import "InfoCollModel.h"
#import "SearchModel.h"

@interface InfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic, strong) InfoCollModel *model;

@property (weak, nonatomic) IBOutlet UIView *bgView;



@end

@implementation InfoTableViewCell

- (void)updateWithModel:(InfoCollModel *)model {
    self.model = model;
    self.nameLabel.text = model.title;
    self.descLabel.text = model.short_content;
    NSString *imageUrl = model.pic;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[ParseData parseImageUrl:imageUrl]] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
}
- (void)udpateWithSearchModel:(SearchModel *)model {
    self.nameLabel.text = model.title;
    self.descLabel.text = model.content;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[ParseData parseImageUrl:model.pic]] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
}




- (void)showDeleteButton:(BOOL)res array:(NSMutableArray *)array {
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
