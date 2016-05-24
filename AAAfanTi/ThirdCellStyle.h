//
//  SecondTableViewCell.h
//  afanti
//
//  Created by 尾巴超大号 on 15/12/4.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellModel;

@protocol ThirdCellStyleDelegate <NSObject>

@optional

- (void)clickShare:(NSIndexPath *)idx;

- (void)clickCollection:(NSIndexPath *)idx;

@end

@interface ThirdCellStyle : UICollectionViewCell

@property (strong, readwrite, nonatomic) CellModel *model;

@property (weak, readwrite, nonatomic) id<ThirdCellStyleDelegate> delegate;

@property (assign, readwrite, nonatomic) NSIndexPath *idx;

@property (strong, readwrite, nonatomic) UIButton *collection;


@end
