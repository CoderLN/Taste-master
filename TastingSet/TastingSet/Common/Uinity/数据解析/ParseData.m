//
//  ParseData.m
//  SiCook
//
//  Created by qianfeng on 15/10/17.
//  Copyright (c) 2015年 贵永冬. All rights reserved.
//

#define BASEURL @"http://manage.legendzest.cn"

#import "ParseData.h"
#import "HomeMmodel.h"
#import "RoomModel.h"
#import "InfoCollModel.h"
#import "ShowModel.h"
#import "UserModel.h"
#import "SearchModel.h"


@implementation ParseData


/**
 *  解析图片url
 */
+ (NSString *)parseImageUrl:(NSString *)url {
    if (url.length == 0) {
        return nil;
    }
    NSString *str = [url substringFromIndex:1];
    return [NSString stringWithFormat:@"%@%@",BASEURL,str];
}


/**
 *  解析首页菜谱数据
 */
+ (NSMutableArray *)parseHomeData:(id)respance {
    NSArray *arr = [(NSDictionary *)respance objectForKey:@"res"];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        HomeMmodel *model = [[HomeMmodel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [tmpArr addObject:model];
    }
    return tmpArr;
}

/**
 *  解析餐厅数据
 */
+ (NSMutableArray *)parseRoomData:(id)respance {
    NSArray *arr = [(NSDictionary *)respance objectForKey:@"res"];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        RoomModel *model = [[RoomModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [tmpArr addObject:model];
    }
    return tmpArr;
}
/**
 *  解析餐厅详情数据
 */
+ (NSMutableArray *)parseRoomDetailData:(id)respance {
    NSDictionary *dic = [(NSDictionary *)respance objectForKey:@"res"];
    NSMutableArray *tmpArr = [NSMutableArray array];

    RoomModel *model = [[RoomModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    [tmpArr addObject:model];

    return tmpArr;
}


/**
 *  解析收藏数据
 */
+ (NSMutableArray *)parseCollData:(id)respance {
    
    if ([[(NSDictionary *)respance objectForKey:@"res"] isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    NSArray *arr = [(NSDictionary *)respance objectForKey:@"res"];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        InfoCollModel *model = [[InfoCollModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [tmpArr addObject:model];
    }
    return tmpArr;
}

/**
 *  解析秀场详数据
 */
+ (NSMutableArray *)parseShowData:(id)respance {
    
    NSArray *arr = [(NSDictionary *)respance objectForKey:@"res"];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        ShowModel *model = [[ShowModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [tmpArr addObject:model];
    }
    return tmpArr;
}
/**
 *  解析秀场详数据
 */
+ (ShowModel *)parseShowDetailData:(id)respance {
    NSDictionary *dic = (NSDictionary *)respance;
    ShowModel *model = [[ShowModel alloc] init];
    [model setValuesForKeysWithDictionary:[dic objectForKey:@"res"]];
    return model;
}
/**
 *  解析用户详数据
 */
+ (NSMutableArray *)parseUserData:(id)respance {
    NSArray *arr = [(NSDictionary *)respance objectForKey:@"res"];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        UserModel *model = [[UserModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [tmpArr addObject:model];
    }
    return tmpArr;
}

/**
 *  解析搜索详数据
 */
+ (NSMutableArray *)parseSearchData:(id)respance {
    NSArray *arr = [(NSDictionary *)respance objectForKey:@"res"];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        SearchModel *model = [[SearchModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [tmpArr addObject:model];
    }
    return tmpArr;
}


@end
