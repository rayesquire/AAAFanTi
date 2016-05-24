//
//  Connect.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/3.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "Connect.h"
#import "RESideMenu.h"
#import "AFanTiNavigationController.h"
#import "ViewController.h"
#import "Feedback.h"
@interface Connect () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, readwrite, strong) UIImageView *igv;

@property (nonatomic, readwrite, strong) UILabel *label;

@property (nonatomic, readwrite, strong) UILabel *version;
@end

@implementation Connect

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我们";
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    [self initSubView];
    [self initTableView];
    [self initLabel];
    [self addversion];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(pop)];
}

- (void)addversion
{
    _version = [[UILabel alloc]init];
    _version.translatesAutoresizingMaskIntoConstraints = NO;
    _version.text = [NSString stringWithFormat:@"当前版本 %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [_version setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_version];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_version attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_igv]-40-[_version]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv,_version)]];
}

- (void)pop
{
    [self.sideMenuViewController setContentViewController:[[AFanTiNavigationController alloc]initWithRootViewController:[[ViewController alloc]init]] animated:YES];
}

- (void)initSubView
{
    _igv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firstPage_leftButton"]];
    _igv.translatesAutoresizingMaskIntoConstraints = NO;
    _igv.layer.cornerRadius = 35;
    _igv.layer.masksToBounds = YES;
    [self.view addSubview:_igv];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_igv(70)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_igv(70)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_igv attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.view addSubview:_tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_igv]-80-[_tableView(43)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView,_igv)]];
    
}

- (void)initLabel
{
    _label = [[UILabel alloc]init];
    [_label setTextColor:[UIColor lightGrayColor]];
    [_label setFont:[UIFont systemFontOfSize:11]];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.text = @"客服在线时间 08:00-21:00";
    [self.view addSubview:_label];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tableView]-10-[_label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label,_tableView)]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"客服电话";
        cell.detailTextLabel.text = @"025-52311043";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self showAlertWithTitle:[NSString stringWithFormat:@"是否要拨打 %@?",cell.detailTextLabel.text] message:cell.detailTextLabel.text];
    }
}

#pragma mark - alert view
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self call:[NSString stringWithFormat:@"tel:%@",message]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)call:(NSString *)number
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}

@end
