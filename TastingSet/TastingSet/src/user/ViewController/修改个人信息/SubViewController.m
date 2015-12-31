//
//  SubViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "SubViewController.h"

#define changeurl @"http://app.legendzest.cn/index.php?g=api241&m=user&a=edituserinfo"
#define changepasswordurl @"http://app.legendzest.cn/index.php?g=api241&m=user&a=changepass"


@interface SubViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mytitle;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) UITextField *user;

@property (nonatomic, strong) UITextView *qianmingView;

@property (nonatomic, strong) UITextField *oldPassword;
@property (nonatomic, strong) UITextField *nowPassword;
@property (nonatomic, strong) UITextField *surePassword;

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveButton.layer.cornerRadius = 5.0;
    self.saveButton.layer.masksToBounds = YES;
    [self customUI];
}
- (void)customUI {
    if (self.type == 0) {
        self.mytitle.text = @"姓名";
        [self addUserTextField];
    }else if (self.type == 1){
        self.mytitle.text = @"修改个性签名";
        [self addQianmingTextView];
    }else if (self.type == 2) {
        self.mytitle.text = @"修改密码";
        [self addChangePassword];
    }
}
- (void)addChangePassword {
    self.oldPassword = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, KScreenWidth - 40, 30)];
    self.oldPassword.borderStyle = UITextBorderStyleRoundedRect;
    self.oldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.oldPassword.placeholder = @"请输入原密码";
    self.oldPassword.secureTextEntry = YES;
    [self.oldPassword becomeFirstResponder];
    
    self.nowPassword = [[UITextField alloc] initWithFrame:CGRectMake(20, 150, KScreenWidth - 40, 30)];
    self.nowPassword.borderStyle = UITextBorderStyleRoundedRect;
    self.nowPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nowPassword.placeholder = @"请输入新密码";
    self.nowPassword.secureTextEntry = YES;
    
    self.surePassword = [[UITextField alloc] initWithFrame:CGRectMake(20, 185, KScreenWidth - 40, 30)];
    self.surePassword.borderStyle = UITextBorderStyleRoundedRect;
    self.surePassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.surePassword.placeholder = @"请再次输入新密码";
    self.surePassword.secureTextEntry = YES;
    
    [self.view addSubview:self.oldPassword];
    [self.view addSubview:self.nowPassword];
    [self.view addSubview:self.surePassword];
}
- (void)addQianmingTextView {
    self.qianmingView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, KScreenWidth - 40, 150)];
    self.qianmingView.font = [UIFont systemFontOfSize:19];
    self.qianmingView.scrollEnabled = NO;
    self.qianmingView.text = self.qianming;
    [self.qianmingView becomeFirstResponder];
    [self.view addSubview:self.qianmingView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, self.qianmingView.maxY + 10, 120, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"30个字符";
    [self.view addSubview:label];
}
- (void)addUserTextField {
    self.user = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, KScreenWidth - 40, 30)];
    
    self.user.borderStyle = UITextBorderStyleRoundedRect;
    self.user.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.user];
    self.user.text = self.username;
    [self.user becomeFirstResponder];
}


- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//保存信息
- (IBAction)saveMessage:(id)sender {
    if (self.type == 0) {
        if (self.user.text.length == 0) {
            [CustomAlrter showFailedMessage:@"姓名不能为空" time:2.0];
            return;
        }
        [self saveUsername];
    }
    if (self.type == 1) {
        
        if (self.qianmingView.text.length > 30) {
            [CustomAlrter showFailedMessage:@"不能超过30个字符" time:2.0];
            return;
        }
        
        [self saveQianming];
    }
    if (self.type == 2) {
        NSString *oldpassword = self.oldPassword.text;
        NSString *nowpassword = self.nowPassword.text;
        NSString *surepassword = self.surePassword.text;
        if (oldpassword.length == 0 || nowpassword.length == 0 || surepassword.length == 0) {
            [CustomAlrter showFailedMessage:@"不能为空" time:2.0];
            return;
        }
        if (![nowpassword isEqualToString:surepassword]) {
            [CustomAlrter showFailedMessage:@"两次输入的密码不一致" time:2.0];
            return;
        }
        if (nowpassword.length < 6) {
            [CustomAlrter showFailedMessage:@"密码太简单" time:2.0];
            return;
        }
        [self savePassword];
    }
    
}
- (void)savePassword {
    [CustomActivityView startAnimating];
    
    NSString *oldpassword = self.oldPassword.text;
    NSString *nowpassword = self.nowPassword.text;
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0),
                          @"old_pass":oldpassword,
                          @"new_pass":nowpassword
                          };
    [[NetDataEngine sharedInstance] requesPostDataFrom:changepasswordurl parameters:dic success:^(id responsData) {
        [CustomActivityView stopAnimating];
        NSInteger code = [[(NSDictionary *)responsData objectForKey:@"code"] integerValue];
        if (code == 206) {
            [CustomAlrter showFailedMessage:@"密码错误" time:2.0];
            return ;
        }
        if (self.block != nil) {
            self.block(2,nil);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } falied:^(NSError *error) {
    }];
}

- (void)saveQianming {
    
    [CustomActivityView startAnimating];
    
    NSString *qianming = [self.qianmingView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0),
                          @"ulable":qianming
                          };
    [[NetDataEngine sharedInstance] requesPostDataFrom:changeurl parameters:dic success:^(id responsData) {
        [CustomActivityView stopAnimating];
        if (self.block != nil) {
            self.block(1,self.qianmingView.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } falied:^(NSError *error) {
        
    }];
}



- (void)saveUsername {
    [CustomActivityView startAnimating];
    
    NSString *username = [self.user.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@(userModel.uid),
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@(0),
                          @"uname":username
                          };
    [[NetDataEngine sharedInstance] requesPostDataFrom:changeurl parameters:dic success:^(id responsData) {
        [CustomActivityView stopAnimating];
        if (self.block != nil) {
            self.block(0,self.user.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } falied:^(NSError *error) {
        
    }];

}

@end
