//
//  MineTableViewCell.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/6.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "MineTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MineTableViewCell

+ (instancetype)MineTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"mineTabelViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _igv = [[UIImageView alloc]init];
    _igv.translatesAutoresizingMaskIntoConstraints = NO;
    _igv.layer.masksToBounds = YES;
    _igv.layer.cornerRadius = 25;
    [self.contentView addSubview:_igv];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_igv(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_igv(50)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"] hasPrefix:@"http"]) {
            [_igv sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"]] placeholderImage:nil];
        }else {
            [_igv setImage:[UIImage imageWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"]]];
        }
    }else {
        [_igv setImage:[UIImage imageNamed:@"firstPage_leftButton"]];
    }
    
    _label = [[UILabel alloc]init];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_label];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_igv]-15-[_label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label,_igv)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_igv attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"name"]) {
        [_label setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
    }else {
        _label.text = @"阿凡提旅游";
    }
}




@end
