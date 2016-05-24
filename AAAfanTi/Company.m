//
//  Company.m
//  afanti
//
//  Created by 尾巴超大号 on 15/11/27.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "Company.h"
#import "RESideMenu.h"
#import "ViewController.h"
#import "AFanTiNavigationController.h"
#import "Feedback.h"
#import "Aboutus.h"
@interface Company () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, readwrite, strong) UIImageView *igv;

@end

@implementation Company

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司主页";
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    [self initSubView];
    [self initTableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(pop)];
    
}

- (void)initSubView
{
    _igv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firstPage_leftButton"]];
    _igv.translatesAutoresizingMaskIntoConstraints = NO;
    _igv.layer.cornerRadius = 35;
    _igv.layer.masksToBounds = YES;
    [self.view addSubview:_igv];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_igv(70)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_igv(70)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_igv)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_igv attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.view addSubview:_tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_igv]-80-[_tableView(87)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView,_igv)]];
}

- (void)pop
{
    [self.sideMenuViewController setContentViewController:[[AFanTiNavigationController alloc]initWithRootViewController:[[ViewController alloc]init]] animated:YES];
    [self.sideMenuViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"版本";
        NSString *str = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = str;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"关于我们";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 1) {
        Aboutus *controller = [[Aboutus alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }else
        ;
}


@end
