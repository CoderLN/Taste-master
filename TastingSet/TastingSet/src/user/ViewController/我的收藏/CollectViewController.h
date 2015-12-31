//
//  CollectViewController.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CollectType) {
    CollectTypeInfo = 0,//每日资讯
    CollectTypeRoom,    //精选餐厅
    CollectTypeEnum     //大师菜谱
};

@interface CollectViewController : UIViewController

@property (nonatomic, assign) CollectType collectType;

@end
