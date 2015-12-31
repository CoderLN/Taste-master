//
//  NetDataEngine.m
//  LimitFree
//
//  Created by lijinghua on 15/9/12.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import "NetDataEngine.h"
#import "NetWorkReach.h"

@interface NetDataEngine()
@property(nonatomic)AFHTTPRequestOperationManager *manager;
@property (nonatomic, copy) FailedBlockType failedBlock;
@end

@implementation NetDataEngine

+ (instancetype)sharedInstance
{
    static NetDataEngine *s_netEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_netEngine = [[NetDataEngine alloc]init];
    });
    return s_netEngine;
}

- (id)init{
    if (self = [super init]) {
        self.manager = [[AFHTTPRequestOperationManager alloc]init];
        self.manager.requestSerializer.timeoutInterval = 10.f;
        //增加新的类型text/html
        NSSet *currentAcceptSet = self.manager.responseSerializer.acceptableContentTypes;
        NSMutableSet *mset = [NSMutableSet setWithSet:currentAcceptSet];
        [mset addObject:@"text/html"];
        self.manager.responseSerializer.acceptableContentTypes = mset;
    }
    return self;
}

- (void)GET:(NSString*)url success:(SuccessBlockType)successBlock falied:(FailedBlockType)failedBlock{
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)POST:(NSString*)url parameters:(NSDictionary *)parameters success:(SuccessBlockType)successBlock falied:(FailedBlockType)failedBlock{
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CustomActivityView stopAnimating];
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)requesGetDataFrom:(NSString*)url success:(SuccessBlockType)successBlock falied:(FailedBlockType)failedBlock {
    [self GET:url success:successBlock falied:failedBlock];
}

- (void)requesPostDataFrom:(NSString*)url parameters:(NSDictionary *)parameters success:(SuccessBlockType)successBlock falied:(FailedBlockType)failedBlock {
    NetWorkReach *workReach = [NetWorkReach sharedInstance];
    [workReach initNetwork];
    if (workReach.isNoNetReachable) {
        [self showMessage:@"网络异常"];
        [CustomActivityView stopAnimating];
    }else {
        [self POST:url parameters:parameters success:successBlock falied:failedBlock];
    }
}

//上传图片
+ (void)uploadImage:(UIImage *)image url:(NSString *)url parameters:(NSDictionary *)parameters name:(NSString *)name fileName:(NSString *)filename success:(SuccessBlockType)successBlock falied:(FailedBlockType)failedBlock {
        //分界线的标识符
        NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
        //根据url初始化request
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:10];
        //分界线 --0xKhTmLbOuNdArY
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 0xKhTmLbOuNdArY--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        
        //得到图片的data
        NSData* data ;
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        //参数的集合的所有key的集合
        NSArray *keys= [parameters allKeys];
        //遍历keys
        for(int i=0;i<[keys count];i++)
        {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
        }
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",name,filename];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
        //声明结束符：--0xKhTmLbOuNdArY--
        NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%ld", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        //http method
        [request setHTTPMethod:@"POST"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            if (successBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(data);
                });
            }
        }else if ([data length] == 0 || connectionError != nil){
            if (failedBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failedBlock(connectionError);
                });
            }
        }
    }];
}



+ (NSURLRequest *)webViewPost:(NSString *)url parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    NSMutableData *postBody = [NSMutableData data];
    
    
    [postBody appendData:[[NSString stringWithFormat:@"id=%@&password=%@&role=%@",@"admin02",@"admin02",@"dean"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postBody];
    
    
    return nil;
}


//显示错误信息
- (void)showMessage:(NSString *)str {
    [WSProgressHUD setProgressHUDFont:[UIFont systemFontOfSize:16]];
    [WSProgressHUD showErrorWithStatus:str];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
}







@end
