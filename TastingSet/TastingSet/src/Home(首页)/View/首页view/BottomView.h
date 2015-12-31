//
//  BottomView.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  BottomViewDelegate <NSObject>

- (void)gotoRoom;
- (void)gotoEnum;
- (void)gotoShow;

@end

@interface BottomView : UIView

@property (nonatomic, weak) id<BottomViewDelegate> delegate;

- (void)updateWithArray:(NSArray *)array;

@end
