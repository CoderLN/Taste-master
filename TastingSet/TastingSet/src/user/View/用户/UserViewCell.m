//
//  UserViewCell.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "UserViewCell.h"


@implementation UserViewCell

- (void)setFrame:(CGRect)frame{
    if (self.section == 0) {
        CGRect sectionRect = [self.tableView rectForSection:self.section];
        CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame));
        [super setFrame:newFrame];
    }else {
        [super setFrame:frame];
    }
}

@end
