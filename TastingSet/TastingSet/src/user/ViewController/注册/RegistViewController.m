//
//  RegistViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "RegistViewController.h"
#import "NSString+Check.h"
#import "ServiceViewController.h"
#import "SendMessage.h"
#import "SetPasswordView.h"

#define SendMessageUrl @"http://app.legendzest.cn/index.php?g=api241&m=register&a=getcode"

@interface RegistViewController ()<SendMessageDelegate, SetPasswordViewDelegate>
{
    BOOL _isShowMessage;
    BOOL _isShowSetPassword;
}
@property (weak, nonatomic) IBOutlet UITextField *telNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *isAngreeButton;
@property (weak, nonatomic) IBOutlet UIButton *getTestNumberButton;

@property (nonatomic, strong) SendMessage *sendMessageView;
@property (nonatomic, strong) SetPasswordView *setPasswordView;

@property (nonatomic, assign) NSInteger checkNumber;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getTestNumberButton.layer.cornerRadius = 5.0;
    self.getTestNumberButton.layer.masksToBounds = YES;
    [self.telNumberTextField becomeFirstResponder];
}
- (IBAction)gotoBack:(id)sender {
    if (_isShowSetPassword) {
        [self.setPasswordView removeFromSuperview];
        self.setPasswordView = nil;
        _isShowSetPassword = NO;
    }else if (_isShowMessage) {
        [self.sendMessageView removeFromSuperview];
        self.sendMessageView = nil;
        [self.telNumberTextField becomeFirstResponder];
        _isShowMessage = NO;
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)gettestNumber:(id)sender {
    NSString *telNumber = self.telNumberTextField.text;
    if (telNumber.length == 0) {
        [CustomAlrter showFailedMessage:@"请输入手机号" time:2.0];
        return;
    }
    if (![telNumber checkPhoneNumInput]) {
        [CustomAlrter showFailedMessage:@"手机号格式不正确" time:2.0];
        return;
    }
    if (self.isAngreeButton.selected) {
        [CustomAlrter showFailedMessage:@"请现阅读并同意服务条款" time:2.0];
        return;
    }
    [self sendMessage];
}
- (void)sendMessage {
    [CustomActivityView startAnimating];
    [[NetDataEngine sharedInstance] requesPostDataFrom:SendMessageUrl parameters:[self getParameters] success:^(id responsData) {
        self.checkNumber = [[[(NSDictionary *)responsData objectForKey:@"res"] objectForKey:@"m_code"] integerValue];
        NSLog(@"%ld",self.checkNumber);
        if (self.checkNumber == 0) {
            [CustomAlrter showFailedMessage:@"该手机已经注册" time:2.0];
            [CustomActivityView stopAnimating];
            return ;
        }
        [CustomActivityView stopAnimating];
        if (self.sendMessageView == nil) {
            [self addSendMessageView];
        }
    } falied:^(NSError *error) {
        
    }];
}
- (NSDictionary *)getParameters {
    NSString *telNumber = self.telNumberTextField.text;
    NSDictionary *dic = @{
                          @"version":@(2.0),
                          @"device":@"4FEEF268-7AA4-4E38-A340-A77157E3F8A2",
                          @"d_type":@(2),
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":@"%28null%29",
                          @"uuid":@"",
                          @"igetui_cid":@(0),
                          @"phone":telNumber,
                          @"type":@(1)
                          };
    //    version=2.0&device=4FEEF268-7AA4-4E38-A340-A77157E3F8A2&d_type=2&safe_code=safe_code_shangweiji&uid=%28null%29&uuid=&igetui_cid=0&phone=18224529355&type=1
    return dic;
}

- (void)addSendMessageView {
    _isShowMessage = YES;
    self.sendMessageView = [[SendMessage alloc] initWithFrame:CGRectMake(0, 69, KScreenWidth, self.view.height - 39)];
    self.sendMessageView.delegate = self;
    self.sendMessageView.telNumber = self.telNumberTextField.text;
    [self.view addSubview:self.sendMessageView];
}

- (IBAction)isAngreeButtonClick:(id)sender {
    self.isAngreeButton.selected = !self.isAngreeButton.selected;
}
- (IBAction)showText:(id)sender {
    ServiceViewController *serViceVC = [[ServiceViewController alloc] init];
    [self.navigationController pushViewController:serViceVC animated:YES];
}


#pragma mark - 
#pragma mark - SendMessageDelegate

- (void)gotoSubmit:(NSInteger)checkNumber {
    if (checkNumber != self.checkNumber) {
        [CustomAlrter showFailedMessage:@"验证码错误" time:2.0];
        return;
    }
    if (self.setPasswordView == nil) {
        self.setPasswordView = [[SetPasswordView alloc] initWithFrame:self.sendMessageView.frame];
        self.setPasswordView.delegate = self;
        self.setPasswordView.m_code = checkNumber;
        self.setPasswordView.telNumber = self.telNumberTextField.text;
        [self.view addSubview:self.setPasswordView];
    }
    _isShowSetPassword = YES;
}

- (void)repeatSendMessage {
    [self sendMessage];
}


#pragma  mark - 
#pragma mark - SetPasswordViewDelegate
- (void)registSuccess {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
