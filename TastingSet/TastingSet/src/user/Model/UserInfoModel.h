//
//  UserInfoModel.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic, copy) NSString *uname;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *lv;
@property (nonatomic, copy) NSString *credit;
@property (nonatomic, copy) NSString *notifynum;
@property (nonatomic, assign) NSInteger approve;

@end
