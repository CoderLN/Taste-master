//
//  TastingSetDBManager.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "TastingSetDBManager.h"
#import "FMDatabase.h"


@interface TastingSetDBManager ()
{
    FMDatabase *_db;   //数据库实例
}
@end

@implementation TastingSetDBManager


+ (instancetype)sharedInstance {
    static TastingSetDBManager *s_dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_dbManager = [[TastingSetDBManager alloc]init];
    });
    return s_dbManager;
}
- (instancetype)init{
    if (self = [super init]) {
        _db  = [[FMDatabase alloc]initWithPath:[self dbPath]];
        if ([_db open]) {
            [self createTable];
            [_db close];
        }
    }
    return self;
}
- (NSString*)dbPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tastingSet.db"];
}
- (void)createTable
{
    NSString *sql = @"create table if not exists modelInfo(mid text primary key,title text,authorname text,short_content text,releasedate text,pic text,has_video text,typeId text,cid text,keywords text,kname text,maxsid text,wiki_count integer)";
    if (![_db executeUpdate:sql]) {
        NSLog(@"创建表失败");
    }
}

//添加
- (void)addModels:(NSArray *)array {
    NSString *sql = @"insert into modelInfo(mid,title,authorname,short_content,releasedate,pic,has_video,typeId,cid,keywords,kname,maxsid,wiki_count) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    [_db open];
    [_db beginTransaction];
    BOOL isRollBack = NO;
    @try {
        BOOL success =  [_db executeUpdate:@"DELETE FROM modelInfo"];
        if (success) {
            for (int i = 0; i< array.count; i++) {
                HomeMmodel *model = array[i];
                if (![_db executeUpdate:sql,model.id,model.title,model.authorname,model.short_content,model.releasedate,model.pic,model.has_video,model.typeId,model.cid,model.keywords,model.kname,model.maxsid,@(model.wiki_count)]) {
                    NSLog(@"插入失败1");
                }
            }
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [_db rollback];
    }
    @finally {
        if (!isRollBack) {
            [_db commit];
        }
    }
    [_db close];
}

//删除所有
- (void)deleteAllModel {
    [_db open];
    [_db executeUpdate:@"DELETE FROM modelInfo"];
    [_db close];
}

//读取
- (NSMutableArray *)readAllModel {
    NSMutableArray *homeModelArray = [NSMutableArray array];
    NSString *sql = @"select * from modelInfo";
    [_db open];
    FMResultSet *resultSet = [_db executeQuery:sql];
    while (resultSet.next) {
        HomeMmodel *homeModel = [[HomeMmodel alloc]init];
        
        homeModel.id = [resultSet stringForColumn:@"mid"];
        homeModel.title          = [resultSet stringForColumn:@"title"];
        homeModel.authorname       = [resultSet stringForColumn:@"authorname"];
        homeModel.short_content   = [resultSet stringForColumn:@"short_content"];
        homeModel.releasedate          = [resultSet stringForColumn:@"releasedate"];
        homeModel.pic       = [resultSet stringForColumn:@"pic"];
        homeModel.has_video   = [resultSet stringForColumn:@"has_video"];
        homeModel.typeId          = [resultSet stringForColumn:@"typeId"];
        homeModel.cid       = [resultSet stringForColumn:@"cid"];
        homeModel.keywords   = [resultSet stringForColumn:@"keywords"];
        homeModel.kname          = [resultSet stringForColumn:@"kname"];
        homeModel.maxsid       = [resultSet stringForColumn:@"maxsid"];
        homeModel.wiki_count   = [resultSet intForColumn:@"wiki_count"];
        
        [homeModelArray addObject:homeModel];
    }
    [_db close];
    [resultSet close];
    return homeModelArray;
}

@end
