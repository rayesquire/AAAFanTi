//
//  EditName.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/7.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "EditName.h"
#import "CustomTextField.h"
#import <AFNetworking.h>
#import "NSMutableDictionary+extension.h"
#define JSON @"http://121.43.104.78:8081/webservice/setUser"
//#define JSON @"http://121.43.104.78:8081/webservice/setUser?userId=6&nickname=小号那个&headUrl=http://www.ddi.com/ddd.png"
@interface EditName () <UITextFieldDelegate>

@property (nonatomic, readwrite, strong) CustomTextField *textField;

@property (nonatomic, readwrite, copy) NSString *name;

@end

@implementation EditName

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"昵称";
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    
    _name = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 44)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
    
    _textField = [[CustomTextField alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width, 44)];
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor whiteColor];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"name"]) {
        _textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    }
    [view addSubview:_textField];
    
}

- (void)dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)post
{
    if ([_textField.text isEqualToString:_name]) {
        return;
    }else {
        [self post:_textField.text];
    }
}

- (void)post:(NSString *)name
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters =@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"Id"],@"nickname":name,@"headUrl":@""};
    NSString *url = [JSON stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self showAlertWithTitle:@"修改昵称失败" message:nil];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self showAlertWithTitle:@"修改昵称失败" message:nil];
    }];
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
