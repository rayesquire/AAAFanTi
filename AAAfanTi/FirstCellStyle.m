//
//  FirstTableViewCell.m
//  afanti
//
//  Created by 尾巴超大号 on 15/11/25.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "FirstCellStyle.h"
#import "CellModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
@interface FirstCellStyle ()

@property (strong, readwrite, nonatomic) UILabel *name;

@property (strong, readwrite, nonatomic) UILabel *time;

@property (strong, readwrite, nonatomic) UILabel *browse;

@property (strong, readwrite, nonatomic) UIImageView *icon;

@property (strong, readwrite, nonatomic) UIImageView *igv;

@property (strong, readwrite, nonatomic) UIButton *share;


@end

@implementation FirstCellStyle

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
    _igv.layer.masksToBounds = YES;
    _igv.layer.cornerRadius = 5;
    _igv.userInteractionEnabled = YES;
    [self.contentView addSubview:_igv];
    
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
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_igv(180)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_igv]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    // name
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_name(280)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_name)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_name]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_name)]];
    //icon
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_name]-10-[_icon(20)]" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_icon,_name)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_icon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:3]];
    // time
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_icon]-7-[_time]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_time,_icon)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_time attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_icon attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    // browse
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_browse]" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_browse,_igv)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_igv]-6-[_browse]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv,_browse)]];
    // collection
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_collection attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_igv]-5-[_collection]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collection,_igv)]];
    // share
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_share attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_collection attribute:NSLayoutAttributeLeft multiplier:1 constant:-15]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_igv]-5-[_share]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_share,_igv)]];
}

- (void)setModel:(CellModel *)model
{    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)model.browse];
    _name.text= model.name;
    _time.text = model.time;
    _browse.text = [NSString stringWithFormat:@"%@人阅览",str];
    _collection.selected = model.isCollected;
    [_igv sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    
    if (model.isCollected) {
        _collection.selected = YES;
    }else if (!model.isCollected){
        _collection.selected = NO;
    }
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
