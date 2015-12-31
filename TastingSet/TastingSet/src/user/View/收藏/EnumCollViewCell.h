//
//  EnumCollViewCell.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>


@class InfoCollModel;
@interface EnumCollViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *deleteArray;
- (void)updateWithModel:(InfoCollModel *)model;
- (void)showDeleteButton:(BOOL)res array:(NSMutableArray *)array;
@end
