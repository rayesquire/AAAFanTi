//
//  Collection.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/15.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "Collection.h"
#import "AFanTiNavigationController.h"
#import "RESideMenu.h"
#import "ViewController.h"
#import "sqlite3.h"
#import "HTMLViewController.h"
#import "CellModel.h"
#import "CollectionTableViewCell.h"
#define DATABASENAME @"afanti.sqlite"
#define HTML @"http://121.43.104.78:8081/News/NewsPage/"

@interface Collection () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, readwrite, strong) UITableView *tableView;

@property (nonatomic, readwrite, assign) sqlite3 *database;

@property (nonatomic, readwrite, copy) NSMutableArray *collectionArray;

@property (nonatomic, readwrite, strong) UILabel *label;

@end

@implementation Collection

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    [self loadData];
    [self initTableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(pop)];
}

- (void)loadData
{
    _collectionArray = [[NSMutableArray alloc]init];
    [self createDatabase];
    NSString *searchSQL = @"SELECT * FROM collection";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [searchSQL UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            CellModel *object = [[CellModel alloc] init];
            NSInteger idx = sqlite3_column_int(statement, 0);
            NSInteger browse = sqlite3_column_int(statement, 1);
            char *title = (char *)sqlite3_column_text(statement, 2);
            char *images = (char *)sqlite3_column_text(statement, 3);
            char *createtime = (char *)sqlite3_column_text(statement, 4);
            object.ID = idx;
            object.browse = browse;
            object.name = [[NSString alloc] initWithUTF8String:title];
            object.image = [[NSString alloc] initWithUTF8String:images];
            object.time = [[NSString alloc] initWithUTF8String:createtime];
            [_collectionArray addObject:object];
        }
        sqlite3_finalize(statement);
    }
    if (!_collectionArray.count) {
        [_tableView setHidden:YES];
        [self addLabel];
        [_label setHidden:NO];
    }else {
        [_tableView setHidden:NO];
        [_label setHidden:YES];
    }
}

- (void)addLabel
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.text = @"你还没有收藏哦~";
        [_label setFont:[UIFont systemFontOfSize:14]];
        [self.view addSubview:_label];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self setExtraCellLineHidden:_tableView];
    if (!_collectionArray.count) {
        _tableView.hidden = YES;
    }else {
        _tableView.hidden = NO;
    }
}

- (void)pop
{
    [self.sideMenuViewController setContentViewController:[[AFanTiNavigationController alloc]initWithRootViewController:[[ViewController alloc]init]] animated:YES];
    [self.sideMenuViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionTableViewCell *cell = [CollectionTableViewCell collectionTableViewCellWithTableView:tableView];
    cell.model = [_collectionArray objectAtIndex:indexPath.row];
    cell.idx = indexPath;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        CellModel *object = _collectionArray[indexPath.row];
        [_collectionArray removeObjectAtIndex:indexPath.row];
        NSString *deleteInCollection = [NSString stringWithFormat:@"DELETE FROM collection WHERE id=%d",(int)object.ID];
        [self execSql:deleteInCollection];
        NSString *updateInCache = [NSString stringWithFormat:@"UPDATE cache SET isCollected=0 WHERE idx=%d",(int)object.ID];
        [self execSql:updateInCache];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        if (!_collectionArray.count) {
            [self addLabel];
            [_label setHidden:NO];
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"backfromcollection"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellModel *obj = _collectionArray[indexPath.row];
    HTMLViewController *view = [[HTMLViewController alloc]init];
    NSString *urlString = [NSString stringWithFormat:@"%@%ld",HTML,(long)obj.ID];
    view.urlString = urlString;
    [self.navigationController pushViewController:view animated:YES];
}


#pragma mark - hide extral cell
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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

@end
