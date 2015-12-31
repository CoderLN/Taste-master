//
//  UserView.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserViewDelgate <NSObject>

- (void)login;
- (void)changeUserInfo:(NSDictionary *)dic;
- (void)gotoCollectVC:(NSInteger)tag;
- (void)shareButtonClick;

@end

@interface UserView : UIView

@property (nonatomic, weak) id<UserViewDelgate> delegate;

- (void)beginLoadUserInfo;

@end
