//
//  SlideViewController.m
//  afanti
//
//  Created by 尾巴超大号 on 15/11/23.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "SlideViewController.h"
#import "Company.h"
#import "Connect.h"
#import "Preferences.h"
#import "RESideMenu.h"
#import "Login.h"
#import "MineTableViewCell.h"
#import "AFanTiNavigationController.h"
#import "EditInfo.h"
#import "Collection.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface SlideViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSMutableArray *titles;

@property (nonatomic,copy) NSMutableArray *icons;

@end

@implementation SlideViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    [self initDataSource];
    [self initTableView];
}

- (void)initDataSource
{
    _titles = [[NSMutableArray alloc]initWithArray:@[@"我的收藏",@"公司主页",@"联系我们",@"设置"]];
    _icons = [[NSMutableArray alloc]initWithArray:@[[UIImage imageNamed:@"icon-1"],[UIImage imageNamed:@"icon-2"],[UIImage imageNamed:@"icon-3"],[UIImage imageNamed:@"icon-4"]]];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MineTableViewCell *cell = [MineTableViewCell MineTableViewCellWithTableView:tableView];
        cell.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = _titles[indexPath.row - 1];
        cell.imageView.image = _icons[indexPath.row - 1];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Id"]) {
            AFanTiNavigationController *controller = [[AFanTiNavigationController alloc]initWithRootViewController:[[EditInfo alloc]init]];
            [self.sideMenuViewController setContentViewController:controller animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }else {
            AFanTiNavigationController *controller = [[AFanTiNavigationController alloc]initWithRootViewController:[[Login alloc]init]];
            [self.sideMenuViewController setContentViewController:controller animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
    }
    else if (indexPath.row == 1)
    {
        AFanTiNavigationController *controller = [[AFanTiNavigationController alloc]initWithRootViewController:[[Collection alloc]init]];
        [self.sideMenuViewController setContentViewController:controller animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
    else if (indexPath.row == 2)
    {
        AFanTiNavigationController *controller = [[AFanTiNavigationController alloc]initWithRootViewController:[[Company alloc]init]];
        [self.sideMenuViewController setContentViewController:controller animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }
    else if (indexPath.row == 3)
    {
        AFanTiNavigationController *controller = [[AFanTiNavigationController alloc]initWithRootViewController:[[Connect alloc]init]];
        [self.sideMenuViewController setContentViewController:controller animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }
    else if (indexPath.row == 4)
    {
        AFanTiNavigationController *controller = [[AFanTiNavigationController alloc]initWithRootViewController:[[Preferences alloc]init]];
        [self.sideMenuViewController setContentViewController:controller animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
}

@end
