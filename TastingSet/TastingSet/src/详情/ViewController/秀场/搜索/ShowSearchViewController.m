//
//  ShowSearchViewController.m
//  TastingSet
//
//  Created by qianfeng on 15/11/10.
//  Copyright © 2015年 贵永冬. All rights reserved.
//

#import "ShowSearchViewController.h"
#import "GYDSearchBar.h"
#import "UserTableViewCell.h"
#import "UserModel.h"

#define defineUrl @"http://app.legendzest.cn/index.php?g=api241&m=user1&a=recommendUser"
#define searchUserUrl @"http://app.legendzest.cn/index.php?g=api241&m=user1&a=search"

#define addCommentUrl @"http://app.legendzest.cn/index.php?g=api241&m=user&a=attention"


@interface ShowSearchViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UserTableViewCellDelgate>
{
    BOOL _isRefreshing;
    BOOL _isLoadingMore;
}
@property (strong, nonatomic)  UITextField *searchBar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSoure;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger page;

@end

@implementation ShowSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.url = defineUrl;
    self.dataSoure = [NSMutableArray array];
    self.page = 1;
    [self setUpTableView];
    [self customUI];
    [self loadData];
}
- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)customUI {
    self.searchBar = [[GYDSearchBar alloc] initWithFrame:CGRectMake(10, 75, KScreenWidth - 20, 35)];
    self.searchBar.placeholder = @"搜索姓名或昵称";
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeySearch;
}
- (void)setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserTableViewCellId"];
    [self createRefreshView];
}
- (void)createRefreshView {
    __weak typeof (self)weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (_isRefreshing) {
            return ;
        }
        _isRefreshing = YES;
        weakSelf.page = 1;
        [weakSelf loadData];
    }];
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (_isLoadingMore) {
            return ;
        }
        weakSelf.page++;
        _isLoadingMore = YES;
        [weakSelf loadData];
    }];
}
- (void)addCancelBtn{
    UIButton *quxiao = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton = quxiao;
    quxiao.backgroundColor = [UIColor whiteColor];
    [quxiao setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:6/255.0 green:105/255.0 blue:200/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    quxiao.frame = CGRectMake(KScreenWidth - 60, 75, 60, 38);
    [quxiao addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quxiao];
}
- (void)cancelButtonClick:(UIButton *)button {
    self.searchBar.width = self.searchBar.width + 60;
    [button removeFromSuperview];
    [self.view endEditing:YES];
}
- (void)loadData {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:self.url parameters:[self getParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        if (self.page == 1) {
            self.dataSoure = [ParseData parseUserData:responsData];
        }else {
            [self.dataSoure addObjectsFromArray:[ParseData parseUserData:responsData]];
        }
        [self endUpdateing];
        [self.tableView reloadData];
    } falied:^(NSError *error) {
        [CustomActivityView stopAnimating];
        [CustomAlrter showFailedMessage:@"请求超时" time:2];
    }];
}
- (void)endUpdateing {
    if (_isRefreshing) {
        _isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (_isLoadingMore) {
        _isLoadingMore = NO;
        [self.tableView footerEndRefreshing];
    }
}
- (NSDictionary *)getParameters {
    UserModel *userModel = [UserModel sharedInstance];
    if ([self.url isEqualToString:defineUrl]) {
        NSDictionary *dic = @{
                              @"version":@(2.0),
                              @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                              @"d_type":@(2),
                              @"safe_code":@"safe_code_shangweiji",
                              @"uid":@(userModel.uid),
                              @"uuid":userModel.uuid,
                              @"igetui_cid":@(0),
                              };
        //version=2.0&device=AF53ED55-DD57-4FBF-9210-ECCAD746F6DC&d_type=2&safe_code=safe_code_shangweiji&uid=437415&uuid=24578f1256a6f1bf302b43fe30f86125&igetui_cid=0
        return dic;
    }else {
        NSDictionary *dic = @{
                              @"version":@(2.0),
                              @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                              @"d_type":@(2),
                              @"safe_code":@"safe_code_shangweiji",
                              @"uid":@(userModel.uid),
                              @"uuid":userModel.uuid,
                              @"igetui_cid":@(0),
                              @"page":@(self.page),
                              @"nickname":self.searchBar.text
                              };
        //version=2.0&device=AF53ED55-DD57-4FBF-9210-ECCAD746F6DC&d_type=2&safe_code=safe_code_shangweiji&uid=437415&uuid=24578f1256a6f1bf302b43fe30f86125&igetui_cid=0&page=1&nickname=%E5%95%8A
        return dic;
    }
}




#pragma mark -
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.cancelButton.selected = NO;
    self.cancelButton.userInteractionEnabled = YES;
    [self addCancelBtn];
    self.searchBar.width = self.searchBar.width - 60;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.cancelButton.selected = YES;
    self.cancelButton.userInteractionEnabled = NO;
    [textField resignFirstResponder];
    
    NSString *text = textField.text;
    if (text.length == 0) {
        return YES;
    }else {
        self.url = searchUserUrl;
        [self loadData];
    }
    return YES;
}

#pragma mark -
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCellId" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateWithModel:self.dataSoure[indexPath.row]];
    return cell;
}

#pragma mark -
#pragma mark -UserTableViewCellDelgate

- (void)addCommentButtonClick:(UserModel *)model cancel:(NSInteger)res {
    [CustomActivityView startAnimating];
    UserModel *userModel = [UserModel sharedInstance];
    NSInteger delete = 0;
    if (res == 1) {
        delete = 0;
    }else {
        delete = 1;
    }
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0),
                          @"attentionid":@(model.uid),
                          @"delete":@(delete)
                          };
    //version=2.0&device=AF53ED55-DD57-4FBF-9210-ECCAD746F6DC&d_type=2&safe_code=safe_code_shangweiji&uid=437415&uuid=24578f1256a6f1bf302b43fe30f86125&igetui_cid=0&attentionid=433386&delete=0
    
    [[NetDataEngine sharedInstance] requesPostDataFrom:addCommentUrl parameters:dic success:^(id responsData) {
        [CustomActivityView stopAnimating];
        NSInteger code = [[responsData objectForKey:@"code"] integerValue];
        if (code == 200) {
            if (res == 1) {
                [CustomAlrter showSuccessMessage:@"关注成功" time:2.0];
            }else {
                [CustomAlrter showSuccessMessage:@"取消成功" time:2.0];
            }
        }
    } falied:^(NSError *error) {
        [CustomActivityView stopAnimating];
        [CustomAlrter showFailedMessage:@"请求超时" time:2];
    }];
}

@end
