//
//  RoomHeadView.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "RoomHeadView.h"
#import "RoomModel.h"

@interface RoomHeadView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;



@end

@implementation RoomHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"RoomHeadView" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

- (void)udpateWithModel:(RoomModel *)model {
    NSString *imageUrl = [ParseData parseImageUrl:model.pic];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
    self.nameLabel.text = model.shortname;
    self.descLabel.text = model.shortinstruction;
    [self addStarView:model.star];
}
- (void)addStarView:(NSString *)star {
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = nil;
        if (i < [star integerValue]) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_Generic_Detail_Star_HL"]];
        }else {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_Generic_Detail_Star"]];
        }
        imageView.frame = CGRectMake(i*(10+20), 0, 20, 20);
        [self.starBgView addSubview:imageView];
    }
}





@end
