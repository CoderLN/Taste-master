//
//  ToolView.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "ToolView.h"

@implementation ToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ToolView" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}
- (IBAction)backButtonClick:(id)sender {
    if (self.delegate != nil) {
        [self.delegate backButtonClick];
    }
}

- (IBAction)collectButtonCLick:(id)sender {
    if (self.delegate != nil) {
        [self.delegate collectButtonCLick];
    }
}
- (IBAction)sharedButtonClick:(id)sender {
    if (self.delegate != nil) {
        [self.delegate sharedButtonClick];
    }
}

- (IBAction)totoRootVC:(id)sender {
    if (self.delegate != nil) {
        [self.delegate gotoRootVC];
    }
}

@end
