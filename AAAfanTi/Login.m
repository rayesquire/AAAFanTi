//
//  Login.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/6.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "Login.h"
#import "RESideMenu.h"
#import "AFanTiNavigationController.h"
#import "ViewController.h"
#import "CustomTextField.h"
#import "Register.h"
#import <AFNetworking.h>
#import "MBProgressHUD.h"
#import "EditInfo.h"
#import "NSMutableDictionary+extension.h"
#define JSON @"http://121.43.104.78:8081/webservice/userlogin"
@interface Login () <UITextFieldDelegate>

@property (nonatomic, readwrite, strong) UIImageView *bkgA;

@property (nonatomic, readwrite, strong) UIImageView *bkgB;

@property (nonatomic, readwrite, strong) UITextField *account;

@property (nonatomic, readwrite, strong) UIImageView *iconA;

@property (nonatomic, readwrite, strong) UITextField *password;

@property (nonatomic, readwrite, strong) UIImageView *iconB;

@property (nonatomic, readwrite, strong) UIButton *login;

@property (nonatomic, readwrite, strong) UIButton *newr;

@property (nonatomic, readwrite, strong) MBProgressHUD *hud;

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    self.title = @"登陆";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(pop)];
    
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
    
    _login = [UIButton buttonWithType:UIButtonTypeCustom];
    [_login setTitle:@"登陆" forState:UIControlStateNormal];
    [_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_login setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [_login setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_login setBackgroundImage:[UIImage imageNamed:@"leftImage2"] forState:UIControlStateNormal];
    [_login setBackgroundImage:[UIImage imageNamed:@"leftImage2"] forState:UIControlStateSelected];
    [_login setBackgroundImage:[UIImage imageNamed:@"leftImage2"] forState:UIControlStateHighlighted];
    _login.translatesAutoresizingMaskIntoConstraints = NO;
    [_login addTarget:self action:@selector(gogogo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_login];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_login]-25-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_login)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bkgB]-10-[_login(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_login,_bkgB)]];
    
    _newr = [UIButton buttonWithType:UIButtonTypeCustom];
    [_newr setTitle:@"新用户" forState:UIControlStateNormal];
    [_newr setTitleColor:[UIColor colorWithRed:128.0/255.0 green:194.0/255.0 blue:249.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_newr.titleLabel setFont:[UIFont systemFontOfSize:14]];
    _newr.translatesAutoresizingMaskIntoConstraints = NO;
    [_newr addTarget:self action:@selector(pushToRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_newr];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_login]-3-[_newr]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_newr,_login)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newr attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_login attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

// 退出键盘
- (void)dismiss
{
    [self.view endEditing:YES];
}

- (void)pop
{
    [self.sideMenuViewController setContentViewController:[[AFanTiNavigationController alloc]initWithRootViewController:[[ViewController alloc]init]] animated:YES];
    [self.sideMenuViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)gogogo
{
    NSString *account = _account.text;
    NSString *password = _password.text;
    if (![account hasPrefix:@"1"] || account.length < 11) {
        [self showAlertWithTitle:@"请输入正确的手机号码" message:nil];
    }else if (password.length < 6) {
        [self showAlertWithTitle:@"请输入正确的密码" message:nil];
    }else {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"登录中";
        [self requestWithAccount:account password:password];
    }
}

- (void)requestWithAccount:(NSString *)account password:(NSString *)password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters =@{@"phone":account,@"password":password};
    NSLog(@"account:%@ password:%@",account,password);
    [manager POST:JSON parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithJsonString:[responseObject objectForKey:@"data"]];
            NSMutableDictionary *dic = [dictionary objectForKey:@"user"];
            [self writeToRecord:[dic objectForKey:@"phone"] name:[dic objectForKey:@"nickname"] avator:[dic objectForKey:@"headsrc"] ID:[dic objectForKey:@"Id"]];
            _hud.labelText = @"登陆成功";
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
        }else if ([code isEqualToString:@"202"]){
            [self showAlertWithTitle:@"手机号或密码不正确" message:nil];
            [self dismissAnimation];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self dismissAnimation];
        [self showAlertWithTitle:@"登录失败，请检查网络连接" message:nil];
    }];
}

- (void)back
{
    [self dismissAnimation];
    [self.navigationController pushViewController:[[EditInfo alloc]init] animated:YES];
}

#pragma mark - write to record
- (void)writeToRecord:(NSString *)account name:(NSString *)name avator:(NSString *)avator ID:(NSString *)ID
{
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:ID forKey:@"Id"];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
    if (![avator isEqualToString:@""]) {
        avator = [avator substringWithRange:NSMakeRange(1, avator.length-2)];
    }
    [[NSUserDefaults standardUserDefaults] setObject:avator forKey:@"avatorurl"];
}

- (void)pushToRegister
{
    Register *view = [[Register alloc]init];
    [self.navigationController pushViewController:view animated:YES];
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
    if (textField.tag == 2){
        if (range.location > 15) {
            return NO;
        }else if (range.location <= 15){
            return YES;
        }
    }
    return YES;
}

// 点击return取消键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)dismissAnimation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - alert view
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
