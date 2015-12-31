//
//  ServiceViewController.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "ServiceViewController.h"

@interface ServiceViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"服务条款" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:baseURL];
}
- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
