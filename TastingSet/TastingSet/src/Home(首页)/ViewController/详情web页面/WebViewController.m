//
//  WebViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "ToolView.h"
#import "LoginViewController.h"
#import "RoomModel.h"
#import "EnumDetailViewController.h"
#import "RoomDetailViewController.h"
#import "PlayViewController.h"



@interface WebViewController ()<WKNavigationDelegate, ToolViewDelegate>
{
    BOOL _isNoFirst;
}

@property (nonatomic, strong) RoomModel *HeadModel;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) ToolView *toolView;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) UIView *headView;


@end

@implementation WebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadData];
    [self setUpToolView];
}

- (void)loadData {
    [self loadWebView];
}
- (void)loadWebView {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager .responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [CustomActivityView startAnimating];
    [manager POST:WebUrl parameters:[self parameter] success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSData *doubi = responseObject;
        self.content =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
        [CustomActivityView stopAnimating];
        [self setUpWebView];
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



- (void)setUpWebView {
    if (self.webView == nil) {
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height - 70)];
        self.webView.navigationDelegate = self;
        self.webView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        [self.view addSubview:self.webView];
    }
    [self.webView loadHTMLString:self.content baseURL:nil];
}

- (void)setUpToolView {
    self.toolView = [[ToolView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 50, KScreenWidth, 50)];
    self.toolView.delegate = self;
    [self.view addSubview:self.toolView];
}
//web参数
- (NSDictionary *)parameter {
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0),
                          @"id":self.myId
                          };
    return dic;
}
// 收藏参数
- (NSDictionary *)getParameters:(NSString *)myId {
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0),
                          @"cid":self.cid,
                          @"sid":myId
                          };
    return dic;
}

#pragma mark -
#pragma mark - WKNavigationDelegate

//请求时决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURLRequest *request = navigationAction.request;
    NSString *url = request.URL.absoluteString;
    
    NSLog(@"%@",url);
    
    if ([url hasPrefix:@"viewinfo"]) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.cid = self.cid;
        webVC.myId = [url substringFromIndex:11];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([url hasPrefix:@"viewcookbook"]) {
        EnumDetailViewController *enumDetailVC = [[EnumDetailViewController alloc] init];
        enumDetailVC.cid = @"14";
        enumDetailVC.myId = [url substringFromIndex:15];
        [self.navigationController pushViewController:enumDetailVC animated:YES];
    }
    if ([url hasPrefix:@"viewrestaurant"]) {
        RoomDetailViewController *roomDetailVC = [[RoomDetailViewController alloc] init];
        roomDetailVC.cid = @"15";
        roomDetailVC.myId = [url substringFromIndex:17];
        [self.navigationController pushViewController:roomDetailVC animated:YES];
    }
    
    if ([url hasPrefix:@"collectcookbook"]) {
        self.cid = @"1";
        [self gotoCollect:[url substringFromIndex:18]];
    }
    if ([url hasPrefix:@"collectrestaurant"]) {
        self.cid = @"15";
        [self gotoCollect:[url substringFromIndex:20]];
    }
    if ([url hasPrefix:@"video"]) {
        PlayViewController *playVC = [[PlayViewController alloc] init];
        playVC.playUrl = [url substringFromIndex:8];
        [self.navigationController pushViewController:playVC animated:YES];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

//响应时决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}




#pragma mark -
#pragma mark - ToolViewDelegate

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)gotoRootVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)collectButtonCLick {
    [self gotoCollect:self.myId];
}

- (void)gotoCollect:(NSString *)myid {
    BOOL isUserLogin = [[NSUserDefaults standardUserDefaults] boolForKey:ISUSERLOGIN];
    if (!isUserLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else {
        [[NetDataEngine sharedInstance] requesPostDataFrom:AddCollUrl parameters:[self getParameters:myid] success:^(id responsData) {
            NSInteger code = [[(NSDictionary *)responsData objectForKey:@"code"] integerValue];
            if (code == 220) {
                [CustomAlrter showFailedMessage:@"你已经收藏过了" time:2];
            }else if (code == 200) {
                [CustomAlrter showSuccessMessage:@"收藏成功" time:2];
            }else {
                [CustomAlrter showFailedMessage:@"收藏失败" time:2];
            }
        } falied:^(NSError *error) {
            [CustomActivityView stopAnimating];
            [CustomAlrter showFailedMessage:@"请求超时" time:2];
        }];
    }
}



- (void)sharedButtonClick {
    
}






@end
