//
//  MineTableViewCell.h
//  afanti
//
//  Created by 尾巴超大号 on 15/12/6.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell

@property (nonatomic, readwrite, strong) UIImageView *igv;

@property (nonatomic, readwrite, strong) UILabel *label;

+ (instancetype)MineTableViewCellWithTableView:(UITableView *)tableView;

@end
