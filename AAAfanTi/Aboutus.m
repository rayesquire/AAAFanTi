//
//  Aboutus.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/3.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "Aboutus.h"

@interface Aboutus ()

@property (nonatomic, readwrite, strong) UILabel *introduction;

@property (nonatomic, readwrite, strong) UIImageView *erweima;

@end

@implementation Aboutus

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    self.title = @"关于我们";
    [self initLabel];
    [self initImage];
}

- (void)initLabel
{
    _introduction = [[UILabel alloc]init];
    [_introduction setText:@"  南京阿凡提旅游摄影服务中心是一家集摄影文化、旅游文化、摄影旅游线路规划、摄影培训于一体的旅游摄影公司。并携手资深旅游人、旅游策划人、职业摄影师组成的旅游摄影文化传播专业团队, 以摄影文化提升旅游，以旅游摄影传播文化。公司具备：旅游线路规划力、摄影技术传播创新力、资深摄影家的影响力等专业能力。我们的目标是以摄影艺术传导旅游文化魅力。我们秉承文明热情、诚实守信、高效快捷、服务优良的方针,致力于优质的人性化的服务回报客户，将为热爱旅游摄影的人群带来高质量的服务。                                              联系电话：025-52311043                                           手机：13915920843                                          QQ：2287722304                                           通讯地址：南京市玄武区长江路109号A3栋1121室"];
    _introduction.translatesAutoresizingMaskIntoConstraints = NO;
    [_introduction setTextColor:[UIColor blackColor]];
    [_introduction setFont:[UIFont systemFontOfSize:15]];
    _introduction.lineBreakMode = NSLineBreakByWordWrapping;
    _introduction.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_introduction.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_introduction.text length])];
    [_introduction setAttributedText:attributedString];
    [_introduction sizeToFit];
    [self.view addSubview:_introduction];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_introduction]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_introduction)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_introduction]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_introduction)]];
}

- (void)initImage
{
    _erweima = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"erweima"]];
    _erweima.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_erweima];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_introduction]-5-[_erweima(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_erweima,_introduction)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_erweima(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_erweima)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_erweima attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}



@end
