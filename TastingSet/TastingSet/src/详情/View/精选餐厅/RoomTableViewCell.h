//
//  RoomTableViewCell.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomModel ;
@interface RoomTableViewCell : UITableViewCell

- (void)updateWithModel:(RoomModel *)model;

@end
