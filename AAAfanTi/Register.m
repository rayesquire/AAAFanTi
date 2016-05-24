//
//  Register.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/6.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "Register.h"
#import "NSString+AES256.h"
#import <AFNetworking.h>
#import "MBProgressHUD.h"
#import "NSMutableDictionary+extension.h"
#define JSON @"http://121.43.104.78:8081/webservice/UserRegister"
//#define JSON @"http://121.43.104.78:8081/webservice/UserRegister?phone=Jzi7tjWRLBubtKGWuXUKzw==&password=K01wVZ9gyuuhxIxB5OFjvw=="
@interface Register () <UITextFieldDelegate>

@property (nonatomic, readwrite, strong) UIImageView *bkgA;

@property (nonatomic, readwrite, strong) UIImageView *bkgB;

@property (nonatomic, readwrite, strong) UIImageView *bkgC;

@property (nonatomic, readwrite, strong) UITextField *account;

@property (nonatomic, readwrite, strong) UIImageView *iconA;

@property (nonatomic, readwrite, strong) UITextField *password;

@property (nonatomic, readwrite, strong) UIImageView *iconB;

@property (nonatomic, readwrite, strong) UITextField *sure;

@property (nonatomic, readwrite, strong) UIImageView *iconC;

@property (nonatomic, readwrite, strong) UIButton *regist;

@property (nonatomic, readwrite, strong) MBProgressHUD *hud;

@end

@implementation Register

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    
    _bkgA = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"square"]];
    _bkgA.translatesAutoresizingMaskIntoConstraints = NO;
    _bkgA.userInteractionEnabled = YES;
    [self.view addSubview:_bkgA];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_bkgA]-25-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bkgA)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_bkgA(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bkgA)]];
    
    _bkgB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"square"]];
    _bkgB.translatesAutoresizingMaskIntoConstraints = NO;
    _bkgB.userInteractionEnabled = YES;
    [self.view addSubview:_bkgB];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_bkgB]-25-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bkgB)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bkgA]-10-[_bkgB(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bkgA,_bkgB)]];
    
    _bkgC = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"square"]];
    _bkgC.translatesAutoresizingMaskIntoConstraints = NO;
    _bkgC.userInteractionEnabled = YES;
    [self.view addSubview:_bkgC];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_bkgC]-25-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bkgC)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bkgB]-10-[_bkgC(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bkgC,_bkgB)]];
    
    _account = [[UITextField alloc]init];
    _account.tag = 1;
    [_account setFont:[UIFont systemFontOfSize:14]];
    _account.backgroundColor = [UIColor clearColor];
    [_account setPlaceholder:@" 输入你的手机号"];
    _account.delegate = self;
    _account.keyboardType = UIKeyboardTypeNumberPad;
    _account.translatesAutoresizingMaskIntoConstraints = NO;
    [_bkgA addSubview:_account];
    _iconA = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_account"]];
    _iconA.translatesAutoresizingMaskIntoConstraints = NO;
    [_bkgA addSubview:_iconA];
    [_bkgA addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_iconA(16)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_iconA)]];
    [_bkgA addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_iconA(16)]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_iconA)]];
    [_bkgA addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_iconA]-5-[_account]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_account,_iconA)]];
    [_bkgA addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_account]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_account)]];
    
    _password = [[UITextField alloc]init];
    _password.tag = 2;
    _password.delegate = self;
    [_password setFont:[UIFont systemFontOfSize:14]];
    _password.secureTextEntry = YES;
    [_password setPlaceholder:@" 密码"];
    _password.translatesAutoresizingMaskIntoConstraints = NO;
    [_bkgB addSubview:_password];
    _iconB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password"]];
    _iconB.translatesAutoresizingMaskIntoConstraints = NO;
    [_bkgB addSubview:_iconB];
    [_bkgB addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_iconB(16)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_iconB)]];
    [_bkgB addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_iconB(16)]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_iconB)]];
    [_bkgB addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_iconB]-5-[_password]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_password,_iconB)]];
    [_bkgB addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_password]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_password)]];
    
    _sure = [[UITextField alloc]init];
    _sure.tag = 3;
    _sure.delegate = self;
    [_sure setFont:[UIFont systemFontOfSize:14]];
    _sure.secureTextEntry = YES;
    [_sure setPlaceholder:@" 密码确认"];
    _sure.translatesAutoresizingMaskIntoConstraints = NO;
    [_bkgC addSubview:_sure];
    _iconC = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password"]];
    _iconC.translatesAutoresizingMaskIntoConstraints = NO;
    [_bkgC addSubview:_iconC];
    [_bkgC addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_iconC(16)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_iconC)]];
    [_bkgC addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_iconC(16)]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_iconC)]];
    [_bkgC addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_iconC]-5-[_sure]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sure,_iconC)]];
    [_bkgC addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sure]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sure)]];
    
    
    _regist = [UIButton buttonWithType:UIButtonTypeCustom];
    [_regist setTitle:@"注册" forState:UIControlStateNormal];
    [_regist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_regist setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [_regist setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_regist setBackgroundImage:[UIImage imageNamed:@"leftImage2"] forState:UIControlStateNormal];
    [_regist setBackgroundImage:[UIImage imageNamed:@"leftImage2"] forState:UIControlStateSelected];
    [_regist setBackgroundImage:[UIImage imageNamed:@"leftImage2"] forState:UIControlStateHighlighted];
    _regist.translatesAutoresizingMaskIntoConstraints = NO;
    [_regist addTarget:self action:@selector(gogogo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_regist];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_regist]-25-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_regist)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bkgC]-10-[_regist(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_regist,_bkgC)]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

// 退出键盘
- (void)dismiss
{
    [self.view endEditing:YES];
}

- (void)gogogo
{
    NSString *account = _account.text;
    NSString *password = _password.text;
    NSString *sure = _sure.text;
    if (![account hasPrefix:@"1"] || account.length < 11) {
        [self showAlertWithTitle:@"请输入正确的手机号" message:nil];
    }else if (password.length < 6 || sure.length < 6 || ![password isEqualToString:sure]){
        [self showAlertWithTitle:@"密码不能少于6位" message:nil];
    }else {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            _hud.labelText = @"注册中";
            [self requestWithAccount:account password:password];
        });
    }
}

- (void)requestWithAccount:(NSString *)account password:(NSString *)password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters =@{@"phone":account,@"password":password};
    [manager POST:JSON parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        _hud.labelText = @"注册成功";
        NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithJsonString:[responseObject objectForKey:@"data"]] objectForKey:@"user"];
        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"phone"] forKey:@"phone"];
        [self performSelector:@selector(backToLogin) withObject:nil afterDelay:1];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self dismissAnimation];
        [self showAlertWithTitle:@"注册失败，请检查网络连接" message:nil];
    }];
}

- (void)backToLogin
{
    [self dismissAnimation];
    [self.navigationController popViewControllerAnimated:YES];
}


// 限制字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1) {
        if (range.location >10) {
            return NO;
        }else if (range.location <= 10){
            return YES;
        }
    }
    if (textField.tag == 2 || textField.tag == 3){
        if (range.location > 15) {
            return NO;
        }else if (range.location <= 15){
            return YES;
        }
    }
    return YES;
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

- (void)dismissAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

@end
