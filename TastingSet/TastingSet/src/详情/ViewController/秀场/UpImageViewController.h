//
//  UpImageViewController.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpImageViewControllerDelgate <NSObject>

- (void)success;

@end

@interface UpImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) id<UpImageViewControllerDelgate> delegate;

@property (nonatomic, strong)UIImage *image;

@end
