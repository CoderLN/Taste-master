//
//  collectViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "CollectViewController.h"
#import "InfoTableViewCell.h"
#import "RoomCollViewCell.h"
#import "EnumCollViewCell.h"
#import "EnumDetailViewController.h"
#import "RoomDetailViewController.h"
#import "WebViewController.h"
#import "InfoCollModel.h"

#define infoUrl @"http://app.legendzest.cn/index.php?g=api241&m=user&a=myArticleCol"
#define roomUrl @"http://app.legendzest.cn/index.php?g=api241&m=user&a=myRestaurantCol"
#define enumUrl @"http://app.legendzest.cn/index.php?g=api241&m=user&a=myTopmenuCol"
#define deleteUrl @"http://app.legendzest.cn/index.php?g=api241&m=user&a=delCol"

@interface CollectViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isRefreshing;
    BOOL _isLoadingMore;
    BOOL _isEditting;
}
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *deleteBgView;

@property (nonatomic, strong) NSMutableArray *dataSoure;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *oldUrl;

@property (nonatomic, copy) NSString *cid;

@property (nonatomic, strong) NSMutableArray *deleteIdArray;

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    [self loadData];
}
- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customUI {
    [self setMyTitle];
    self.page = 1;
    self.deleteIdArray = [NSMutableArray array];
    self.editButton.layer.cornerRadius = 4.0;
    self.editButton.layer.masksToBounds = YES;
    self.dataSoure = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createRefreshView];
    [self registTableViewCell];
}
- (void)setMyTitle {
    if (self.collectType == CollectTypeInfo) {
        self.myTitleLabel.text = @"每日资讯";
        self.url = infoUrl;
    }
    if (self.collectType == CollectTypeRoom) {
        self.myTitleLabel.text = @"精选餐厅";
        self.url = roomUrl;
    }
    if (self.collectType == CollectTypeEnum) {
        self.myTitleLabel.text = @"大师菜单";
        self.url = enumUrl;
    }
    self.oldUrl = self.url;
}

- (void)registTableViewCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoTableViewCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RoomCollViewCell" bundle:nil] forCellReuseIdentifier:@"RoomCollViewCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EnumCollViewCell" bundle:nil] forCellReuseIdentifier:@"EnumCollViewCellId"];
}

- (void)createRefreshView {
    __weak typeof (self)weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [weakSelf setMyTitle];
        if (_isRefreshing) {
            return ;
        }
        [weakSelf.deleteIdArray removeAllObjects];
        weakSelf.url = weakSelf.oldUrl;
        _isEditting = NO;
        [weakSelf showAnimation:NO];
        weakSelf.editButton.selected = NO;
        _isRefreshing = YES;
        weakSelf.page = 1;
        [weakSelf loadData];
    }];
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [weakSelf setMyTitle];
        if (_isLoadingMore) {
            return ;
        }
        [weakSelf.deleteIdArray removeAllObjects];
        weakSelf.url = weakSelf.oldUrl;
        _isEditting = NO;
        [weakSelf showAnimation:NO];
        weakSelf.editButton.selected = NO;
        _isLoadingMore = YES;
        weakSelf.page ++;
        [weakSelf loadData];
    }];
}

- (void)loadData {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:self.url parameters:[self getParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        
        if (_isEditting) {
            [CustomAlrter showSuccessMessage:@"删除成功" time:2.0];
            _isEditting = NO;
            [self setMyTitle];
            self.editButton.selected = NO;
            [self showAnimation:NO];
            [self loadData];
            return ;
        }
        if (self.page == 1) {
            self.dataSoure = [ParseData parseCollData:responsData];
        }else {
            [self.dataSoure  addObjectsFromArray:[ParseData parseCollData:responsData]];
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
    NSDictionary *dic;
    if (!_isEditting) {
        dic = @{
              @"version":@(2.0),
              @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
              @"d_type":@(2),
              @"safe_code":@"safe_code_shangweiji",
              @"uid":@(userModel.uid),
              @"uuid":userModel.uuid,
              @"igetui_cid":@(0),
              @"page":@(self.page),
              };
    }
    if (_isEditting) {
        NSString * str = [self.deleteIdArray componentsJoinedByString:@","];
        dic = @{
              @"version":@(2.0),
              @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
              @"d_type":@(2),
              @"safe_code":@"safe_code_shangweiji",
              @"uid":@(userModel.uid),
              @"uuid":userModel.uuid,
              @"igetui_cid":@(0),
              @"cid":self.cid,
              @"id":str
              };
    }
    return dic;
}

- (IBAction)editButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isEditting = !_isEditting;
    [self showAnimation:_isEditting];
    [self.tableView reloadData];
}
- (void)showAnimation:(BOOL) rest {
    if (rest) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.deleteBgView setMarginY:KScreenHeight - 40];
        } completion:^(BOOL finished) {
            self.tableView.height = self.tableView.height - 40;
        }];
    }else {
        self.tableView.height = self.tableView.height + 40;
        [UIView animateWithDuration:0.3 animations:^{
            [self.deleteBgView setMarginY:KScreenHeight];
        }];
    }
}


- (IBAction)deleteButtonClick:(UIButton *)sender {
    if (self.deleteIdArray.count == 0) {
        return;
    }
    self.oldUrl = self.url;
    self.url = deleteUrl;
    if (self.collectType == CollectTypeInfo) {
        self.cid = @"1";
        [self loadData];
    }
    if (self.collectType == CollectTypeRoom) {
        self.cid = @"15";
        [self loadData];
    }
    if (self.collectType == CollectTypeEnum) {
        self.cid = @"14";
        [self loadData];
    }
}


#pragma mark -
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.collectType == CollectTypeInfo) {
        InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTableViewCellId" forIndexPath:indexPath];
        [cell showDeleteButton:_isEditting array:self.deleteIdArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateWithModel:self.dataSoure[indexPath.row]];
        return cell;
    }
    if (self.collectType == CollectTypeRoom) {
        RoomCollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCollViewCellId" forIndexPath:indexPath];
        [cell showDeleteButton:_isEditting array:self.deleteIdArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateWithModel:self.dataSoure[indexPath.row]];
        return cell;
    }
    if (self.collectType == CollectTypeEnum) {
        EnumCollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnumCollViewCellId" forIndexPath:indexPath];
        [cell showDeleteButton:_isEditting array:self.deleteIdArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateWithModel:self.dataSoure[indexPath.row]];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoCollModel *model = self.dataSoure[indexPath.row];
    if (self.collectType == CollectTypeInfo) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.myId = model.sid;
        webVC.cid = @"1";
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if (self.collectType == CollectTypeRoom) {
        RoomDetailViewController *roomDetailVC = [[RoomDetailViewController alloc] init];
        roomDetailVC.myId = model.sid;
        roomDetailVC.cid = @"15";
        [self.navigationController pushViewController:roomDetailVC animated:YES];
    }
    if (self.collectType == CollectTypeEnum) {
        EnumDetailViewController *detailVC = [[EnumDetailViewController alloc] init];
        detailVC.myId = model.sid;
        detailVC.cid = @"14";
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}







@end
