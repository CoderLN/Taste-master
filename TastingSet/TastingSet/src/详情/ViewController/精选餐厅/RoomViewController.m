//
//  RoomViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "RoomViewController.h"
#import "RoomTableViewCell.h"
#import "GYDSearchBar.h"
#import "LocationViewController.h"
#import "RoomDetailViewController.h"
#import "RoomModel.h"

#import <CoreLocation/CoreLocation.h>

@interface RoomViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UITextFieldDelegate, LocationViewControllerDelegate, CLLocationManagerDelegate>
{
    BOOL _isButtonImage;
    BOOL _isShowTool;
    BOOL _isAnimationing;
    BOOL _isRefreshing;
    BOOL _isLoadingMore;
    NSInteger _contentY;
}


@property (nonatomic, strong) CLLocationManager *locMgr;//经纬度定位

@property (weak, nonatomic) IBOutlet UIView *toolView;

@property (weak, nonatomic) IBOutlet UIImageView *buttonImage;
@property (nonatomic, strong) UIButton *lastSelectedButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (nonatomic, strong) NSMutableArray *dataSoure;


@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSString *mytitle;//搜索内容
@property (nonatomic, copy) NSString *province;//省份
@property (nonatomic, assign) float lat;//经度
@property (nonatomic, assign) float lon;//纬度

@property (nonatomic, strong) GYDSearchBar *searchBar;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation RoomViewController

- (instancetype)init {
    if (self = [super init]) {
        self.page = 1;
        self.order = @"4";
        self.mytitle = @"";
        self.province = @"";
        self.lat = 0.0;
        self.lon = 0.0;
        self.dataSoure = [NSMutableArray array];
    }
    return self;
}

- (void)startLocation {
    if(![CLLocationManager locationServicesEnabled]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的手机定位功能未打开,请进入\"设置\"－>\"隐私\"－>\"定位服务\" 进行设置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    
    if (!_locMgr) {
        // 创建定位管理者
        self.locMgr = [[CLLocationManager alloc] init];
        [self.locMgr requestAlwaysAuthorization];
        //3:设置定位的精度
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
        self.locMgr.delegate = self;
    }
    [self.locMgr startUpdatingLocation];
}

- (BOOL)prefersStatusBarHidden {
    if (_isShowTool) {
        return YES;
    }
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customButton];
    [self setUpTableView];
    [self loadData];
}
- (void)customButton {
    UIButton *button = (UIButton *)[self.view viewWithTag:500];
    button.selected = YES;
    self.lastSelectedButton = button;
}

- (void)setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 450;
    [self createRefreshView];
    [self.tableView registerNib:[UINib nibWithNibName:@"RoomTableViewCell" bundle:nil] forCellReuseIdentifier:@"RoomTableViewCellId"];
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
- (void)loadData {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:RoomUrl parameters:[self getParameters] success:^(id responsData) {
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
    
    NSString *lat = @"";
    NSString *lon = @"";
    if (self.lat != 0.0) {
        lat = [NSString stringWithFormat:@"%f",self.lat];
    }
    if (self.lon != 0.0) {
        lon = [NSString stringWithFormat:@"%f",self.lon];
    }
    
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0),
                          @"lat":lat,
                          @"lon":lon,
                          @"page":@(self.page),
                          @"order":self.order,
                          @"provinceid":self.province,
                          @"title":self.mytitle,
                          };
    return dic;
}

- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)findLocation:(id)sender {
    LocationViewController *locationVC = [[LocationViewController alloc] init];
    locationVC.delegate = self;
    locationVC.number = self.province;
    [self.navigationController pushViewController:locationVC animated:YES];
}


- (IBAction)toolButtonClick:(UIButton *)sender {
    
    self.mytitle = @"";
    self.page = 1;
    self.lat = 0.0;
    self.lon = 0.0;
    if (self.lastSelectedButton.tag == 501 && self.lastSelectedButton != sender) {
        if (_isButtonImage) {
            self.buttonImage.image = [UIImage imageNamed:@"IMG_Cookbook_ consumedown.png"];
            _isButtonImage = NO;
        }else {
            self.buttonImage.image = [UIImage imageNamed:@"IMG_Cookbook_ consumeup.png"];
            _isButtonImage = YES;
        }
    }
    
    NSInteger tag = sender.tag;
    if (tag != 504) {
        self.lastSelectedButton.selected = NO;
        self.lastSelectedButton = sender;
        sender.selected = YES;
    }
    
    if (tag == 500) {
        self.order = @"4";
        [self loadData];
    }
    if (tag == 501) {
        if (_isButtonImage) {
            self.buttonImage.image = [UIImage imageNamed:@"IMG_Cookbook_ consumeup.png_HL.png"];
            _isButtonImage = NO;
            self.order = @"5";
        }else {
            self.buttonImage.image = [UIImage imageNamed:@"IMG_Cookbook_ consumedown_HL.png"];
            _isButtonImage = YES;
            self.order = @"1";
        }
        [self loadData];
    }
    if (tag == 502) {
        self.order = @"2";
        // 开始定位用户的位置
        [self  startLocation];
    }
    if (tag == 503) {
        self.order = @"3";
        [self loadData];
    }
    if (tag == 504) {
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
    ((UIButton *)[self.toolView viewWithTag:504]).userInteractionEnabled = YES;
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




#pragma mark -
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomTableViewCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateWithModel:self.dataSoure[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomModel *model = self.dataSoure[indexPath.row];
    RoomDetailViewController *detailVC = [[RoomDetailViewController alloc] init];
    detailVC.myId = model.id;
    detailVC.cid = @"15";
    [self.navigationController pushViewController:detailVC animated:YES];
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
        self.mytitle = text;
        self.order = @"";
        [self loadData];
    }
    
    return YES;
}

#pragma mark - 
#pragma mark - LocationViewControllerDelegate
- (void)findOutLocaltion:(NSString *)city number:(NSString *)number {
    if ([city isEqualToString:@"所有位置"]) {
        [self.locationButton setTitle:@"全部" forState:UIControlStateNormal];
        [self.locationButton setTitle:@"全部" forState:UIControlStateHighlighted];
    }else {
        if (city.length >2) {
            [self.locationButton setTitle:[NSString stringWithFormat:@"%@..",[city substringToIndex:2]] forState:UIControlStateNormal];
            [self.locationButton setTitle:[NSString stringWithFormat:@"%@..",[city substringToIndex:2]] forState:UIControlStateHighlighted];
        }else {
            [self.locationButton setTitle:city forState:UIControlStateNormal];
            [self.locationButton setTitle:city forState:UIControlStateHighlighted];
        }
        
    }
    self.page = 1;
    self.mytitle = @"";
    self.province = number;
    [self loadData];
}
#pragma mark -
#pragma mark - CLLocationManagerDelegate
/**
 *  只要定位到用户的位置，就会调用（调用频率特别高）
 *  @param locations : 装着CLLocation对象
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //CLLocation中存放的是一些经纬度, 速度等信息. 要获取地理位置需要转换做地理位置编码.
    // 1.取出位置对象
    CLLocation *loc = [locations firstObject];
    // 2.取出经纬度
    CLLocationCoordinate2D coordinate = loc.coordinate;
    
    self.lat = coordinate.latitude;
    self.lon = coordinate.longitude;
    [self loadData];
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
}
//定位信息失败，调用的回调函数
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [CustomAlrter showFailedMessage:@"定位失败" time:2.0];
}



#pragma mark - 
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger contentY = scrollView.contentOffset.y;
    
    if (contentY >= ((self.dataSoure.count-2) * 450)) {
        return;
    }
    
    if (contentY <= 50 || _isAnimationing ) {
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
