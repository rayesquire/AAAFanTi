//
//  ChannelButton.m
//  afanti
//
//  Created by 尾巴超大号 on 15/11/30.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "ChannelButton.h"

@interface ChannelButton ()

@property (strong, readwrite, nonatomic) UIButton *cancelButton;

@property (strong, readwrite, nonatomic) UIButton *button;

@property (strong, readwrite, nonatomic) UITapGestureRecognizer *gesture;

@end

@implementation ChannelButton

- (instancetype)initWithIndex:(NSInteger)index style:(NSInteger)style
{
    self = [super init];
    if (self) {
        self.index = index;
        self.style = style;
        [self initSubView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubView];
    }
    return  self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    [_button setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image
{
    self.image = image;
    [_cancelButton setImage:image forState:UIControlStateNormal];
}


- (void)initSubView
{
    self.edited = NO;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setBackgroundImage:[UIImage imageNamed:@"square"] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.userInteractionEnabled = NO;
    [self addSubview:_button];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_button)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_button)]];
    
    _image = [UIImage imageNamed:@"firstPage_close_focus"];
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setImage:_image forState:UIControlStateNormal];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_cancelButton];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_cancelButton(12)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cancelButton(12)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_cancelButton)]];
    [_cancelButton setBackgroundColor:[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1]];
    [_cancelButton addTarget:self.delegate action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setEdited:(BOOL)edited
{
    _cancelButton.hidden = !edited;
}

- (void)clickCancel
{
    if ([self.delegate respondsToSelector:@selector(deleteButton:)]) {
        [self.delegate deleteButton:self.index];
    }
}

@end
