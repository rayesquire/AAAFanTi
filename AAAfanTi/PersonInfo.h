//
//  PersonInfo.h
//  afanti
//
//  Created by 尾巴超大号 on 15/12/7.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfo : UITableViewCell

@property (nonatomic, readwrite, strong) UIImageView *userImage;  // 头像

- (void)setAvator:(NSString *)image;

- (void)setUserAvator:(UIImage *)image;


@end
