//
//  ViewController.m
//  afanti
//
//  Created by 尾巴超大号 on 15/11/23.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "ViewController.h"
#import "AFNetWorking.h"
#import "TopMenuView.h"
#import "sqlite3.h"
#import "CellModel.h"
#import "StyleButton.h"
#import "FirstCellStyle.h"
#import "SecondCellStyle.h"
#import "ThirdCellStyle.h"
#import "ForthCellStyle.h"
#import "ChannelsViewController.h"
#import "NSMutableArray+extension.h"
#import "RESideMenu.h"
#import "SlideViewController.h"
#import "HTMLViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSMutableDictionary+extension.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define MENUWIDTH (SCREENWIDTH - 40)/4
#define HTML @"http://121.43.104.78:8081/News/NewsPage/"
#define JSON @"http://121.43.104.78:8081/webservice/getNewsList"
#define JSONMENU @"http://121.43.104.78:8081/WebService/getTabData"
#define BROWSE @"http://121.43.104.78:8081/webservice/readNews"
#define DATABASENAME @"afanti.sqlite"
@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate,TopMenuViewDelegate,FirstCellStyleDelegate,ThirdCellStyleDelegate,ForthCellStyleDelegate,SecondCellStyleDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,JSPassBrowseValueDelegate>

@property (nonatomic, readwrite, assign) sqlite3 *database;

@property (nonatomic, readwrite, copy) NSMutableArray *menus;  //菜单名称的数组

@property (nonatomic, readwrite, copy) NSMutableArray *typeArray;  // use to post request

@property (nonatomic, readwrite, copy) NSMutableArray *styleArray;

@property (nonatomic, readwrite, strong) UIButton *iconButton;

@property (nonatomic, readwrite, strong) UIImageView *iconImage;

@property (nonatomic, readwrite, strong) UICollectionView *collectionView;

@property (nonatomic, readwrite, strong) UIButton *add;  // add menu

@property (nonatomic, readwrite, strong) TopMenuView *menuView;

@property (nonatomic, readwrite, assign) NSInteger currentTag;

@property (nonatomic, readwrite, assign) NSInteger style;    //style

@property (nonatomic ,readwrite, copy) NSMutableArray *firstArray;

@property (nonatomic, readwrite, strong) UIRefreshControl *control;

@property (nonatomic, readwrite, assign) NSInteger theBiggerID;

@property (nonatomic, readwrite, assign) NSInteger theSmallerID;

@property (nonatomic, readwrite, assign) NSInteger totalSection;

@property (nonatomic, readwrite, strong) UIImageView *loading;   // loading image

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createDatabase];
    if (_iconButton) {
        [self refreshNavigationBar];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"backfromcollection"]) {
        BOOL cache = [self loadCache];
        if (!cache) {
            [self refreshStateChange:_control];
        }
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"backfromcollection"];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"backfrommenu"]) {
        [self initTabData];
        [self initMenuView];
        if (_typeArray.count) {
            _type = [_typeArray[0] integerValue];
            _style = [_styleArray[0] integerValue];
            StyleButton *btn = [[StyleButton alloc]init];
            btn.style = _style;
            btn.type = _type;
            [self changeView:btn];
        }
    }
    [_add removeFromSuperview];
    _add = nil;
    [self addAdd];
    
    // refresh avator and nickname of slideview
    SlideViewController *controller = (SlideViewController *)self.sideMenuViewController.leftMenuViewController;
    controller = nil;
    [self.sideMenuViewController setLeftMenuViewController:[[SlideViewController alloc]init]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _theBiggerID = 0;
    _theSmallerID = 0;
    _firstArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    [self initNavigationbar];
    [self createDatabase];
    [self initTabData];
    [self initMenuView];
    [self compare];
}

#pragma mark - init

- (void)addLoading
{
    _loading = [[UIImageView alloc]init];
    _loading.userInteractionEnabled = NO;
    _loading.image = [UIImage imageNamed:@"loading"];
    _loading.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_loading];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_loading]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_loading)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_loading]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_loading)]];
//    [_loading setHidden:YES];
}

- (void)setRefresh
{
    if (!_control) {
        _control = [[UIRefreshControl alloc]init];
        [_control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
        [_collectionView addSubview:_control];
    }
}

- (void)initNavigationbar
{
    self.title = @"阿凡提旅游";
    _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.cornerRadius = _iconImage.frame.size.width / 2;
    _iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconImage.layer.borderWidth = 1;
    _iconImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openSlideViewController)];
    [_iconImage addGestureRecognizer:gesture];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_iconImage];
    [self refreshNavigationBar];
    
}

- (void)refreshNavigationBar
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"] hasPrefix:@"http"]) {
            [_iconImage sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"]] placeholderImage:nil];
        }else{
            [_iconImage setImage:[UIImage imageWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"]]];
        }
    }else {
        _iconImage.image = [UIImage imageNamed:@"firstPage_leftButton"];
    }
}

- (void)initTabData
{
    _menus = [[NSMutableArray alloc]init];
    _typeArray = [[NSMutableArray alloc]init];
    _styleArray = [[NSMutableArray alloc]init];
    NSString *searchSQL = [NSString stringWithFormat:@"SELECT * FROM channel WHERE mine=%d",1];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [searchSQL UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSNumber *type = [NSNumber numberWithInt:(int)sqlite3_column_int64(statement, 0)];
            [_typeArray addObject:type];
            
            char *title = (char *)sqlite3_column_text(statement, 1);
            [_menus addObject:[[NSString alloc]initWithUTF8String:title]];
            
            NSNumber *style = [NSNumber numberWithInt:(int)sqlite3_column_int64(statement, 4)];
            [_styleArray addObject:style];
        }
        sqlite3_finalize(statement);
    }
    [_menuView removeFromSuperview];
    _menuView = nil;
}

- (void)initMenuView
{
    if (!_menuView) {
        _menuView = [[TopMenuView alloc]initWithMenus:_menus type:_typeArray style:_styleArray];
        _menuView.delegate = self;
        _currentTag = _menuView.currentTag;
        [self.view addSubview:_menuView];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_menuView(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_menuView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_menuView]-40-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_menuView)]];
    }
}

- (void)addAdd
{
    if (!_add) {
        _add = [UIButton buttonWithType:UIButtonTypeCustom];
        _add.translatesAutoresizingMaskIntoConstraints = NO;
        _add.layer.shadowOffset = CGSizeMake(1, 1);
        _add.layer.shadowOpacity = 1;
        _add.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        [_add setImage:[UIImage imageNamed:@"firstPage_add_normal"] forState:UIControlStateNormal];
        [_add setImage:[UIImage imageNamed:@"firstPage_add_focus"] forState:UIControlStateHighlighted];
        [_add setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1]];
        [_add addTarget:self action:@selector(addView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_add];
        [self.view addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:_add attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_menuView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                    [NSLayoutConstraint constraintWithItem:_add attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_menuView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]
                                    ]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_menuView][_add(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_add,_menuView)]];
    }
}

- (void)initCollectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [layout setMinimumInteritemSpacing:0];
        if (_style == 1) {
            layout.itemSize = CGSizeMake(SCREENWIDTH / 2, SCREENWIDTH / 2 + 15);
        }else if (_style == 0) {
            layout.itemSize = CGSizeMake(SCREENWIDTH, 220);
        }else {
            layout.itemSize = CGSizeMake(SCREENWIDTH, 100);
        }
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_collectionView];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[FirstCellStyle class] forCellWithReuseIdentifier:@"FirstCellStyle"];
        [_collectionView registerClass:[SecondCellStyle class] forCellWithReuseIdentifier:@"SecondCellStyle"];
        [_collectionView registerClass:[ThirdCellStyle class] forCellWithReuseIdentifier:@"ThirdCellStyle"];
        [_collectionView registerClass:[ForthCellStyle class] forCellWithReuseIdentifier:@"ForthCellStyle"];
        [self setRefresh];
    }
}

#pragma mark - compare channel property
- (void)compare
{
    __block NSMutableArray *netArray = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:JSONMENU parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 200) {
            // 将接收的菜单数据转为数组，add to _menus
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithJsonString:[responseObject objectForKey:@"data"]];
            netArray = [dic valueForKey:@"tableList"];
            for (int i = 0; i < netArray.count; i++) {
                NSInteger type = [[netArray[i] objectForKey:@"type"] integerValue];
                NSInteger style = [[netArray[i] objectForKey:@"styletype"] integerValue];
                NSString *title = [netArray[i] objectForKey:@"title"];
                for (int n = 0; n < _typeArray.count; n++) {
                    if ([_typeArray[n] integerValue] == type) {
                        if ([_styleArray[n] integerValue] != style) {
                            [_styleArray removeObjectAtIndex:n];
                            [_styleArray insertObject:[NSNumber numberWithInteger:style] atIndex:n];
                            NSString *update = [NSString stringWithFormat:@"UPDATE channel SET style=%d WHERE idx=%d",(int)style,n];
                            [self execSql:update];
                        }
                        if (![_menus[n] isEqualToString:title]) {
                            [_menus removeObjectAtIndex:n];
                            [_menus insertObject:title atIndex:n];
                            NSString *update = [NSString stringWithFormat:@"UPDATE channel SET title='%@' WHERE idx=%d",title,n];
                            [self execSql:update];
                        }
                        break;
                    }
                }
            }
            [_menuView removeFromSuperview];
            _menuView = nil;
            [self initMenuView];
            [_add removeFromSuperview];
            _add = nil;
            [self addAdd];
            _style = [_styleArray[0] integerValue];
            _type = [_typeArray[0] integerValue];
            [self initCollectionView];
            if (![self loadCache]) {
                [self refreshStateChange:_control];
            }
        }
        else {
            [self showAlertWithTitle:nil message:@"更新菜单超时，请检查网络连接"];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self showAlertWithTitle:nil message:@"更新菜单超时，请检查网络连接"];
    }];
}

#pragma mark - cache存在即读取，不存在则下拉刷新
- (BOOL)loadCache
{
    NSLog(@"load cache start");
    if (_firstArray) {
        [_firstArray removeAllObjects];
    } else {
        _firstArray = [[NSMutableArray alloc]init];
    }
    NSString *search = [NSString stringWithFormat:@"SELECT * FROM cache WHERE type=%d",(int)_type];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [search UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSInteger idx = sqlite3_column_int(statement, 0);
            NSInteger type = sqlite3_column_int(statement, 1);
            NSInteger readNum = sqlite3_column_int(statement, 2);
            NSInteger isCollected = sqlite3_column_int(statement, 3);
            char *title = (char *)sqlite3_column_text(statement, 4);
            char *images = (char *)sqlite3_column_text(statement, 5);
            char *createtime = (char *)sqlite3_column_text(statement, 6);
            CellModel *object = [[CellModel alloc]initWithID:idx type:type browse:readNum isCollected:isCollected name:[[NSString alloc] initWithUTF8String:title] image:[[NSString alloc] initWithUTF8String:images] time:[[NSString alloc] initWithUTF8String:createtime]];
            [_firstArray addObject:object];
            NSLog(@"current data ID:%d",(int)object.ID);
        }
        sqlite3_finalize(statement);
    }
    NSLog(@"load cache end");
    for (int m = 0; m < _firstArray.count; m++) {
        for (int n = m + 1; n < _firstArray.count; n++) {
            CellModel *obj1 = _firstArray[m];
            CellModel *obj2 = _firstArray[n];
            if (obj1.ID < obj2.ID) {
                CellModel *obj = [[CellModel alloc]init];
                obj = _firstArray[m];
                _firstArray[m] = _firstArray[n];
                _firstArray[n] = obj;
            }
        }
    }
    CellModel *model = [_firstArray lastObject];
    _theSmallerID = model.ID;
    model = [_firstArray firstObject];
    _theBiggerID = model.ID;
    [_collectionView reloadData];
    return model ? YES : NO;
}

- (NSString *)getImagePathFromCache:(NSString *)images
{
    NSString *url = [[images componentsSeparatedByString:@","] objectAtIndex:0];
    NSData *imagedata;
    NSString *path;
    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:url]];
    if (isExit) {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
        if (cacheImageKey.length) {
            path = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (path.length) {
                imagedata = [NSData dataWithContentsOfFile:path];
            }
        }
    }
    if (!imagedata) {
        imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        path = url;
    }
    return path;
}

#pragma mark - left item
- (void)openSlideViewController
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark - request
- (void)refreshStateChange:(UIRefreshControl *)control
{
    [_control beginRefreshing];
    [self getRequest:self.style tag:self.type refreshControl:control upOrDown:NO];
}

#pragma mark - topmenuview delegate
- (void)changeView:(StyleButton *)button
{
    self.type = button.type;
    self.style = button.style;
    if (button.type == _currentTag) {
        [self refreshStateChange:_control];
    }
    else
    {
        if (![self loadCache]) {
            [self refreshStateChange:_control];
        }
        _currentTag = button.type;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_style == 1) {
        return CGSizeMake(SCREENWIDTH / 2, SCREENWIDTH / 2 + 15);
    }else if (_style == 0){
        return CGSizeMake(SCREENWIDTH, 220);
    }else {
        return CGSizeMake(SCREENWIDTH, 100);
    }
}

#pragma mark - get data
- (void)getRequest:(NSInteger)style tag:(NSInteger)tag refreshControl:(UIRefreshControl *)control upOrDown:(BOOL)dir
{
    [self createDatabase];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *type = [NSString stringWithFormat:@"%ld",(long)_type];
    NSString *ID = [NSString stringWithFormat:@"%ld",(long)_theBiggerID];
    if (dir) {
        ID = [NSString stringWithFormat:@"%ld",(long)_theSmallerID];
    }
    NSDictionary *dic = @{@"startId":ID,@"type":type,@"dir":[NSString stringWithFormat:@"%d",dir]};
    NSLog(@"current request id:  %@",ID);
    NSLog(@"current request type:  %@",type);
    [manager POST:JSON parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        __block BOOL needToRefresh = NO;
        if (code == 200) {
            // 将接收的菜单数据转为数组，add to _menus
            NSMutableArray *array = [NSMutableArray arrayWithJsonString:[responseObject objectForKey:@"data"]];

            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                    // process data
                CellModel *object = [[CellModel alloc]init];
                object.name = [obj objectForKey:@"title"];
                object.browse = [[obj objectForKey:@"readNum"] integerValue];
                object.type = [[obj objectForKey:@"type"] integerValue];
                object.ID = [[obj objectForKey:@"id"] integerValue];
                NSArray *arr = [[obj objectForKey:@"images"] componentsSeparatedByString:@","];
                NSString *urls = [obj objectForKey:@"images"];
                object.image = arr[0];
                object.time = [self translateToYMD:[obj objectForKey:@"createtime"]];
                object.isCollected = NO;
                if (!dir && object.ID > _theBiggerID) {
                    NSString *insertToDatabase = [NSString stringWithFormat:@"INSERT INTO '%@' (idx,type,readNum,isCollected,title,images,createtime) VALUES(%d,%d,%d,%d,'%@','%@','%@')",@"cache",(int)object.ID,(int)object.type,(int)object.browse,object.isCollected,object.name,urls,object.time];
                    [self execSql:insertToDatabase];
                    [_firstArray addObject:object];
                    needToRefresh = YES;
                }
            }];
            NSLog(@"request end.......");
            for (int m = 0; m < _firstArray.count; m++) {
                for (int n = m + 1; n < _firstArray.count; n++) {
                    CellModel *obj1 = _firstArray[m];
                    CellModel *obj2 = _firstArray[n];
                    if (obj1.ID < obj2.ID) {
                        CellModel *obj = [[CellModel alloc]init];
                        obj = _firstArray[m];
                        _firstArray[m] = _firstArray[n];
                        _firstArray[n] = obj;
                    }
                }
            }
            
            CellModel *obj = [[CellModel alloc]init];
            obj = [_firstArray firstObject];
            _theBiggerID = obj.ID;
            obj = [_firstArray lastObject];
            _theSmallerID = obj.ID;
            if (needToRefresh) {
                [_collectionView reloadData];
            }
        }
        else {
            [self showAlertWithTitle:nil message:@"加载数据超时，请检查网络连接"];
        }
        if (control) {
            [control endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self showAlertWithTitle:nil message:@"加载数据超时，请检查网络连接"];
        if (control) {
            [control endRefreshing];
        }
    }];
}

#pragma mark - present to channelsViewController
- (void)addView
{
    ChannelsViewController *view = [[ChannelsViewController alloc]init];
    UINavigationController *controller = [[UINavigationController alloc]initWithRootViewController:view];
    self.delegate = view;
    [self.delegate passMenus:_menus tags:_typeArray style:_styleArray];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

#pragma mark - uicollectionview delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_style == 1) {
        _totalSection = _firstArray.count % 2 ? _firstArray.count / 2 + 1 : _firstArray.count / 2;
        return _totalSection;
    }
    return _firstArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_style != 1 || (_style == 1 && _firstArray.count % 2 && section == _firstArray.count / 2)) {
        return 1;
    }else {
        return 2;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.style) {
        case 0:
        {
            FirstCellStyle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstCellStyle" forIndexPath:indexPath];
            cell.delegate = self;
            cell.idx = indexPath;
            if(_firstArray.count){
                cell.model = _firstArray[indexPath.section + indexPath.item];
            }
            return cell;
            break;
        }
        case 1:
        {
            SecondCellStyle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SecondCellStyle" forIndexPath:indexPath];
            if(_firstArray.count){
                cell.model = _firstArray[indexPath.section * 2 + indexPath.item];
            }
            cell.idx = indexPath;
            cell.delegate = self;
            return cell;
            break;
        }
        case 2:
        {
            ThirdCellStyle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThirdCellStyle" forIndexPath:indexPath];
            cell.delegate = self;
            cell.idx = indexPath;
            if(_firstArray.count){
                cell.model = _firstArray[indexPath.section + indexPath.item];
            }
            return cell;
            break;
        }
        case 3:
        {
            ForthCellStyle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ForthCellStyle" forIndexPath:indexPath];
            cell.delegate = self;
            cell.idx = indexPath;
            if(_firstArray.count){
                cell.model = _firstArray[indexPath.section + indexPath.item];
            }
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CellModel *obj;
    if (_style == 1) {
        obj = _firstArray[indexPath.section * 2 + indexPath.item];
    }else {
        obj = _firstArray[indexPath.section + indexPath.item];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"Id"];
    NSString *newsid = [NSString stringWithFormat:@"%ld",(long)obj.ID];
    if (!userid) {
        userid = @"0";
    }
    NSDictionary *dic = @{@"userId":userid,@"newsId":newsid};
    [manager POST:BROWSE parameters:dic success:^(AFHTTPRequestOperation *operation,id responseObject){
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
    
    HTMLViewController *view = [[HTMLViewController alloc]init];
    NSString *urlString = [NSString stringWithFormat:@"%@%ld",HTML,(long)obj.ID];
    view.urlString = urlString;
    view.indexPath = indexPath;
    view.ID = obj.ID;
    view.delegate = self;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.y - fmaxf(.0f, scrollView.contentSize.height - scrollView.frame.size.height)) >= -100) {
        [self getRequest:self.style tag:self.type refreshControl:nil upOrDown:YES];
    }
}

#pragma mark - JS delegate
- (void)passBrowseNumber:(NSString *)number indexPath:(NSIndexPath *)indexPath id:(NSInteger)ID
{
    if (_style == 1) {
        CellModel *model = [_firstArray objectAtIndex:(indexPath.section * 2 + indexPath.item)];
        model.browse = [number integerValue];
        [_firstArray replaceObjectAtIndex:(indexPath.section * 2 + indexPath.item) withObject:model];
        NSArray *array = [NSArray arrayWithObject:indexPath];
        [_collectionView reloadItemsAtIndexPaths:array];
    } else {
        CellModel *model = [_firstArray objectAtIndex:indexPath.section];
        model.browse = [number integerValue];
        [_firstArray replaceObjectAtIndex:indexPath.section withObject:model];
        NSArray *array = [NSArray arrayWithObject:indexPath];
        [_collectionView reloadItemsAtIndexPaths:array];
    }
    NSString *update = [NSString stringWithFormat:@"UPDATE cache SET readNum=%@ WHERE idx=%d",number,(int)ID];
    [self execSql:update];
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

#pragma mark create database
- (void)createDatabase
{
    NSString *database_path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DATABASENAME];
    if (sqlite3_open([database_path UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"database open failed");
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

- (NSString *)translateToYMD:(NSString *)date
{
    NSString *Y = [date substringWithRange:NSMakeRange(0, 4)];
    NSString *M = [date substringWithRange:NSMakeRange(5, 2)];
    NSString *D = [date substringWithRange:NSMakeRange(8, 2)];
    NSString *str = [NSString stringWithFormat:@"%@.%@.%@",Y,M,D];
    return str;
}

#pragma mark - delegate collect & share
- (void)clickCollection:(NSIndexPath *)idx
{
    switch (_style) {
        case 0:
        {
            FirstCellStyle *cell = (FirstCellStyle *)[_collectionView cellForItemAtIndexPath:idx];
            CellModel *object = [_firstArray objectAtIndex:(idx.section + idx.item)];
            object.isCollected = !object.isCollected;
            if (!cell.collection.selected) {
                NSString *updateContent = [NSString stringWithFormat:@"UPDATE cache SET isCollected=1 WHERE idx=%d",(int)object.ID];
                [self execSql:updateContent];
                NSString *insertToDatabase = [NSString stringWithFormat:@"INSERT INTO '%@' (id,readNum,title,images,createtime) VALUES(%d,%d,'%@','%@','%@')",@"collection",(int)object.ID,(int)object.browse,object.name,object.image,object.time];
                [self execSql:insertToDatabase];
            }else {
                NSString *updateContent = [NSString stringWithFormat:@"UPDATE cache SET isCollected=0 WHERE idx=%d",(int)object.ID];
                [self execSql:updateContent];
                NSString *delete = [NSString stringWithFormat:@"DELETE FROM collection WHERE id=%d",(int)object.ID];
                [self execSql:delete];
            }
            cell.collection.selected = !cell.collection.selected;
            break;
        }
        case 1:
        {
            SecondCellStyle *cell = (SecondCellStyle *)[_collectionView cellForItemAtIndexPath:idx];
            CellModel *object = [_firstArray objectAtIndex:(idx.section * 2 + idx.item)];
            object.isCollected = !object.isCollected;
            if (!cell.collection.selected) {
                NSString *updateContent = [NSString stringWithFormat:@"UPDATE cache SET isCollected=1 WHERE idx=%d",(int)object.ID];
                [self execSql:updateContent];
                NSString *insertToDatabase = [NSString stringWithFormat:@"INSERT INTO '%@' (id,readNum,title,images,createtime) VALUES(%d,%d,'%@','%@','%@')",@"collection",(int)object.ID,(int)object.browse,object.name,object.image,object.time];
                [self execSql:insertToDatabase];
            }else {
                NSString *updateContent = [NSString stringWithFormat:@"UPDATE cache SET isCollected=0 WHERE idx=%d",(int)object.ID];
                [self execSql:updateContent];
                NSString *delete = [NSString stringWithFormat:@"DELETE FROM collection WHERE id=%d",(int)object.ID];
                [self execSql:delete];
            }
            cell.collection.selected = !cell.collection.selected;
            break;
        }
        case 2:
        {
            ThirdCellStyle *cell = (ThirdCellStyle *)[_collectionView cellForItemAtIndexPath:idx];
            CellModel *object = [_firstArray objectAtIndex:(idx.section + idx.item)];
            object.isCollected = !object.isCollected;
            if (!cell.collection.selected) {
                NSString *updateContent = [NSString stringWithFormat:@"UPDATE cache SET isCollected=1 WHERE idx=%d",(int)object.ID];
                [self execSql:updateContent];
                NSString *insertToDatabase = [NSString stringWithFormat:@"INSERT INTO '%@' (id,readNum,title,images,createtime) VALUES(%d,%d,'%@','%@','%@')",@"collection",(int)object.ID,(int)object.browse,object.name,object.image,object.time];
                [self execSql:insertToDatabase];
            }else {
                NSString *updateContent = [NSString stringWithFormat:@"UPDATE cache SET isCollected=0 WHERE idx=%d",(int)object.ID];
                [self execSql:updateContent];
                NSString *delete = [NSString stringWithFormat:@"DELETE FROM collection WHERE id=%d",(int)object.ID];
                [self execSql:delete];
            }
            cell.collection.selected = !cell.collection.selected;
            break;
        }
        case 3:
        {
            ForthCellStyle *cell = (ForthCellStyle *)[_collectionView cellForItemAtIndexPath:idx];
            CellModel *object = [_firstArray objectAtIndex:idx.section + idx.item];
            object.isCollected = !object.isCollected;
            if (!cell.collection.selected) {
                NSString *updateContent = [NSString stringWithFormat:@"UPDATE cache SET isCollected=1 WHERE idx=%d",(int)object.ID];
                [self execSql:updateContent];
                NSString *insertToDatabase = [NSString stringWithFormat:@"INSERT INTO '%@' (id,readNum,title,images,createtime) VALUES(%d,%d,'%@','%@','%@')",@"collection",(int)object.ID,(int)object.browse,object.name,object.image,object.time];
                [self execSql:insertToDatabase];
            }else {
                NSString *updateContent = [NSString stringWithFormat:@"UPDATE cache SET isCollected=0 WHERE idx=%d",(int)object.ID];
                [self execSql:updateContent];
                NSString *delete = [NSString stringWithFormat:@"DELETE FROM collection WHERE id=%d",(int)object.ID];
                [self execSql:delete];
            }
            cell.collection.selected = !cell.collection.selected;
            break;
        }
        default:
            break;
    }
}

- (void)clickShare:(NSIndexPath *)idx
{
    CellModel *model;
    if (_style == 1) {
        model = [_firstArray objectAtIndex:idx.section * 2 + idx.item];
    }else {
        model = [_firstArray objectAtIndex:idx.section + idx.item];
    }
    NSString *path = [self getImagePathFromCache:model.image];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%d",HTML,(int)model.ID];
    [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"%@%d",HTML,(int)model.ID];
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@%d",HTML,(int)model.ID];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%d",HTML,(int)model.ID];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56a22f34e0f55aff5e000e7f" shareText:model.name shareImage:[UIImage imageWithContentsOfFile:path] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,nil] delegate:nil];
}

@end