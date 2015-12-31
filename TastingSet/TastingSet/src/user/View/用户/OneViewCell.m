//
//  OneViewCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "OneViewCell.h"


@interface OneViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@property (nonatomic, strong) NSDictionary *dic;

@end

@implementation OneViewCell




- (void)updateWithDic:(NSDictionary *)dic {
    NSArray *arr = [dic objectForKey:@"res"];
    if (arr.count == 0) {
        self.firstLabel.text = @"0";
        self.twoLabel.text = @"0";
        self.thirdLabel.text = @"0";
        return;
    }
    //我的
    self.dic = dic;
    
    self.firstLabel.text = [arr[0] objectForKey:@"num"];
    self.twoLabel.text = [arr[2] objectForKey:@"num"];
    self.thirdLabel.text = [arr[1] objectForKey:@"num"];
    
}
- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    if (self.delegate != nil) {
        [self.delegate collectButtonClick:tag];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
