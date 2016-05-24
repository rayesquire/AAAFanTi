//
//  ChannelButton.h
//  afanti
//
//  Created by 尾巴超大号 on 15/11/30.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChannelButtonDelegate <NSObject>

@optional

- (void)deleteButton:(NSInteger)index;

@end

@interface ChannelButton : UIView

@property (strong, readwrite, nonatomic) UIImage *image;

@property (copy, readwrite, nonatomic) NSString *buttonTitle;

@property (assign, readwrite, nonatomic) BOOL edited;

@property (assign, readwrite, nonatomic) NSInteger index;    // use to post

@property (nonatomic, readwrite, assign) NSInteger style;

@property (weak, readwrite, nonatomic) id<ChannelButtonDelegate> delegate;

- (instancetype)initWithIndex:(NSInteger)index style:(NSInteger)style;

@end
