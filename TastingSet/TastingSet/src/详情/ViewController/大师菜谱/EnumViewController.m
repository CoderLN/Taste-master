//
//  EnumViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "EnumViewController.h"
#import "EnumTableViewCell.h"
#import "RoomModel.h"
#import "GYDSearchBar.h"
#import "CategoryViewController.h"
#import "EnumDetailViewController.h"

@interface EnumViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UITextFieldDelegate, CategoryViewControllerDelegate>
{
    BOOL _isShowTool;
    BOOL _isAnimationing;
    BOOL _isRefreshing;
    BOOL _isLoadingMore;
    NSInteger _contentY;
}
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;

@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (nonatomic, strong) UIButton *lastSelectedButton;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSString *myTitle;
@property (nonatomic, copy) NSString *number;

@property (nonatomic, strong) GYDSearchBar *searchBar;
@property (nonatomic, strong) UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSoure;

@end

@implementation EnumViewController
- (instancetype)init {
    if (self = [super init]) {
        self.page = 1;
        self.order = @"1";
        self.myTitle = @"";
        self.number = @"0";
        self.dataSoure = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customButton];
    [self setUpTableView];
    [self loadData];
}
- (BOOL)prefersStatusBarHidden {
    if (_isShowTool) {
        return YES;
    }
    return NO;
}
- (void)customButton {
    UIButton *button = (UIButton *)[self.view viewWithTag:600];
    button.selected = YES;
    self.lastSelectedButton = button;
}
- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 436;
    [self createRefreshView];
    [self.tableView registerNib:[UINib nibWithNibName:@"EnumTableViewCell" bundle:nil] forCellReuseIdentifier:@"EnumTableViewCellId"];
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
        _isLoadingMore = YES;
        weakSelf.page ++;
        [weakSelf loadData];
    }];
}
- (void)loadData {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:EnumUrl parameters:[self getParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        if ([ParseData parseRoomData:responsData].count == 0 && self.page == 1) {
            [CustomAlrter showFailedMessage:@"没有搜索到结果" time:3.0];
        }
        if (self.page == 1) {
            self.dataSoure = [ParseData parseRoomData:responsData];
        }else {
            [self.dataSoure  addObjectsFromArray:[ParseData parseRoomData:responsData]];
        }
        [[self.view viewWithTag:8000] removeFromSuperview];
        
        [self endUpdateing];
        [self.tableView reloadData];
    } falied:^(NSError *error) {
        [CustomActivityView stopAnimating];
        [CustomAlrter showFailedMessage:@"请求超时" time:2];
    }];
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
                          @"page":@(self.page),
                          @"typeid":self.number,
                          @"ord":self.order,
                          @"title":self.myTitle
                          };
//    version=2.0&device=8D488CB9-7AE0-4606-9B6B-039A833A7FAA&d_type=2&safe_code=safe_code_shangweiji&uid=437415&uuid=24578f1256a6f1bf302b43fe30f86125&igetui_cid=0&page=1&typeid=0&ord=1&title=
    return dic;
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

- (IBAction)toolButtonClick:(UIButton *)sender {
    self.myTitle = @"";
    NSInteger tag = sender.tag;
    
    if (tag != 602) {
        self.lastSelectedButton.selected = NO;
        self.lastSelectedButton = sender;
        sender.selected = YES;
    }
    
    if (tag == 600) {
        self.page = 1;
        self.order = @"1";
        [self loadData];
    }
    if (tag == 601) {
        self.page = 1;
        self.order = @"2";
        [self loadData];
    }
    if (tag == 602) {
        sender.userInteractionEnabled = NO;
        [self addSearchView];
        _isShowTool = YES;
        _isAnimationing = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [UIView animateWithDuration:0.2 animations:^{
            [self.toolView setMarginY:-60];
            [self.tableView setMarginY:40];
            self.tableView.height = self.view.height - 40;
        } completion:^(BOOL finished) {
            _isAnimationing = NO;
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height - 40)];
            bgView.backgroundColor = [UIColor darkGrayColor];
            bgView.alpha = 0.5;
            bgView.tag = 8000;
            [self.view addSubview:bgView];
        }];
    }
}
- (void)addSearchView {
    self.searchBar = [[GYDSearchBar alloc] initWithFrame:CGRectMake(10, 60, KScreenWidth - 70, 35)];
    [self.toolView addSubview:self.searchBar];
    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    [self.searchBar becomeFirstResponder];
    UIButton *quxiao = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton = quxiao;
    quxiao.backgroundColor = [UIColor whiteColor];
    [quxiao setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:6/255.0 green:105/255.0 blue:200/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    quxiao.frame = CGRectMake(KScreenWidth - 60, 60, 60, 38);
    [quxiao addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:quxiao];
    
}
- (void)cancelButtonClick:(UIButton *)button {
    [button removeFromSuperview];
    [[self.view viewWithTag:8000] removeFromSuperview];
    [self.searchBar removeFromSuperview];
    ((UIButton *)[self.toolView viewWithTag:602]).userInteractionEnabled = YES;
    _isShowTool = NO;
    _isAnimationing = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    [UIView animateWithDuration:0.2 animations:^{
        [self.toolView setMarginY:0];
        [self.tableView setMarginY:100];
        self.tableView.height = self.view.height - 100;
    } completion:^(BOOL finished) {
        _isAnimationing = NO;
        button.userInteractionEnabled = NO;
    }];
}

- (IBAction)gotoCatgegory:(id)sender {
    CategoryViewController *categoryVC = [[CategoryViewController alloc] init];
    categoryVC.number = self.number;
    categoryVC.delegate = self;
    [self.navigationController pushViewController:categoryVC animated:YES];
}


#pragma mark -
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EnumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnumTableViewCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateWithModel:self.dataSoure[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomModel *model = self.dataSoure[indexPath.row];
    EnumDetailViewController *detailVC = [[EnumDetailViewController alloc] init];
    detailVC.myId = model.id;
    detailVC.cid = @"14";
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - 
#pragma mark - CategoryViewControllerDelegate

- (void)findOutCategory:(NSString *)name number:(NSString *)number {
    [self.categoryButton setTitle:name forState:UIControlStateNormal];
    self.number = number;
    self.page = 1;
    self.myTitle = @"";
    [self loadData];
}


#pragma mark -
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.cancelButton.selected = NO;
    self.cancelButton.userInteractionEnabled = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.cancelButton.selected = YES;
    self.cancelButton.userInteractionEnabled = NO;
    [textField resignFirstResponder];
    
    NSString *text = textField.text;
    if (text.length == 0) {
        return YES;
    }else {
        self.page = 1;
        self.myTitle = text;
        self.order = @"";
        [self loadData];
    }
    return YES;
}


#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger contentY = scrollView.contentOffset.y;
    
    if (contentY >= ((self.dataSoure.count-2) * 450)) {
        return;
    }
    
    if (contentY <= 35 || _isAnimationing ) {
        return;
    }
    if (contentY - _contentY >=25 ) {
        _contentY = contentY;
        if (!_isShowTool) {
            _isShowTool = YES;
            _isAnimationing = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [UIView animateWithDuration:0.5 animations:^{
                [self.toolView setMarginY:-60];
                [self.tableView setMarginY:40];
                self.tableView.height = self.view.height - 40;
            } completion:^(BOOL finished) {
                _isAnimationing = NO;
            }];
        }
    }else if (_contentY - contentY >= 25 ) {
        _contentY = contentY;
        if (_isShowTool) {
            _isShowTool = NO;
            _isAnimationing = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [UIView animateWithDuration:0.5 animations:^{
                [self.toolView setMarginY:0];
                [self.tableView setMarginY:100];
                self.tableView.height = self.view.height - 100;
            } completion:^(BOOL finished) {
                _isAnimationing = NO;
            }];
        }
    }
}


@end
