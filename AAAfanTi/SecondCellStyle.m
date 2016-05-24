//
//  FirstCollectionViewCell.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/2.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "SecondCellStyle.h"
#import "CellModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface SecondCellStyle ()

@property (strong, readwrite, nonatomic) UILabel *name;

@property (strong, readwrite, nonatomic) UILabel *time;

@property (strong, readwrite, nonatomic) UILabel *browse;

@property (strong, readwrite, nonatomic) UIImageView *icon;

@property (strong, readwrite, nonatomic) UIImageView *igv;

@property (strong, readwrite, nonatomic) UIButton *share;

@end

@implementation SecondCellStyle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
        [self addLayout];
    }
    return self;
}

- (void)initialization
{
    _igv = [[UIImageView alloc]init];
    _igv.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_igv];
    _name = [self addLabel:_name fontSize:15 color:[UIColor whiteColor]];
    _time = [self addLabel:_time fontSize:12 color:[UIColor whiteColor]];
    _browse =  [self addLabel:_browse fontSize:12 color:[UIColor lightGrayColor]];
    _icon = [self addImageView:@"leftImage2"];
    _share = [self addButton:@"分享" image:@"share_normal" imageHL:@"share_selected"];
    [_share addTarget:self action:@selector(clickShareButton) forControlEvents:UIControlEventTouchUpInside];
    _collection = [self addButton:@"收藏" image:@"collection_normal" imageHL:@"collection_selected"];
    [_collection addTarget:self action:@selector(clickCollectionButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addLayout
{
    // igv
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-10-[_igv(%f)]",SCREENWIDTH / 2 - 15] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-5-[_igv(%f)]",SCREENWIDTH / 2 - 10] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    // browse
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_browse]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_browse)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_igv]-6-[_browse]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv,_browse)]];
    // collection
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collection attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_igv]-5-[_collection]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collection,_igv)]];
    // share without width and height
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_share attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_collection attribute:NSLayoutAttributeLeft multiplier:1 constant:-10]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_igv]-5-[_share]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_share,_igv)]];
    //icon
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_icon(3)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_icon)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_icon(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_icon)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_icon attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_igv attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    // time 
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_icon]-7-[_time]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_time,_icon)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_time attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_icon attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    // name
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_name(120)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_name)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_name]-15-[_icon]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_name,_icon)]];
}

- (void)setModel:(CellModel *)model
{
    NSString *str = [NSString stringWithFormat:@"%ld",(long)model.browse];
    _name.text= model.name;
    _time.text = model.time;
    _browse.text = [NSString stringWithFormat:@"%@人阅览",str];
    _collection.selected = model.isCollected;
    [_igv sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
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
    [self.contentView addSubview:igv];
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
    [self.contentView addSubview:button];
    return button;
}

- (void)clickShareButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShare:)]) {
        [self.delegate clickShare:self.idx];
    }
}

- (void)clickCollectionButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCollection:)]) {
        [self.delegate clickCollection:self.idx];
    }
}

@end
