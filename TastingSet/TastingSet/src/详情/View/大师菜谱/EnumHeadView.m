//
//  EnumHeadView.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "EnumHeadView.h"
#import "RoomModel.h"

@interface EnumHeadView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation EnumHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"EnumHeadView" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

- (void)udpateWithModel:(RoomModel *)model {
    NSString *imageUrl = [ParseData parseImageUrl:model.pic];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
    self.nameLabel.text = model.title;
    self.numberLabel.text = [NSString stringWithFormat:@"%@人份",model.people];
    self.descLabel.text = [NSString stringWithFormat:@"准备：%@   制作：%@",model.pretime,model.maketime];
    self.fromLabel.text = model.authorname;
    self.titleLabel.text = model.kname;
}

@end
