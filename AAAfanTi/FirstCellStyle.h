//
//  FirstTableViewCell.h
//  afanti
//
//  Created by 尾巴超大号 on 15/11/25.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellModel;

@protocol FirstCellStyleDelegate <NSObject>

@optional

- (void)clickShare:(NSIndexPath *)idx;

- (void)clickCollection:(NSIndexPath *)idx;

@end

@interface FirstCellStyle : UICollectionViewCell

@property (strong, readwrite, nonatomic) CellModel *model;

@property (weak, readwrite, nonatomic) id<FirstCellStyleDelegate> delegate;

@property (assign, readwrite, nonatomic) NSIndexPath *idx;

@property (strong, readwrite, nonatomic) UIButton *collection;

@end
