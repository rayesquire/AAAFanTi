//
//  ThirdTableViewCell.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/4.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "ForthCellStyle.h"
#import "CellModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface ForthCellStyle ()

@property (strong, readwrite, nonatomic) UILabel *name;

@property (strong, readwrite, nonatomic) UILabel *time;

@property (strong, readwrite, nonatomic) UILabel *browse;

@property (strong, readwrite, nonatomic) UIImageView *icon;

@property (strong, readwrite, nonatomic) UIImageView *igv;

@property (strong, readwrite, nonatomic) UIButton *share;

@end

@implementation ForthCellStyle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    _share = [self addButton:@"分享" image:@"share_normal" imageHL:@"share_selected"];
    [_share addTarget:self action:@selector(clickShareButton) forControlEvents:UIControlEventTouchUpInside];
    _collection = [self addButton:@"收藏" image:@"collection_normal" imageHL:@"collection_selected"];
    [_collection addTarget:self action:@selector(clickCollectionButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addLayout
{
    // igv
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_igv(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_igv(%f)]-10-|",(SCREENWIDTH - 20) / 3] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    // name
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_name(200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_name,_igv)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_name]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_name)]];
    // time
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_time attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_time attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    // share
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_share attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_igv attribute:NSLayoutAttributeLeft multiplier:1 constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_share attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_igv attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    // collection
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collection attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_share attribute:NSLayoutAttributeLeft multiplier:1 constant:-10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_collection attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_igv attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    // browse 
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_browse attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_collection attribute:NSLayoutAttributeTop multiplier:1 constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_browse attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_igv attribute:NSLayoutAttributeLeft multiplier:1 constant:-5]];
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
    [self.contentView addSubview:label];
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
