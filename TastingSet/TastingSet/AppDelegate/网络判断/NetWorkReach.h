//
//  NetWorkReach.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkReach : NSObject

@property (nonatomic, assign) BOOL isNoNetReachable;


+ (instancetype)sharedInstance;

- (void)initNetwork;

@end
