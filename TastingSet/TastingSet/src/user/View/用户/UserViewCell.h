//
//  UserViewCell.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon2View;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger section;

@end
