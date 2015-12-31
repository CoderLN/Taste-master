//
//  ChangeUserInfoViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "ChangeUserInfoViewController.h"
#import "SubViewController.h"


#define uploadImageUrl @"http://app.legendzest.cn/index.php?g=api241&m=user&a=upheadimg"

@interface ChangeUserInfoViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *userView;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *qianmingLabel;

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *qianmingView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;


@end

@implementation ChangeUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    UITapGestureRecognizer *changeImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage)];
    [self.userView addGestureRecognizer:changeImageGesture];
    
    UITapGestureRecognizer *changeNamegesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeName)];
    [self.usernameView addGestureRecognizer:changeNamegesture];
    
    UITapGestureRecognizer *changeqianmingGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeQianming)];
    [self.qianmingView addGestureRecognizer:changeqianmingGesture];
    
    UITapGestureRecognizer *changePasswordGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePassword)];
    [self.passwordView addGestureRecognizer:changePasswordGesture];
}
- (void)customUI {
    self.userImageView.layer.cornerRadius = 40;
    self.userImageView.layer.masksToBounds = YES;
    
    NSString *imageurl = [self.dic objectForKey:@"img_url"];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[ParseData parseImageUrl:imageurl]] placeholderImage:[UIImage imageNamed:@"IMG_Generic_Placeholder_Avatar.png"]];
    self.userNameLabel.text = [[self.dic objectForKey:@"uname"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.qianmingLabel.text = [[self.dic objectForKey:@"introduction"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//修改头像
- (void)changeImage {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册中选择", nil];
    action.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [action showInView:self.view];
}
//修改名字
- (void)changeName {
    SubViewController *subVC = [[SubViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    subVC.block = ^(NSInteger type, NSString *username){
        weakSelf.userNameLabel.text = username;
        [CustomAlrter showSuccessMessage:@"修改成功" time:2.0];
    };
    subVC.type = 0;
    subVC.username = self.userNameLabel.text;
    [self.navigationController pushViewController:subVC animated:YES];
}
//修改签名
- (void)changeQianming {
    SubViewController *subVC = [[SubViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    subVC.block = ^(NSInteger type, NSString *qianming){
        weakSelf.qianmingLabel.text = qianming;
        [CustomAlrter showSuccessMessage:@"修改成功" time:2.0];
    };
    subVC.type = 1;
    subVC.qianming = self.qianmingLabel.text;
    [self.navigationController pushViewController:subVC animated:YES];
}
//修改密码
- (void)changePassword {
    SubViewController *subVC = [[SubViewController alloc] init];
    subVC.block = ^(NSInteger type, NSString *username){
        [CustomAlrter showSuccessMessage:@"修改成功" time:2.0];
    };
    subVC.type = 2;
    [self.navigationController pushViewController:subVC animated:YES];
}



- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//选择从相机或相册选取图片
- (void)pickImageFromAlbum:(NSInteger )type {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (type == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//上传图片
- (void)beginUploadImage:(UIImage *)image {
    [CustomActivityView startAnimating];
    
    //压缩图片
    UIImage *newImg=[UIImage imageWithImageSimple:image scaledToSize:CGSizeMake(300, 300)];
    [NetDataEngine uploadImage:newImg url:uploadImageUrl parameters:[self getParameters] name:@"image_data" fileName:@"pic.jpg" success:^(id responsData) {
        [CustomActivityView stopAnimating];
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responsData options:NSJSONReadingAllowFragments error:nil];
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code == 200) {
            [CustomAlrter showSuccessMessage:@"上传成功" time:2.0];
            self.userImageView.image = image;
        }else {
            [CustomAlrter showFailedMessage:@"上传失败" time:2.0];
        }
    } falied:^(NSError *error) {
        [CustomAlrter showFailedMessage:@"上传失败" time:2.0];
    }];
}


- (NSDictionary *)getParameters {
    UserModel *userModel = [UserModel sharedInstance];
    NSDictionary *dic = @{
                          @"version":@"2.0",
                          @"device":@"A0D74BE2-3EA9-47F2-8810-D45B5C5A6ECC",
                          @"safe_code":@"safe_code_shangweiji",
                          @"uid":[NSString stringWithFormat:@"%ld",userModel.uid],
                          @"uuid":userModel.uuid,
                          @"igetui_cid":@"0",
                          @"d_type":@"2"
                          };
    return dic;
}


#pragma mark - 
#pragma  mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self pickImageFromAlbum:0];
    }
    if (buttonIndex == 1) {
        [self pickImageFromAlbum:1];
    }
}
#pragma mark -
#pragma  mark - UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self beginUploadImage:image];
}



@end
