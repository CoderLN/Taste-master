//
//  ShowDetailViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "ShowDetailViewController.h"
#import "ShowDetailTableViewCell.h"
#import "ShowDetailCell.h"
#import "ShowModel.h"
#import "LoginViewController.h"

#define detailUrl @"http://app.legendzest.cn/index.php?g=api241&m=show&a=getDetail"

@interface ShowDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIActionSheetDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIView *toolView;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) ShowModel *model;

@end

@implementation ShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    
    [self setUpTableView];
    [self loadData];
}
- (void)customUI {
    self.textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
 //键盘出现时候调用的事件
-(void) keyboadWillShow:(NSNotification *)note{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘的frame
    CGFloat offY = (KScreenHeight-keyboardSize.height)-self.toolView.frame.size.height;//屏幕总高度-键盘高度-UITextField高度
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];//设置动画时间 秒为单位
    self.toolView.frame = CGRectMake(0, offY, self.toolView.width, self.toolView.height);//UITextField位置的y坐标移动到offY
    [UIView commitAnimations];//开始动画效果
    
}
//键盘消失时候调用的事件
 -(void)keyboardWillHide:(NSNotification *)note{
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];
    self.toolView.frame = CGRectMake(0, KScreenHeight - self.toolView.height, self.toolView.width, self.toolView.height);//UITextField位置复原
    [UIView commitAnimations];
}


- (IBAction)gotoBack:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)moreButtonClick:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",@"举报", nil];
    action.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [action showInView:self.view];
}
- (void)loadData {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:detailUrl parameters:[self getParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        self.model = [ParseData parseShowDetailData:responsData];
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
                          @"sid":self.sid
                          };
    return dic;
}
- (NSDictionary *)getCommentParameters {
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0),
                          @"id":self.sid,
                          @"content":self.textField.text
                          };
    return dic;
}
- (NSDictionary *)getlikeParameters {
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0),
                          @"id":self.sid
                          };
    return dic;
}

- (void)setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowDetailCell" bundle:nil] forCellReuseIdentifier:@"ShowDetailCellId"];
}

- (IBAction)likeButtonClick:(id)sender {
    BOOL isUserLogin = [[NSUserDefaults standardUserDefaults] boolForKey:ISUSERLOGIN];
    if (!isUserLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:addLikeUrl parameters:[self getlikeParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        NSInteger code = [[responsData objectForKey:@"code"] integerValue];
        if (code == 200) {
            [CustomAlrter showSuccessMessage:@"点赞成功" time:2.0];
        }else {
            [CustomAlrter showFailedMessage:@"您已经点过赞了" time:2.0];
        }
        [self loadData];
    } falied:^(NSError *error) {
        [CustomActivityView stopAnimating];
        [CustomAlrter showFailedMessage:@"请求超时" time:2];
    }];
    
}
- (IBAction)sendMessage:(id)sender {
    if (self.textField.text.length == 0) {
        return;
    }
    BOOL isUserLogin = [[NSUserDefaults standardUserDefaults] boolForKey:ISUSERLOGIN];
    if (!isUserLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:addCommetUrl parameters:[self getCommentParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        [self.textField resignFirstResponder];
        self.textField.text = @"";
        [CustomAlrter showSuccessMessage:@"评论成功" time:2.0];
        [self loadData];
    } falied:^(NSError *error) {
        [CustomActivityView stopAnimating];
        [CustomAlrter showFailedMessage:@"请求超时" time:2];
    }];
}

#pragma mark -
#pragma  mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
    }
    if (buttonIndex == 1) {
        [CustomActivityView startAnimating];
        [self performSelector:@selector(showMessage) withObject:nil afterDelay:2.0];
    }
}
- (void)showMessage {
    [CustomAlrter showSuccessMessage:@"举报成功" time:2.0];
    [CustomActivityView stopAnimating];
}



#pragma mark -
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.comments.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowDetailCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = self.model.comments;
    [cell updateWithDic:arr[indexPath.row]];
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 450;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ShowDetailTableViewCell *view = [[[NSBundle mainBundle] loadNibNamed:@"ShowDetailTableViewCell" owner:nil options:nil] lastObject];
    [view updateWithModel:self.model tabelView:tableView];
    return view;
}



#pragma mark - 
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}




@end
