//
//  PersonInfo.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/7.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "PersonInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PersonInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _userImage = [[UIImageView alloc]init];
    _userImage.translatesAutoresizingMaskIntoConstraints = NO;
    _userImage.layer.masksToBounds = YES;
    _userImage.layer.cornerRadius = 25;
    NSString *avatorurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"];
    if (avatorurl) {
        if ([avatorurl hasPrefix:@"http"]) {
            [_userImage sd_setImageWithURL:[NSURL URLWithString:avatorurl] placeholderImage:nil];
        }else{
            [_userImage setImage:[UIImage imageWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"]]];
        }
    }else {
        _userImage.image = [UIImage imageNamed:@"firstPage_leftButton"];
    }
    [self.contentView addSubview:_userImage];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_userImage(50)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userImage)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_userImage(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userImage)]];
}

- (void)setAvator:(NSString *)image
{
    if ([image hasPrefix:@"http"]) {
        [_userImage sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:nil];
    }else{
        [_userImage setImage:[UIImage imageWithContentsOfFile:image]];
    }
}

- (void)setUserAvator:(UIImage *)image
{
    self.userImage.image = image;
}

@end