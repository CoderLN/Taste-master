//
//  UserModel.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *d_type;
@property (nonatomic, copy) NSString *cid;

@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *approve;

@property (nonatomic, assign) NSInteger isfans;

+ (instancetype)sharedInstance;


@end
