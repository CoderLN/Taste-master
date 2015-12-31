//
//  HomeMmodel.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeMmodel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *authorname;
@property (nonatomic, copy) NSString *short_content;
@property (nonatomic, copy) NSString *releasedate;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *has_video;
@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *kname;
@property (nonatomic, assign) NSInteger wiki_count;
@property (nonatomic, copy) NSString *maxsid;

@end
