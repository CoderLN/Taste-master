//
//  SubViewController.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^changeUserInfoBlock)(NSInteger type, NSString *name);

@interface SubViewController : UIViewController

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *qianming;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) changeUserInfoBlock block;


@end
