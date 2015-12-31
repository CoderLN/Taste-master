//
//  UpImageViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "UpImageViewController.h"

#define upImageUrl @"http://app.legendzest.cn/index.php?g=api241&m=user&a=addshow"


@interface UpImageViewController ()

@end

@implementation UpImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconView.image = self.image;
    
    self.textView.layer.cornerRadius = 6;
    self.textView.layer.masksToBounds = YES;
    UIColor *customColor  = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1.0];
    self.textView.layer.borderColor = customColor.CGColor;
    self.textView.layer.borderWidth = 2.0;
}
- (IBAction)gotoBack:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)updateImage:(id)sender {
    if (self.textView.text.length == 0) {
        [CustomAlrter showFailedMessage:@"说点什么吧" time:2.0];
    }else {
        [self.view endEditing:YES];
        [CustomActivityView startAnimating];
        //压缩图片
        UIImage *newImg=[UIImage imageWithImageSimple:self.iconView.image scaledToSize:CGSizeMake(300, 300)];
        [NetDataEngine uploadImage:newImg url:upImageUrl parameters:[self getParameters] name:@"pic" fileName:@"shareImage.jpg" success:^(id responsData) {
            [CustomActivityView stopAnimating];
            NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responsData options:NSJSONReadingAllowFragments error:nil];
            NSInteger code = [[dic objectForKey:@"code"] integerValue];
            if (code == 200) {
                [CustomAlrter showSuccessMessage:@"上传成功" time:2.0];
                if (self.delegate != nil) {
                    [self.delegate success];
                }
            }else {
                [CustomAlrter showFailedMessage:@"上传失败" time:2.0];
            }
        } falied:^(NSError *error) {
            [CustomAlrter showFailedMessage:@"上传失败" time:2.0];
        }];
    }
}
- (NSDictionary *)getParameters {
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@"2.0",
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"d_type":@"2",
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":[NSString stringWithFormat:@"%ld",userModel.uid],
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@"0",
                          @"title":self.textView.text,
                          @"content":@""
                          };
    return dic;
}




@end
