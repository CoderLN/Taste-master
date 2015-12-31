//
//  ParseData.h
//  SiCook
//
//  Created by qianfeng on 15/10/17.
//  Copyright (c) 2015年 贵永冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShowModel;
@interface ParseData : NSObject

/**
 *  解析图片url
 */
+ (NSString *)parseImageUrl:(NSString *)url;


/**
 *  解析首页菜谱数据
 */
+ (NSMutableArray *)parseHomeData:(id)respance;

/**
 *  解析餐厅数据
 */
+ (NSMutableArray *)parseRoomData:(id)respance;
/**
 *  解析收藏数据
 */
+ (NSMutableArray *)parseCollData:(id)respance;

/**
 *  解析餐厅详情数据
 */
+ (NSMutableArray *)parseRoomDetailData:(id)respance;

/**
 *  解析秀场详数据
 */
+ (NSMutableArray *)parseShowData:(id)respance;

/**
 *  解析秀场详数据
 */
+ (ShowModel *)parseShowDetailData:(id)respance;

/**
 *  解析用户详数据
 */
+ (NSMutableArray *)parseUserData:(id)respance;
/**
 *  解析搜索详数据
 */
+ (NSMutableArray *)parseSearchData:(id)respance;

@end
