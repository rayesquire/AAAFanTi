//
//  Preferences.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/3.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "Preferences.h"
#import "RESideMenu.h"
#import "AFanTiNavigationController.h"
#import "ViewController.h"
#import "Feedback.h"
#import "sqlite3.h"
#import "Login.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define DATABASENAME @"afanti.sqlite"

@interface Preferences () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, readwrite, strong) UIButton *button;

@property (nonatomic, readwrite, assign) sqlite3 *database;

@property (nonatomic, readwrite, strong) MBProgressHUD *hud;

@end

@implementation Preferences

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    [self initTableView];
    [self initLogout];
    [self createDatabase];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(pop)];
}

- (void)pop
{
    [self.sideMenuViewController setContentViewController:[[AFanTiNavigationController alloc]initWithRootViewController:[[ViewController alloc]init]] animated:YES];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:_tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_tableView(231)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
}

- (void)initLogout
{
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    [_button setBackgroundColor:[UIColor colorWithRed:0 green:191.0/255.0 blue:255.0/255.0 alpha:1]];
    [_button setTitle:@"注销" forState:UIControlStateNormal];
    [_button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _button.layer.masksToBounds = YES;
    _button.layer.cornerRadius = 5;
    [_button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_button(35)]-30-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_button)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_button]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_button)]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row ==0) {
            cell.textLabel.text = @"消息推送";
            UISwitch *onoff = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            [onoff setOn:[[UIApplication sharedApplication] enabledRemoteNotificationTypes]];
            [onoff addTarget:self action:@selector(notificationOnOff:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = onoff;
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"省流量模式";
            UISwitch *onoff = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            [onoff setOn:NO];
            [onoff addTarget:self action:@selector(economizeOnOff) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = onoff;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"清理缓存";
//            cell.detailTextLabel.text = @"0.5M";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"反馈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1) {
        Feedback *view = [[Feedback alloc]init];
        [self.navigationController pushViewController:view animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"清理中";
        [self deleteCache];
    }
}

- (void)deleteCache
{
    NSString *delete = @"DELETE FROM cache";
    [self execSql:delete];
    [[SDImageCache sharedImageCache] clearDisk];
    _hud.labelText = @"清理成功";
    [self performSelector:@selector(dismissAnimation) withObject:nil afterDelay:1];
}

- (void)dismissAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)notificationOnOff:(UISwitch *)onoff
{
    onoff.on = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
}

- (void)economizeOnOff
{
    
}

- (void)logout
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Id"]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"您尚未登录，请先登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self.navigationController pushViewController:[[Login alloc] init] animated:YES];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:sure];
        [controller addAction:cancel];
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        [self showAlertWithTitle:@"注销当前账号" message:@"您真的要退出登陆吗？"];
    }
}

#pragma mark create database
- (void)createDatabase
{
    NSString *database_path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DATABASENAME];
    if (sqlite3_open([database_path UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"database open failed");
    }
}

#pragma mark - sqlite3 exec
- (void)execSql:(NSString *)sql
{
    char *error;
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"error:%s",error);
    }
}

#pragma mark - alert view
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avatorurl"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
        [self.navigationController pushViewController:[[Login alloc] init] animated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:sure];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
