//
//  ShowTableViewCell.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowTableViewCellDelgate <NSObject>

- (void)likeButtonClick:(ShowModel *)model;
- (void)commentButtonClick:(ShowModel *)model;
- (void)moreButtonClick:(ShowModel *)model;

@end


@class ShowModel;
@interface ShowTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ShowTableViewCellDelgate> delegate;

- (void)updateWithModel:(ShowModel *)model;

@end
