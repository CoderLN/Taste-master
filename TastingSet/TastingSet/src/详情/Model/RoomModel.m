//
//  RoomModel.m
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import "RoomModel.h"

@implementation RoomModel



- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqual:@"typeid"]) {
        _typeId = value;
    }
}

@end
