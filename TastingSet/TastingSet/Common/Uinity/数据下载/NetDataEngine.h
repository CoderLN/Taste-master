//
//  NetDataEngine.h
//  LimitFree
//
//  Created by lijinghua on 15/9/12.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlockType) (id responsData);
typedef void(^FailedBlockType)(NSError *error);

@interface NetDataEngine : NSObject



+ (instancetype)sharedInstance;

- (void)requesGetDataFrom:(NSString*)url success:(SuccessBlockType)successBlock falied:(FailedBlockType)failedBlock;

- (void)requesPostDataFrom:(NSString*)url parameters:(NSDictionary *)parameters success:(SuccessBlockType)successBlock falied:(FailedBlockType)failedBlock;

+ (void)uploadImage:(UIImage *)image url:(NSString *)url parameters:(NSDictionary *)parameters name:(NSString *)name fileName:(NSString *)filename success:(SuccessBlockType)successBlock falied:(FailedBlockType)failedBlock;

+ (NSURLRequest *)webViewPost:(NSString *)url parameters:(NSDictionary *)parameters;


@end
