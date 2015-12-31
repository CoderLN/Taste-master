//
//  NumberTableViewCell.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ShowModel;
@interface NumberTableViewCell : UITableViewCell


- (void)updateWithModel:(ShowModel *)model number:(NSInteger )number;

@end
