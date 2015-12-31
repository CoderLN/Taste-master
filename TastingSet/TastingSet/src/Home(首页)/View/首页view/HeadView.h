//
//  HeadView.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadViewDelegate <NSObject>

- (void)loadMoreData:(int)isVideo;

- (void)refreshData:(int)isVideo;

- (void)HeadViewCellDidSelected:(NSString *)myId cid:(NSString *)cid;

- (void)HeadViewDelegateshowUserView;
- (void)searchButtonClick;


@end


@interface HeadView : UIView

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger number;


@property (nonatomic, weak) id<HeadViewDelegate> delegate;

- (void)updateWithArray:(NSArray *)array;





@end
