//
//  TastingSetDBManager.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeMmodel.h"


@interface TastingSetDBManager : NSObject

+ (instancetype)sharedInstance;


//添加
- (void)addModels:(NSArray *)array;

//删除所有
- (void)deleteAllModel;

//读取
- (NSMutableArray *)readAllModel;



@end
