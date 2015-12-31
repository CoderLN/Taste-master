//
//  UserModel.m
//  TastingSet
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (instancetype)sharedInstance {
    static UserModel *usermodel = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        usermodel = [[UserModel alloc] init];
    });
    return usermodel;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}



- (NSString *)uuid {
    if (_uuid.length == 0) {
        return @"";
    }
    return _uuid;
}


@end
