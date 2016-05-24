//
//  TopMenuView.m
//  afanti
//
//  Created by 尾巴超大号 on 15/11/24.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "TopMenuView.h"
#import "StyleButton.h"
#define MENUWIDTH (SCREENWIDTH - 40)/4
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width


@interface TopMenuView ()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *buttonContainer;

@property (nonatomic,strong) UIButton *currentButton;

@property (nonatomic,strong) UIButton *lastButton;

@property (nonatomic,copy) NSMutableArray *buttons;

@end

@implementation TopMenuView

- (instancetype)initWithMenus:(NSMutableArray *)menus type:(NSMutableArray *)typeArray style:(NSMutableArray *)styleArray
{
    self = [super init];
    if (self) {
        [self initialization];
        [self addContainer:menus];
        [self addButtons:menus typeArray:typeArray styleArray:styleArray];
    }
    return self;
}

- (void)initialization
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
}

- (void)addContainer:(NSMutableArray *)menus
{
    NSInteger num = menus.count;
    _buttonContainer = [[UIView alloc]init];
    _buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    _buttonContainer.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [_scrollView addSubview:_buttonContainer];
    [_scrollView addConstraints:@[
        [NSLayoutConstraint constraintWithItem:_buttonContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:(num * MENUWIDTH)],
        [NSLayoutConstraint constraintWithItem:_buttonContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]]];
    [_scrollView addConstraints:@[
        [NSLayoutConstraint constraintWithItem:_buttonContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_buttonContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]]];
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonContainer]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_buttonContainer)]];
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_buttonContainer]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_buttonContainer)]];
}

- (void)addButtons:(NSMutableArray *)menus typeArray:(NSMutableArray *)typeArray styleArray:(NSMutableArray *)styleArray
{
    _buttons = [[NSMutableArray alloc]init];
    for (int i = 0; i < menus.count; i++) {
        StyleButton *button = [self addButtonWithTitle:menus[i]];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.type = [typeArray[i] integerValue];
        button.style = [styleArray[i] integerValue];
        [_buttonContainer addSubview:button];
        [_buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
        if (i == 0) {
            [_buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:MENUWIDTH]];
            [_buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
            _currentButton = button;
            _currentButton.selected = YES;
            self.currentTag = i;
        }else {
            [_buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_lastButton][button(_lastButton)]" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(button,_lastButton)]];
        }
        _lastButton = button;
        [_buttons addObject:button];
    }
}


- (StyleButton *)addButtonWithTitle:(NSString *)title
{
    StyleButton *button = [StyleButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.54 green:0.76 blue:1 alpha:1] forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)changeView:(StyleButton *)sender
{
    StyleButton *button;
    for (int i = 0; i < _buttons.count; i++) {
        button = _buttons[i];
        if (button.type == sender.type) {
            sender.selected = YES;
        }
        else {
            button.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(changeView:)]) {
        [self.delegate changeView:sender];
    }
}

@end
