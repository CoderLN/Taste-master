//
//  SearchViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "SearchViewController.h"
#import "GYDSearchBar.h"
#import "InfoTableViewCell.h"
#import "SearchModel.h"
#import "WebViewController.h"

#define searchUrl @"http://app.legendzest.cn/m/c/searchv2"

@interface SearchViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (strong, nonatomic)  UITextField *searchBar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSMutableArray *dataSoure;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    [self setUpTableView];
}

- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)customUI {
    self.searchBar = [[GYDSearchBar alloc] initWithFrame:CGRectMake(90, 30, KScreenWidth - 110, 30)];
    self.searchBar.placeholder = @"搜索你想知道的";
    [self.toolView addSubview:self.searchBar];
    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeySearch;
}
- (void)setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoTableViewCellId"];
}

- (void)loadData {
    [CustomActivityView startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:searchUrl parameters:[self getParameters] success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [CustomActivityView stopAnimating];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            self.dataSoure = [ParseData parseSearchData:dic];
            [self.tableView reloadData];
        }else {
            [CustomAlrter showFailedMessage:@"没有搜索到" time:2];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
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
                          @"curPage":@"1",
                          @"pageSize":@"20",
                          @"keyword":self.searchBar.text,
                          @"cid":@"1",
                          @"flag":@"1"
                          };
    return dic;
}


- (void)addCancelBtn{
    UIButton *quxiao = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton = quxiao;
    quxiao.backgroundColor = [UIColor whiteColor];
    [quxiao setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:6/255.0 green:105/255.0 blue:200/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    quxiao.frame = CGRectMake(KScreenWidth - 68, 27, 60, 35);
    [quxiao addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:quxiao];
}
- (void)cancelButtonClick:(UIButton *)button {
    self.searchBar.width = self.searchBar.width + 50;
    [button removeFromSuperview];
    self.cancelButton = nil;
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.cancelButton.selected = NO;
    self.cancelButton.userInteractionEnabled = YES;
    if (self.cancelButton == nil) {
        self.searchBar.width = self.searchBar.width - 50;
        [self addCancelBtn];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.cancelButton.selected = YES;
    self.cancelButton.userInteractionEnabled = NO;
    [textField resignFirstResponder];
    
    NSString *text = textField.text;
    if (text.length == 0) {
        return YES;
    }else {
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
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTableViewCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell udpateWithSearchModel:self.dataSoure[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchModel *model = self.dataSoure[indexPath.row];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.myId = model.id;
    webVC.cid = @"1";
    [self.navigationController pushViewController:webVC animated:YES];
}


@end
