//
//  CategoryViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#define categoryUrl @"http://app.legendzest.cn/index.php?g=api241&m=cookbook&a=getType"

#import "CategoryViewController.h"
#import "LocationTableViewCell.h"
@interface CategoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSoure;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self loadData];
}

- (void)setUpTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    [self.tableView registerNib:[UINib nibWithNibName:@"LocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
}

- (void)loadData {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:categoryUrl parameters:[self getParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        self.dataSoure = [(NSDictionary *)responsData objectForKeyedSubscript:@"res"];
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
                          };

    return dic;
}


- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataSoure[indexPath.row];
    cell.cityLabel.text = [dic objectForKey:@"name"];
    NSString *number = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"id"] integerValue]];
    if ([self.number isEqual:number]) {
        cell.iconView.hidden = NO;
    }else {
        cell.iconView.hidden = YES;
    }
    if (self.number.length == 0 && indexPath.row == 0 ) {
        cell.iconView.hidden = NO;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSoure[indexPath.row];
    if (self.delegate != nil) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate findOutCategory:[dic objectForKey:@"name"] number:[NSString stringWithFormat:@"%ld",[[dic objectForKey:@"id"] integerValue]]];
    }
}

@end
