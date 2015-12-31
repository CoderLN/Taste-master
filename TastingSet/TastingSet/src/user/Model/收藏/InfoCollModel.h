//
//  InfoCollModel.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoCollModel : NSObject

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *avgprice;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *short_content;
@property (nonatomic, copy) NSString *authorname;
@property (nonatomic, copy) NSString *releasedate;
@property (nonatomic, copy) NSString *restaurant_lon;
@property (nonatomic, copy) NSString *restaurant_lat;
@property (nonatomic, copy) NSString *mainpic;
@property (nonatomic, copy) NSString *materal;
@property (nonatomic, assign) NSInteger colnum;
@property (nonatomic, copy) NSString *pretime;
@property (nonatomic, copy) NSString *maketime;
@property (nonatomic, copy) NSString *people;


@end
