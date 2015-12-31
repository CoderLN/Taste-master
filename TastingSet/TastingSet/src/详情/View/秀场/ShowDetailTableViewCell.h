//
//  ShowDetailTableViewCell.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ShowModel;
@interface ShowDetailTableViewCell : UITableViewCell

- (void)updateWithModel:(ShowModel *)model tabelView:(UITableView *)tabelView;

@end
