//
//  ToolView.h
//  TastingSet
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolViewDelegate <NSObject>

- (void)backButtonClick;
- (void)collectButtonCLick;
- (void)sharedButtonClick;
- (void)gotoRootVC;


@end

@interface ToolView : UIView

@property (nonatomic, weak) id<ToolViewDelegate> delegate;

@end
