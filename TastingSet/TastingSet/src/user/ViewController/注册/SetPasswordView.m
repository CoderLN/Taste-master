//
//  SetPasswordView.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#define AddUserUrl @"http://app.legendzest.cn/index.php?g=api241&m=register&a=adduser"

#import "SetPasswordView.h"


@interface SetPasswordView ()
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *repeatePasswordField;
@property (weak, nonatomic) IBOutlet UIButton *submitPassword;

@end

@implementation SetPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SetPasswordView" owner:nil options:nil] lastObject];
        self.submitPassword.layer.cornerRadius = 5.0;
        self.submitPassword.layer.masksToBounds = YES;
        self.frame = frame;
    }
    return self;
}

- (IBAction)submitPassword:(id)sender {
    if (self.passwordField.text.length == 0 || self.repeatePasswordField.text.length == 0) {
        [self showMessage: @"不能为空"];
        return;
    }
    if (![self.passwordField.text isEqualToString:self.repeatePasswordField.text]) {
        [self showMessage:@"两次输入的密码不一样"];
        return;
    }
    if (self.passwordField.text.length <=6) {
        [self showMessage:@"密码太短"];
        return;
    }
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:AddUserUrl parameters:[self getParameters] success:^(id responsData) {
        [CustomActivityView stopAnimating];
        NSNumber *code = [(NSDictionary *)responsData objectForKey:@"code"];
        if ([code integerValue] == 203) {
            [self showMessage:@"验证码过期"];
        }else if ([code integerValue] == 200 ) {
            [self saveUserMessage:((NSDictionary *)responsData)];
            [self showSuccessMessage:@"注册成功。请立即登陆"];
        }
    } falied:^(NSError *error) {
        
    }];
    
}

- (NSDictionary *)getParameters {
    NSInteger password = [self.passwordField.text integerValue];
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"4FEEF268-7AA4-4E38-A340-A77157E3F8A2",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@"%28null%29",
                          @"uuid":@"",
                          @"igetui_cid":@(0),
                          @"phone":self.telNumber,
                          @"m_code":@(self.m_code),
                          @"pass":@(password)
                          };
    //version=2.0&device=4FEEF268-7AA4-4E38-A340-A77157E3F8A2&d_type=2&safe_code=safe_code_shangweiji&uid=%28null%29&uuid=&igetui_cid=0&phone=18224529355&m_code=655867&pass=1234567
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
//显示正确信息
- (void)showSuccessMessage:(NSString *)str {
    [WSProgressHUD setProgressHUDFont:[UIFont systemFontOfSize:16]];
    [WSProgressHUD showSuccessWithStatus:str];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
        if (self.delegate != nil) {
            [self.delegate registSuccess];
        }
    });
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



@end
