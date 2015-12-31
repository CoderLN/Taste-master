//
//  BottomView.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "BottomView.h"
#import "HomeMmodel.h"


@interface BottomView ()
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BottomView" owner:nil options:nil] lastObject];
        self.frame = frame;
        [self customUI];
    }
    return self;
}
- (void)customUI {
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoRoom)];
    self.firstImageView.userInteractionEnabled = YES;
    [self.firstImageView addGestureRecognizer:gesture1];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoEnum)];
    self.secondImageView.userInteractionEnabled = YES;
    [self.secondImageView addGestureRecognizer:gesture2];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoShow)];
    self.thirdImageView.userInteractionEnabled = YES;
    [self.thirdImageView addGestureRecognizer:gesture3];
}
- (void)gotoRoom {
    if (self.delegate != nil) {
        [self.delegate gotoRoom];
    }
}
- (void)gotoEnum {
    if (self.delegate != nil) {
        [self.delegate gotoEnum];
    }
}
- (void)gotoShow {
    if (self.delegate != nil) {
        [self.delegate gotoShow];
    }
}



- (void)updateWithArray:(NSArray *)array {
    HomeMmodel *model1 = array[4];
    NSString *imageUrl1 = [ParseData parseImageUrl:model1.pic];
    [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl1] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
    
    HomeMmodel *model2 = array[3];
    NSString *imageUrl2 = [ParseData parseImageUrl:model2.pic];
    [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl2] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
    
    HomeMmodel *model3 = array[1];
    NSString *imageUrl3 = [ParseData parseImageUrl:model3.pic];
    [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl3] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Detail"]];
}




@end
