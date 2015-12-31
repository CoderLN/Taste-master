//
//  UserView.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "UserView.h"
#import "UserViewCell.h"
#import "OneViewCell.h"
#import "TastingSetDBManager.h"

#define GetUserInfoUrl @"http://app.legendzest.cn/index.php?g=api241&m=user&a=myinfo"
#define getUserCollUrl @"http://app.legendzest.cn/index.php?g=api241&m=user&a=mycolcount"

@interface UserView ()<UITableViewDelegate, UITableViewDataSource, OneViewCellDelegate>
{
    BOOL _showCollection;
    BOOL _showSectionOne;
}
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;


@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation UserView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UserView" owner:nil options:nil] lastObject];
        self.frame = frame;
        [self customUI];
    }
    return self;
}


- (void)customUI {
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"UserViewCell" bundle:nil] forCellReuseIdentifier:@"UserViewCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OneViewCell" bundle:nil] forCellReuseIdentifier:@"OneViewCellId"];
    self.userImageView.layer.cornerRadius = 35;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 3;
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
    [self.headView addGestureRecognizer:gesture];
}
- (void)login {
    BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:ISUSERLOGIN];
    if (!islogin) {
        if (self.delegate != nil) {
            [self.delegate login];
        }
    }else {
        if (self.delegate != nil) {
            [self.delegate changeUserInfo:self.userInfo];
        }
    }
}

- (void)beginLoadUserInfo {
    [self loadUserInfo];
    [self loadColl];
}

- (void)loadUserInfo {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:GetUserInfoUrl parameters:[self getInfoParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        NSDictionary *dic = [(NSDictionary *)responsData objectForKey:@"res"];
        [self updateWithDic:dic];
    } falied:^(NSError *error) {
        
    }];
}
- (void)loadColl {
    [[NetDataEngine sharedInstance] requesPostDataFrom:getUserCollUrl parameters:[self getCollParameters] success:^(id responsData) {
        self.dic = (NSDictionary *)responsData;
        [self.tableView reloadData];
    } falied:^(NSError *error) {
        
    }];
}


- (NSDictionary *)getInfoParameters {
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"B9A17C7B-C205-45BB-87B1-229A86298CA7",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"igetui_cid":@(0),
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"notifymaxtime":@(0)
                          };
    return dic;
}
- (NSDictionary *)getCollParameters {
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0)
                          };
    return dic;
}
- (void)updateWithDic:(NSDictionary *)dic {
    self.userInfo = dic;
    self.userName.text = [[dic objectForKey:@"uname"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (self.userName.text.length == 0) {
        self.userName.text = @"请登录";
    }
    NSString *introduction = [dic objectForKey:@"introduction"];
    if (introduction.length != 0) {
        self.introductionLabel.hidden = NO;
        self.introductionLabel.text = [introduction stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else {
        self.introductionLabel.hidden = YES;
    }
    
    NSString *imgaeurl = [dic objectForKey:@"img_url"];
    if (imgaeurl.length != 0) {
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[ParseData parseImageUrl:imgaeurl]] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Avatar.png"]] ;
    }else {
        self.userImageView.image = [UIImage imageNamed:@"IMG_Generic_Placeholder_Avatar.png"];
    }
}

- (IBAction)shareButtonClick:(id)sender {
    if (self.delegate != nil) {
        [self.delegate shareButtonClick];
    }
}





#pragma mark - 
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_showSectionOne) {
            return 1;
        }else {
            return 0;
        }
    }else {
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        OneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneViewCellId" forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateWithDic:self.dic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        UserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserViewCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.iconView.image = [UIImage imageNamed:@"IMG_User_IconActivity"];
            cell.titleLabel.text = @"活动";
        }
        if (indexPath.row == 1) {
            cell.iconView.image = [UIImage imageNamed:@"IMG_User_IconMessage"];
            cell.titleLabel.text = @"消息通知";
        }
        if (indexPath.row == 2) {
            cell.iconView.image = [UIImage imageNamed:@"iconfont-shanchu"];
            cell.titleLabel.text = @"清理缓存";
        }
        if (indexPath.row == 3) {
            cell.iconView.image = [UIImage imageNamed:@"IMG_User_IconSetting"];
            cell.titleLabel.text = @"退出登录";
        }
        cell.tableView = tableView;
        cell.section = indexPath.section;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.height/5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return tableView.height/5;
    }else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UserViewCell *headView = [[[NSBundle mainBundle] loadNibNamed:@"UserViewCell" owner:nil options:nil] lastObject];
        headView.tableView = tableView;
        headView.iconView.image = [UIImage imageNamed:@"IMG_User_IconFavorites"];
        headView.titleLabel.text = @"我的收藏夹";
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSectionOne)];
        [headView addGestureRecognizer:gesture];
        return headView;
    }else {
        return nil;
    }
}
- (void)showSectionOne {
    _showSectionOne = !_showSectionOne;
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            TastingSetDBManager *DBManager = [TastingSetDBManager sharedInstance];
            [DBManager deleteAllModel];
            [[SDImageCache sharedImageCache] clearDisk];
            [CustomAlrter showSuccessMessage:@"清理成功" time:2.0];
        }
        if (indexPath.row == 3) {
            BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:ISUSERLOGIN];
            if (islogin) {
                [CustomAlrter showSuccessMessage:@"注销成功" time:2];
                [UserModel sharedInstance].uid = 0;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ISUSERLOGIN];
                [self beginLoadUserInfo];
            }
        }
    }
}

#pragma amrk - 
#pragma mark - OneViewCellDelegate
- (void)collectButtonClick:(NSInteger)tag {
    if (self.delegate != nil) {
        [self.delegate gotoCollectVC:tag];
    }
}









@end
