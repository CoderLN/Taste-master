//
//  OneViewCell.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneViewCellDelegate <NSObject>

- (void)collectButtonClick:(NSInteger )tag;

@end

@interface OneViewCell : UITableViewCell

@property (nonatomic, weak) id<OneViewCellDelegate> delegate;
- (void)updateWithDic:(NSDictionary *)dic;

@end
