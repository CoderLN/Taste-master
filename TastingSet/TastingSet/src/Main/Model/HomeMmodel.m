//
//  HomeMmodel.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "HomeMmodel.h"



@implementation HomeMmodel


- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"typeid"]) {
        _typeId = value;
    }
}


@end
