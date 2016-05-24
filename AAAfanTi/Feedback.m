//
//  Feedback.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/3.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "Feedback.h"
#import <AFNetworking.h>
#define JSON @"http://121.43.104.78:8081/WebService/SendFeedBack?phone=12332423412&backMessage=%E6%B5%8B%E8%AF%95"
@interface Feedback ()

@property (nonatomic, readwrite, strong) UILabel *label;

@property (nonatomic, readwrite ,strong) UITextView *textView;

@end

@implementation Feedback

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    self.title = @"消息反馈";
    [self initLabel];
    [self initTextField];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

// 退出键盘
- (void)dismiss
{
    [self.view endEditing:YES];
}

- (void)initLabel
{
    _label = [[UILabel alloc]init];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    [_label setTextColor:[UIColor grayColor]];
    [_label setFont:[UIFont systemFontOfSize:13]];
    [_label setText:@"您对我们的产品有任何优化和建议，请您在下方留言"];
    [self.view addSubview:_label];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)initTextField
{
    _textView = [[UITextView alloc]init];
    [_textView setBackgroundColor:[UIColor whiteColor]];
    _textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_textView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_label]-20-[_textView(160)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView,_label)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_textView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
}

- (void)commit
{
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    NSString *txt = _textView.text;
    if (!txt) {
        [self showAlertWithTitle:nil message:@"反馈内容不能为空"];
    }else if (!account){
        [self showAlertWithTitle:nil message:@"您尚未登录，请先登录"];
    }else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        NSDictionary *parameters =@{@"phone":account,@"backMessage":txt};
        [manager POST:[JSON stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
            [self showAlertWithTitle:@"反馈成功" message:@"感谢您的建议!"];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [self showAlertWithTitle:@"请求失败" message:@"请检查网络连接"];
        }];
    }
}

#pragma mark - alert view
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 点击return取消键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
