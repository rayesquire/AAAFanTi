//
//  CustomTextField.m
//  8minute
//
//  Created by 尾巴超大号 on 15/10/16.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "CustomTextField.h"
@implementation CustomTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFont:[UIFont systemFontOfSize:14]];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
//    CGContextFillRect(context, CGRectMake(0, 0.5, CGRectGetWidth(self.frame), 0.5));
}

@end
