//
//  ShowViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "ShowViewController.h"
#import "GYDSearchBar.h"
#import "ShowTableViewCell.h"
#import "NumberTableViewCell.h"
#import "ShowModel.h"
#import "UpImageViewController.h"
#import "ShowDetailViewController.h"
#import "ShowSearchViewController.h"
#import "LoginViewController.h"

@interface ShowViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UpImageViewControllerDelgate, ShowTableViewCellDelgate>
{
    BOOL _isShowTool;//是否显示顶部的返回视图
    BOOL _isAnimationing;//顶部的返回视图动画
    BOOL _isRefreshing;
    BOOL _isLoadingMore;
    NSInteger _contentY;//偏移量
}
@property (weak, nonatomic) IBOutlet UIButton *camerButton;

@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (nonatomic, strong) UIButton *lastSelectedButton;
@property (nonatomic, assign) NSInteger order;//根据order返回不同的数据
@property (nonatomic, copy) NSString *lastid;//当前页cell的最后一个cell的模型id
@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) GYDSearchBar *searchBar;
@property (nonatomic, strong) UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSoure;
@end

@implementation ShowViewController
- (instancetype)init {
    if (self = [super init]) {
        self.order = 2;
        self.lastid = @"0";
        self.url = ShowUrl;
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
    UIButton *button = (UIButton *)[self.view viewWithTag:700];
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
    self.tableView.rowHeight = 470;
    [self createRefreshView];
    [self registTableViewCell];
}
- (void)registTableViewCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShowTableViewCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NumberTableViewCell" bundle:nil] forCellReuseIdentifier:@"NumberTableViewCellId"];
}

- (void)createRefreshView {
    __weak typeof (self)weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (_isRefreshing) {
            return ;
        }
        _isRefreshing = YES;
        self.lastid = @"0";
        [weakSelf loadData];
    }];
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (_isLoadingMore) {
            return ;
        }
        _isLoadingMore = YES;
        [weakSelf loadData];
    }];
}
- (void)loadData {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:self.url parameters:[self getParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        
        if ([[(NSDictionary *)responsData objectForKey:@"code"] integerValue] != 200) {
            [self.dataSoure removeAllObjects];
            [self.tableView reloadData];
            if (self.order == 4) {
                [CustomAlrter showFailedMessage:@"您还没有关注任何人" time:3.0];
            }else {
                [CustomAlrter showFailedMessage:@"没有任何内容" time:3.0];
            }
            self.tableView.bounces = NO;
            return ;
        }
        
        if ([self.lastid isEqualToString:@"0"]) {
                [self.dataSoure removeAllObjects];
                self.dataSoure = [ParseData parseShowData:responsData];
                ShowModel *model = [self.dataSoure lastObject];
                self.lastid = model.id;
        }else {
                [self.dataSoure  addObjectsFromArray:[ParseData parseShowData:responsData]];
                ShowModel *model = [self.dataSoure lastObject];
                self.lastid = model.id;
        }
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
                          @"order":@(self.order),
                          @"lastid":self.lastid
                          };
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
    
    NSInteger tag = sender.tag;
    if (tag != 705) {
        self.lastSelectedButton.selected = NO;
        self.lastSelectedButton = sender;
        sender.selected = YES;
    }
    
    if (tag == 700) {
        self.order = 2;
        self.lastid = @"0";
        [self loadData];
    }
    if (tag == 701) {
        self.order = 0;
        self.lastid = @"0";
        [self loadData];
    }
    if (tag == 702) {
        self.order = 1;
        self.lastid = @"0";
        self.tableView.bounces = NO;
        [self loadData];
    }else {
        self.tableView.bounces = YES;
    }
    if (tag == 703) {
        self.order = 4;
        self.lastid = @"0";
        [self loadData];
    }
    if (tag == 704) {
        self.order = 3;
        self.lastid = @"0";
        [self loadData];
    }
    if (tag == 705) {
        //搜索
        ShowSearchViewController *searchVC = [[ShowSearchViewController alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}

//选择从相机或相册选取图片
- (void)pickImageFromAlbum:(NSInteger )type {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (type == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//相机按钮点击
- (IBAction)camerButtonClick:(id)sender {
    BOOL isUserLogin = [[NSUserDefaults standardUserDefaults] boolForKey:ISUSERLOGIN];
    if (!isUserLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册中选择", nil];
    action.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [action showInView:self.view];
}


#pragma mark -
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.order == 1) {
        return 10;
    }
    return self.dataSoure.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.order != 1 ) {
        ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowTableViewCellId" forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateWithModel:self.dataSoure[indexPath.row]];
        return cell;
    }
    if (self.order == 1) {
        NumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NumberTableViewCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateWithModel:self.dataSoure[indexPath.row] number:indexPath.row+1];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.order == 1 ) {
        return 50;
    }else {
        return 470;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowModel *model = self.dataSoure[indexPath.row];
    ShowDetailViewController *detailVC = [[ShowDetailViewController alloc] init];
    detailVC.sid = model.id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma maek - 
#pragma mark - ShowTableViewCellDelgate
//点赞请求数据
- (NSDictionary *)getlikeParameters:(NSString *)sid {
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0),
                          @"id":sid
                          };
    return dic;
}
//点赞按钮点击
- (void)likeButtonClick:(ShowModel *)model {
    BOOL isUserLogin = [[NSUserDefaults standardUserDefaults] boolForKey:ISUSERLOGIN];
    if (!isUserLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:addLikeUrl parameters:[self getlikeParameters:model.id] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        NSInteger code = [[responsData objectForKey:@"code"] integerValue];
        if (code == 200) {
            [CustomAlrter showSuccessMessage:@"点赞成功" time:2.0];
        }else {
            [CustomAlrter showFailedMessage:@"您已经点过赞了" time:2.0];
        }
    } falied:^(NSError *error) {
        [CustomActivityView stopAnimating];
        [CustomAlrter showFailedMessage:@"请求超时" time:2];
    }];
}
//评论
- (void)commentButtonClick:(ShowModel *)model {
    ShowDetailViewController *detailVC = [[ShowDetailViewController alloc] init];
    detailVC.sid = model.id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
//更多
- (void)moreButtonClick:(ShowModel *)model {
    ShowDetailViewController *detailVC = [[ShowDetailViewController alloc] init];
    detailVC.sid = model.id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -
#pragma  mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self pickImageFromAlbum:0];
    }
    if (buttonIndex == 1) {
        [self pickImageFromAlbum:1];
    }
}

#pragma mark -
#pragma  mark - UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:NO completion:nil];
    UpImageViewController *upImageVC = [[UpImageViewController alloc] init];
    upImageVC.delegate = self;
    upImageVC.image = image;
    [self presentViewController:upImageVC animated:YES completion:nil];
}
- (void)success {
    [self dismissViewControllerAnimated:YES completion:nil];
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
