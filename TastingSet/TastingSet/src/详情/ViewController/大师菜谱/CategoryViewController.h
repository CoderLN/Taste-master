//
//  CategoryViewController.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryViewControllerDelegate <NSObject>

- (void)findOutCategory:(NSString *)name number:(NSString *)number;

@end

@interface CategoryViewController : UIViewController


@property (nonatomic, copy) NSString *number;

@property (nonatomic, weak) id<CategoryViewControllerDelegate> delegate;

@end
