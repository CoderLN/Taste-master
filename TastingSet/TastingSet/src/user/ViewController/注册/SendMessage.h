//
//  SendMessage.h
//  TastingSet
//  Copyright © 2015年 刘楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendMessageDelegate <NSObject>

- (void)gotoSubmit:(NSInteger) checkNumber;
- (void)repeatSendMessage;

@end

@interface SendMessage : UIView

@property (nonatomic, strong) NSString *telNumber;

@property (nonatomic, weak) id<SendMessageDelegate> delegate;

@end
