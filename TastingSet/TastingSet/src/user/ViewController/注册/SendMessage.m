//
//  SendMessage.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "SendMessage.h"

@interface SendMessage ()

@property (weak, nonatomic) IBOutlet UILabel *telNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *checkNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *SubmitButton;

@end

@implementation SendMessage

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SendMessage" owner:nil options:nil] lastObject];
        self.frame = frame;
        [self customUI];
    }
    return self;
}
- (void)customUI {
    self.SubmitButton.layer.cornerRadius = 5.0;
    self.SubmitButton.layer.masksToBounds = YES;
}


- (void)setTelNumber:(NSString *)telNumber {
    _telNumber = telNumber;
    NSString *str = [NSString stringWithFormat:@"%@*****%@",[telNumber substringToIndex:3],[telNumber substringWithRange:NSMakeRange(8, 3)]];
    self.telNumberLabel.text = str;
}



- (IBAction)gotoSubmit:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(gotoSubmit:)]) {
        NSString *checkNumber = self.checkNumberTextField.text;
        [self.delegate gotoSubmit:[checkNumber integerValue]];
    }
}
- (IBAction)repeatSendMessage:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(repeatSendMessage)]) {
        [self.delegate repeatSendMessage];
    }
}



@end
