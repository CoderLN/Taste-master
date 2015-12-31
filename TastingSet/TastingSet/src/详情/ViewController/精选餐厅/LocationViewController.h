//
//  LocationViewController.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationViewControllerDelegate <NSObject>

- (void)findOutLocaltion:(NSString *)city number:(NSString *)number;

@end

@interface LocationViewController : UIViewController

@property (nonatomic, copy) NSString *number;

@property (nonatomic, weak) id<LocationViewControllerDelegate> delegate;

@end
