//
//  TopMenuView.h
//  afanti
//
//  Created by 尾巴超大号 on 15/11/24.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopMenuViewDelegate <NSObject>

@optional
- (void)changeView:(UIButton *)button;

@end

@interface TopMenuView : UIView

@property (nonatomic,copy) NSMutableArray *menus;

@property (assign, readwrite, nonatomic) NSInteger currentTag;

@property (weak, readwrite, nonatomic) id<TopMenuViewDelegate> delegate;

- (instancetype)initWithMenus:(NSMutableArray *)menus type:(NSMutableArray *)typeArray style:(NSMutableArray *)styleArray;

@end
