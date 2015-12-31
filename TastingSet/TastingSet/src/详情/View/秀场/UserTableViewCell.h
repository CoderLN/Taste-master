//
//  UserTableViewCell.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UserTableViewCellDelgate  <NSObject>

- (void)addCommentButtonClick:(UserModel *)model cancel:(NSInteger) res;

@end

@class UserModel;
@interface UserTableViewCell : UITableViewCell

@property (nonatomic, weak) id<UserTableViewCellDelgate> delegate;

- (void)updateWithModel:(UserModel *)model;

@end
