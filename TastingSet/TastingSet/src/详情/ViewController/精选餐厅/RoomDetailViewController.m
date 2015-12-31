//
//  RoomDetailViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "RoomDetailViewController.h"
#import "RoomModel.h"
#import "RoomHeadView.h"
#import "ToolView.h"
#import "LoginViewController.h"
#import <WebKit/WebKit.h>

#define myweburl @"http://app.legendzest.cn/index.php?g=api241&m=restaurant&a=getinfo"

@interface RoomDetailViewController ()<ToolViewDelegate, WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) RoomModel *headModel;
@property (nonatomic, strong) RoomHeadView *headView;
@property (nonatomic, strong) ToolView *toolView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *content;


@end

@implementation RoomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpWebView];
    [self setUpToolView];
    [self loadData];
    [self loadWebView];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setUpToolView {
    self.toolView = [[ToolView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 50, KScreenWidth, 50)];
    self.toolView.delegate = self;
    [self.view addSubview:self.toolView];
}
- (void)loadWebView {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager .responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [CustomActivityView startAnimating];
    [manager POST:myweburl parameters:[self getParameters] success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSData *doubi = responseObject;
        self.content =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
        [CustomActivityView stopAnimating];
        [self.webView loadHTMLString:self.content baseURL:nil];
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)setUpWebView {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 35)];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(400, 0, 0, 0);
    self.webView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [self.view addSubview:self.webView];
}

- (void)loadData {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:getInfo parameters:[self getParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        NSArray *array = [ParseData parseRoomDetailData:responsData];
        self.headModel = [array firstObject];
        [self addHeadView];
    } falied:^(NSError *error) {
        [CustomActivityView stopAnimating];
        [CustomAlrter showFailedMessage:@"请求超时" time:2];
    }];
}
- (void)addHeadView {
    if (self.headView == nil) {
        self.headView = [[RoomHeadView alloc] initWithFrame:CGRectMake(0, -400, KScreenWidth, 400)];
        [self.webView.scrollView addSubview:self.headView];
    }
    [self.headView udpateWithModel:self.headModel];
    
}



- (NSDictionary *)getParameters {
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
- (NSDictionary *)getColParameters {
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
                          @"sid":self.myId
                          };
    return dic;
}
#pragma mark -
#pragma mark - UIScrollViewDelegate


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
        [[NetDataEngine sharedInstance] requesPostDataFrom:AddCollUrl parameters:[self getColParameters] success:^(id responsData) {
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
