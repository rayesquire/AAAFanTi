//
//  CollectionTableViewCell.h
//  afanti
//
//  Created by 尾巴超大号 on 15/12/15.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <UIKit/UIKit.h>

@class First;

@interface CollectionTableViewCell : UITableViewCell

@property (strong, readwrite, nonatomic) First *model;

@property (assign, readwrite, nonatomic) NSIndexPath *idx;

+ (instancetype)collectionTableViewCellWithTableView:(UITableView *)tableView;

@end
