//
//  RootViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "RootViewController.h"
#import "HeadView.h"
#import "BottomView.h"
#import "TastingSetDBManager.h"
#import "WebViewController.h"
#import "UserView.h"
#import "LoginViewController.h"
#import "ChangeUserInfoViewController.h"
#import "RoomViewController.h"
#import "EnumViewController.h"
#import "ShowViewController.h"
#import "CollectViewController.h"
#import "SearchViewController.h"
//#import "UMSocial.h"

@interface RootViewController ()<HeadViewDelegate, UIScrollViewDelegate, UserViewDelgate, BottomViewDelegate>
{
    BOOL _isLoadingMore;//加载更多
    BOOL _isRefreshing;//刷新
    BOOL _isShowUserView;//用户界面是否显示
}


@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataSoure;
@property (nonatomic, strong) NSMutableArray *bottomSoure;

@property (nonatomic, strong) HeadView *headView;
@property (nonatomic, strong) BottomView *bottomView;
@property (nonatomic, strong) UserView *userView;


@property (nonatomic, strong) UIScrollView *scollView;

@end

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated {
    if (_isShowUserView) {
        [self.userView beginLoadUserInfo];
    }
}


- (BOOL)prefersStatusBarHidden {
    if (_isShowUserView) {
        return NO;
    }
    return YES;
}
- (instancetype)init {
    if (self = [super init]) {
        self.dataSoure = [NSMutableArray array];
        self.page = 1;
        _isVedio = 0;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self setUpUserView];
    [self customScrollView];
    [self loadData];
}
- (void)setUpUserView {
    UserView *userView = [[UserView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-100)];
    self.userView = userView;
    userView.delegate = self;
    [self.view addSubview:userView];
}

- (void)customScrollView {
    self.scollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.scollView.delegate = self;
    self.scollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight+1);
    self.scollView.showsVerticalScrollIndicator = NO;
    self.scollView.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"IMG_Firstpage_BottomLogo"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((KScreenWidth - 150)/2, KScreenHeight - 80, 150, 64);
    [self.view addSubview:imageView];
    [self.view addSubview:self.scollView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.tag = 6000;
    [self.view addSubview:bgView];
}


- (void)addHeadView {
    if (self.headView == nil) {
        self.headView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KScreenWidth/3.0)];
        self.headView.delegate = self;
        [self.scollView addSubview:self.headView];
        
        UIView *bgView = [self.view viewWithTag:6000];
        [bgView removeFromSuperview];
    }
    if (self.page == 1) {
        self.headView.number = 1;
    }
    [self.headView updateWithArray:self.dataSoure];
}
- (void)addBottomView {
    if (self.bottomView == nil) {
        self.bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, KScreenHeight - KScreenWidth/3.0, KScreenWidth, KScreenWidth/3.0)];
        self.bottomView.delegate = self;
        [self.scollView addSubview:self.bottomView];
    }
    [self.bottomView updateWithArray:self.bottomSoure];
}

- (void)loadData {
    if ([self loadHomeDataFromLocal]) {
        [self loadHomeDataFromNet];
    }
    if ([self loadBottomDataFromLocal]) {
        [self loadBottomDataFromNet];
    }
}
- (BOOL)loadHomeDataFromLocal {
    if (self.page != 1) {
        return YES;
    }
    TastingSetDBManager *DBManager = [TastingSetDBManager sharedInstance];
    NSMutableArray *arr = [DBManager readAllModel];
    if (arr.count != 0 && arr.count >= 20) {
        [self.dataSoure addObjectsFromArray:arr];
        [self addHeadView];
    }
    return YES;
}
- (void)loadHomeDataFromNet {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:HOMEDATAURL parameters:[self getHomeParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        if (self.page == 1) {
            self.dataSoure = [ParseData parseHomeData:responsData];
            if (!_isVedio) {
                [self saveModelsToLocal];
            }
        }else {
             [self.dataSoure addObjectsFromArray:[ParseData parseHomeData:responsData]];
        }
        [self addHeadView];
    } falied:^(NSError *error) {
        [CustomAlrter showFailedMessage:@"请求超时" time:2];
    }];
}
- (void)saveModelsToLocal {
    NSArray *arr = [self.dataSoure subarrayWithRange:NSMakeRange(0, 20)];
    TastingSetDBManager *DBManager = [TastingSetDBManager sharedInstance];
    [DBManager addModels:arr];
}

- (BOOL)loadBottomDataFromLocal {
    [self addBottomView];
    return YES;
}
- (void)loadBottomDataFromNet {
    [[NetDataEngine sharedInstance] requesPostDataFrom:HOMEBOTTOMURL parameters:[self getBottomParameters] success:^(id responsData) {
        self.bottomSoure = [ParseData parseHomeData:responsData];
        [self addBottomView];
    } falied:^(NSError *error) {
        [CustomActivityView stopAnimating];
        [CustomAlrter showFailedMessage:@"请求超时" time:2];
    }];
}
- (NSDictionary *)getHomeParameters {
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                         @"version":@(2.0),
                         @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                         @"d_type":@(2),
                         @"safe_code":@"safe_code_shangweiji",
                         @"uid":@(userModel.uid),
                         @"uuid":userModel.uuid,
                         @"igetui_cid":@(0),
                         @"page":@(self.page),
                         @"onlyvideo":@(_isVedio)
                          };
    return dic;
}
- (NSDictionary *)getBottomParameters {
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0),
                          @"onlyvideo":@(_isVedio)
                          };
    return dic;
}

#pragma  mark -
#pragma mark - HeadViewDelegate
- (void)loadMoreData:(int)isVideo {
    _isVedio = isVideo;
    self.page++;
    [self loadHomeDataFromNet];
}
- (void)refreshData:(int)isVideo {
    _isVedio = isVideo;
    self.page = 1;
    [self loadData];
}
- (void)HeadViewCellDidSelected:(NSString *)myId cid:(NSString *)cid {
    WebViewController *webView = [[WebViewController alloc] init];
    webView.myId = myId;
    webView.cid = cid;
    [self.navigationController pushViewController:webView animated:YES];

}
- (void)HeadViewDelegateshowUserView {
    [self beginShowUserView:self.scollView];
}
- (void)searchButtonClick {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 
#pragma mark - UserViewDelgate
- (void)login {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (void)changeUserInfo:(NSDictionary *)dic {
    ChangeUserInfoViewController *changeUserInfoVC = [[ChangeUserInfoViewController alloc] init];
    changeUserInfoVC.dic = dic;
    [self.navigationController pushViewController:changeUserInfoVC animated:YES];
}

- (void)gotoCollectVC:(NSInteger)tag {
    BOOL isUserLogin = [[NSUserDefaults standardUserDefaults] boolForKey:ISUSERLOGIN];
    if (isUserLogin) {
        CollectViewController *collectVC = [[CollectViewController alloc] init];
        if (tag == 200) {
            collectVC.collectType = CollectTypeInfo;
        }
        if (tag == 201) {
            collectVC.collectType = CollectTypeRoom;
        }
        if (tag == 202) {
            collectVC.collectType = CollectTypeEnum;
        }
        [self.navigationController pushViewController:collectVC animated:YES];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
- (void)shareButtonClick {
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                appKey:@"5641c4bd67e58ef51f003243"
//                                      shareText:@"你要分享的文字"
//                                     shareImage:nil
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
//                                       delegate:nil];
}



#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y >= 85) {
        [scrollView setContentOffset:CGPointMake(0, 85)];
    }
    if (_isShowUserView) {
    }else {
        if (scrollView.frame.origin.y ==0 && scrollView.contentOffset.y <-50) {
            [self beginShowUserView:scrollView];
        }
    }
}

- (void)beginShowUserView:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration:0.8 animations:^{
        [scrollView setMarginY:KScreenHeight-100];
    }completion:^(BOOL finished) {
        [self.userView beginLoadUserInfo];
        
        scrollView.scrollEnabled = NO;
        _isShowUserView = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenUserView:)];
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenUserView:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        UIView *view = [[UIView alloc] initWithFrame:scrollView.bounds];
        view.tag = 500;
        view.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:view];
        [view addGestureRecognizer:gesture];
        [view addGestureRecognizer:recognizer];
    }];
}

- (void)hiddenUserView:(UITapGestureRecognizer *)gesture {
    if (_isShowUserView) {
        UIView *view = [self.scollView viewWithTag:500];
        [view removeFromSuperview];
        [UIView animateWithDuration:0.8 animations:^{
            [self.scollView setMarginY:0];
        }completion:^(BOOL finished) {
            self.scollView.scrollEnabled = YES;
            _isShowUserView = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}


#pragma mark - 
#pragma  mark - BottomViewDelegate
//精选餐厅
- (void)gotoRoom {
    RoomViewController *roomVC = [[RoomViewController alloc] init];
    [self.navigationController pushViewController:roomVC animated:YES];
}
//大师菜单
- (void)gotoEnum {
    EnumViewController *enumVC = [[EnumViewController alloc] init];
    [self.navigationController pushViewController:enumVC animated:YES];
}
//秀场
- (void)gotoShow {
    ShowViewController *showVC = [[ShowViewController alloc] init];
    [self.navigationController pushViewController:showVC animated:YES];
}







@end
