//
//  CollectionTableViewCell.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/15.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import "CellModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface CollectionTableViewCell ()

@property (strong, readwrite, nonatomic) UILabel *name;

@property (strong, readwrite, nonatomic) UILabel *time;

@property (strong, readwrite, nonatomic) UILabel *browse;

@property (strong, readwrite, nonatomic) UIImageView *icon;

@property (strong, readwrite, nonatomic) UIImageView *igv;

@end

@implementation CollectionTableViewCell

+ (instancetype)collectionTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"collectionTableViewCell";
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
        [self addLayout];
    }
    return self;
}

- (void)initSubView
{
    _igv = [[UIImageView alloc]init];
    _igv.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_igv];
    
    _name = [self addLabel:_name fontSize:15 color:[UIColor blackColor]];
    _time = [self addLabel:_time fontSize:12 color:[UIColor lightGrayColor]];
    _browse =  [self addLabel:_browse fontSize:12 color:[UIColor lightGrayColor]];
}

- (void)addLayout
{
    // igv
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_igv(80)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-10-[_igv(%f)]",(SCREENWIDTH - 20) / 3] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    // name
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_igv]-5-[_name(200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_name,_igv)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_name]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_name)]];
    // time without width and height
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_time attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_igv attribute:NSLayoutAttributeRight multiplier:1 constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_time attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_igv attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    // browse without width and height
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_browse attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_browse attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_igv attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
}

- (void)setModel:(CellModel *)model
{
    NSString *str = [NSString stringWithFormat:@"%ld",(long)model.browse];
    _name.text= model.name;
    _time.text = model.time;
    _browse.text = [NSString stringWithFormat:@"%@人阅览",str];
    
    if ([model.image hasPrefix:@"http"]) {
        [_igv sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    }else{
        [_igv setImage:[UIImage imageWithContentsOfFile:model.image]];
    }
}

- (UILabel *)addLabel:(UILabel *)label fontSize:(CGFloat)size color:(UIColor *)color
{
    label = [[UILabel alloc]init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label setFont:[UIFont systemFontOfSize:size]];
    [label setTextColor:color];
    [self addSubview:label];
    return label;
}

- (UIImageView *)addImageView:(NSString *)image
{
    UIImageView *igv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    igv.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:igv];
    return igv;
}

- (UIButton *)addButton:(NSString *)title image:(NSString *)image imageHL:(NSString *)imageHL
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageHL] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:imageHL] forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self addSubview:button];
    return button;
}

@end
