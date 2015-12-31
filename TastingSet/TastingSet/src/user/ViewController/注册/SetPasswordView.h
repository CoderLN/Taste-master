//
//  SetPasswordView.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetPasswordViewDelegate <NSObject>

- (void)registSuccess;

@end

@interface SetPasswordView : UIView

@property (nonatomic, copy) NSString *telNumber;
@property (nonatomic, assign) NSInteger m_code;
@property (nonatomic, weak) id<SetPasswordViewDelegate> delegate;

@end
