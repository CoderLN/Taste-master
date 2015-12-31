//
//  ShowModel.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *origin_type;
@property (nonatomic, copy) NSString *origin_id;
@property (nonatomic, copy) NSString *origin_name;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *pic_width;
@property (nonatomic, copy) NSString *pic_height;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *collent;
@property (nonatomic, copy) NSString *praise;
@property (nonatomic, copy) NSString *ord;
@property (nonatomic, copy) NSString *recommend;
@property (nonatomic, copy) NSString *fpraisemax;
@property (nonatomic, copy) NSString *ispraise;
@property (nonatomic, assign) NSInteger commentscount;
@property (nonatomic, copy) NSString *j_index;
@property (nonatomic, copy) NSString *is_allow_pra;
@property (nonatomic, copy) NSString *is_top;
@property (nonatomic, copy) NSString *approve;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSArray *pres;
@property (nonatomic, copy) NSString *prescount;

@end
