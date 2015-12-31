//
//  LoginViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+Check.h"
#import "RegistViewController.h"


#define loginUrl @"http://app.legendzest.cn/index.php?g=api241&m=login&a=usephone"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@property (weak, nonatomic) IBOutlet UIButton *numberLogin;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
}
- (void)customUI {
    self.registButton.layer.cornerRadius = 5.0;
    self.registButton.layer.masksToBounds = YES;
    
    self.numberLogin.layer.cornerRadius = 5.0;
    self.numberLogin.layer.masksToBounds = YES;
    
    [self.userNameTextField becomeFirstResponder];
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:gesture];
}
- (void)endEdit {
    [self.view endEditing:YES];
}



- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)gotoRegist:(id)sender {
    RegistViewController *registVC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}
- (IBAction)gotoFindPassword:(id)sender {
    
}
- (IBAction)gotoLogin:(id)sender {
    NSString *text = self.userNameTextField.text;
    if (text.length == 0) {
        [self showMessage:@"手机号不能为空"];
        return;
    }
    if (![text checkPhoneNumInput]) {
        [self showMessage:@"手机号格式不对"];
        return;
    }
    NSString *password = self.passWordTextField.text;
    if (password.length == 0) {
        [self showMessage:@"密码不能为空"];
        return;
    }
    [self beginLogin];
}

- (void)beginLogin {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:loginUrl parameters:[self getParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        
        NSNumber *code = [(NSDictionary *)responsData objectForKey:@"code"];
        if ([code integerValue] == 206) {
            [self showMessage:@"密码错误"];
            return ;
        }else if ([code integerValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISUSERLOGIN];
            [self saveUserMessage:(NSDictionary *)responsData];
            [self showSuccesMessage:@"登陆成功"];
        }else {
            [self showMessage:@"未知错误"];
        }
    } falied:^(NSError *error) {
        
    }];
}
- (void)saveUserMessage:(NSDictionary *)userInfo {
    NSError *error = nil;
    NSDictionary *dic = [userInfo objectForKey:@"res"];
    NSString *uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
    NSString *uuid = [dic objectForKey:@"uuid"];
    [SSKeychain setPassword:uid forService:@"com.qianfeng.TastingSet" account:@"uid" error:&error];
    [SSKeychain setPassword:uuid forService:@"com.qianfeng.TastingSet" account:@"uuid" error:&error];
    [SSKeychain setPassword:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"d_type"]] forService:@"com.qianfeng.TastingSet" account:@"d_type" error:&error];
    [SSKeychain setPassword:[userInfo objectForKey:@"cid"] forService:@"com.qianfeng.TastingSet" account:@"cid" error:&error];
    UserModel *userModel = [UserModel sharedInstance];
    userModel.uid = [uid integerValue];
    userModel.uuid = uuid;
    userModel.d_type = [userInfo objectForKey:@"d_type"];
    userModel.cid = [userInfo objectForKey:@"cid"];
}
- (NSDictionary *)getParameters {
    NSString *userTel = self.userNameTextField.text;
    NSString *password = self.passWordTextField.text;
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"4FEEF268-7AA4-4E38-A340-A77157E3F8A2",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@"",
                          @"uuid":@"",
                          @"igetui_cid":@(0),
                          @"phone":userTel,
                          @"pass":password
                          };
    //version=2.0&device=B9A17C7B-C205-45BB-87B1-229A86298CA7&d_type=2&safe_code=safe_code_shangweiji&uid=&uuid=&igetui_cid=0&phone=18224529355&pass=12345678
    return dic;
}


//显示错误信息
- (void)showMessage:(NSString *)str {
    [WSProgressHUD setProgressHUDFont:[UIFont systemFontOfSize:16]];
    [WSProgressHUD showErrorWithStatus:str];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
}
//显示成功信息
- (void)showSuccesMessage:(NSString *)str {
    [WSProgressHUD setProgressHUDFont:[UIFont systemFontOfSize:16]];
    [WSProgressHUD showSuccessWithStatus:str];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
}









@end
