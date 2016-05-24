//
//  ChannelsViewController.m
//  afanti
//
//  Created by 尾巴超大号 on 15/11/27.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "ChannelsViewController.h"
#import "sqlite3.h"
#import "NSMutableDictionary+extension.h"
#import "AFNetWorking.h"
#import "ChannelButton.h"
#import "StyleButton.h"
#define BTNWIDTH ([UIScreen mainScreen].bounds.size.width - 35)/4
#define JSONMENU @"http://121.43.104.78:8081/WebService/getTabData"
#define DATABASENAME @"afanti.sqlite"
@interface ChannelsViewController () <UIGestureRecognizerDelegate,ChannelButtonDelegate>

@property (nonatomic, readwrite, assign) sqlite3 *database;

@property (nonatomic, readwrite, strong) UIView *bkg;                       // background imageview

@property (nonatomic, readwrite, strong) UILabel *myChannels;               // mychannels label

@property (nonatomic, readwrite, strong) UILabel *channelRecommend;          // channelrecommend label

@property (nonatomic, readwrite, strong) UIButton *edit;                     // edit button

@property (nonatomic, readwrite, copy) NSMutableArray *myChannelTitles;        // my channels title array

@property (nonatomic, readwrite, copy) NSMutableArray *myChannelButtons;       // my channels button array

@property (nonatomic, readwrite, copy) NSMutableArray *myChannelTags;

@property (nonatomic, readwrite, copy) NSMutableArray *myChannelStyles;

@property (nonatomic, readwrite, copy) NSMutableArray *dataArray;   // data dictionary

@property (nonatomic, readwrite, copy) NSMutableArray *allChannelButtons;  // all channels button array

@property (nonatomic, readwrite, strong) UIView *lastMyButton;              // the last channel,use to autolayout

@property (nonatomic, readwrite, strong) UIView *firstMyButton;

@property (nonatomic, readwrite, strong) UIButton *lastAllButtons;

@property (nonatomic, readwrite, strong) UIView *shelter;      // invisiable view to avoid touching all channels when unediting status

@property (nonatomic, readwrite, assign) BOOL needToUpdateDB;

@end

@implementation ChannelsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    _needToUpdateDB = NO;
    [self createDatabase];
    [self requestDataAndSave];
    [self initBkg];
    [self initMyChannels];
    [self initChannelRecommend];
    [self initButton];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    /**************/
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"backfrommenu"];
}

- (void)requestDataAndSave
{
    _dataArray = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:JSONMENU parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 200) {
            // 将接收的菜单数据转为数组，add to _menus
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithJsonString:[responseObject objectForKey:@"data"]];
            _dataArray = [dic valueForKey:@"tableList"];
            _allChannelButtons = [[NSMutableArray alloc]init];
            for (int i = 0; i < _dataArray.count; i++) {
                StyleButton *btn = [self createButtonWithTitle:[_dataArray[i] objectForKey:@"title"] type:[_dataArray[i] objectForKey:@"type"] style:[_dataArray[i] objectForKey:@"styletype"]];
                [_allChannelButtons addObject:btn];
            }
            [self addChannelRecommend];
        }
        else {
            [self showAlertWithTitle:nil message:@"加载数据超时，请检查网络连接"];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self showAlertWithTitle:nil message:@"加载数据超时，请检查网络连接"];
    }];
}

#pragma mark - init
- (void)initBkg
{
    _bkg = [[UIView alloc]init];
    _bkg.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    _bkg.translatesAutoresizingMaskIntoConstraints = NO;
    _bkg.userInteractionEnabled = YES;
    [self.view addSubview:_bkg];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bkg]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bkg)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_bkg]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bkg)]];
}

- (void)initMyChannels
{
    _myChannels = [[UILabel alloc]init];
    _myChannels.translatesAutoresizingMaskIntoConstraints = NO;
    [_myChannels setFont:[UIFont systemFontOfSize:15]];
    _myChannels.text = @"我的频道";
    [_bkg addSubview:_myChannels];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_myChannels(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_myChannels)]];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_myChannels(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_myChannels)]];
    
    _edit = [UIButton buttonWithType:UIButtonTypeCustom];
    _edit.translatesAutoresizingMaskIntoConstraints = NO;
    [_edit.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_edit setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [_edit setTitle:@"编辑" forState:UIControlStateNormal];
    [_edit setTitle:@"完成" forState:UIControlStateSelected];
    [_edit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_edit addTarget:self action:@selector(editChannels:) forControlEvents:UIControlEventTouchUpInside];
    [_bkg addSubview:_edit];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_edit(60)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_edit)]];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-73-[_edit(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_edit)]];
    
    _myChannelButtons = [[NSMutableArray alloc]init];
    for (int i = 0; i < _myChannelTitles.count; i++) {
        NSNumber *tmp = _myChannelStyles[i];
        ChannelButton *btn = [[ChannelButton alloc]initWithIndex:i style:[tmp integerValue]];
        [btn setButtonTitle:_myChannelTitles[i]];
        [btn setEdited:NO];
        btn.delegate = self;
        btn.tag = [_myChannelTags[i] integerValue];
        btn.style = [_myChannelStyles[i] integerValue];
        [_bkg addSubview:btn];
        if (!i) {
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-10-[btn(%f)]",BTNWIDTH] options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_myChannels]-20-[btn(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn,_myChannels)]];
            _firstMyButton = btn;
        }else if (!(i % 4)){
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_firstMyButton]-10-[btn]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings(_firstMyButton,btn)]];
        }else {
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_lastMyButton]-5-[btn(%f)]",BTNWIDTH] options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(btn,_lastMyButton)]];
        }
        _lastMyButton = btn;
        [_myChannelButtons addObject:btn];
    }
}

- (void)initChannelRecommend
{
    _channelRecommend = [[UILabel alloc]init];
    _channelRecommend.translatesAutoresizingMaskIntoConstraints = NO;
    [_channelRecommend setFont:[UIFont systemFontOfSize:15]];
    [_channelRecommend setText:@"频道推荐"];
    [_bkg addSubview:_channelRecommend];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_channelRecommend]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_channelRecommend)]];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lastMyButton]-25-[_channelRecommend]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lastMyButton,_channelRecommend)]];
}

- (void)addChannelRecommend
{
    _lastAllButtons = nil;
    StyleButton *first = nil;    // the no.1 of line
    for (int i = 0; i < _allChannelButtons.count; i++) {
        StyleButton *btn = _allChannelButtons[i];
        if (!i) {
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-10-[btn(%f)]",BTNWIDTH] options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_channelRecommend]-20-[btn(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn,_channelRecommend)]];
            first = btn;
        }else if (!(i % 4)){
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[first]-10-[btn(35)]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings(first,btn)]];
        }else {
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_lastAllButtons]-5-[btn(%f)]",BTNWIDTH] options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(btn,_lastAllButtons)]];
        }
        _lastAllButtons = btn;
    }
    [self addShelter];
}

- (void)initButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"firstPage_close_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"firstPage_close_focus"] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"firstPage_close_focus"] forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(0, 0, 15, 15)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [button addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - delegate method to load mychannels
- (void)passMenus:(NSMutableArray *)menus tags:(NSMutableArray *)tags style:(NSMutableArray *)style
{
    _myChannelTitles = [[NSMutableArray alloc]initWithArray:menus];
    _myChannelTags = [[NSMutableArray alloc]initWithArray:tags];
    _myChannelStyles = [[NSMutableArray alloc]initWithArray:style];
}

#pragma mark - pop view
- (void)closeSelf
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - create channelbutton
- (StyleButton *)createButtonWithTitle:(NSString *)title type:(NSNumber *)number style:(NSNumber *)style
{
    StyleButton *btn = [StyleButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"square"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn addTarget:self action:@selector(clickToAddChannel:) forControlEvents:UIControlEventTouchUpInside];
    btn.type = [number integerValue];
    btn.style = [style integerValue];
    [_bkg addSubview:btn];
    return btn;
}

#pragma mark - edit channels
- (void)editChannels:(UIButton *)sender
{
    if (!sender.selected) {
        sender.selected = YES;
        [_myChannelButtons enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
            ChannelButton *btn = (ChannelButton *)obj;
            btn.edited = YES;
        }];
        [_shelter removeFromSuperview];
    }else if (sender.selected){
        sender.selected = NO;
        [_myChannelButtons enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
            ChannelButton *btn = (ChannelButton *)obj;
            btn.edited = NO;
        }];
        [self addShelter];
        if (_needToUpdateDB) {
            // update db
            [self updateDatabase];
        }
        _needToUpdateDB = NO;
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *   updateDatabase
 */
- (void)updateDatabase
{
    NSString *delete = @"DELETE FROM channel";
    [self execSql:delete];
    [_myChannelButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        ChannelButton *btn = (ChannelButton *)obj;
        NSString *add = [NSString stringWithFormat:@"INSERT INTO '%@' (type,title,mine,idx,style) VALUES(%d,'%@',%d,%d,%d)",@"channel",(int)btn.tag,btn.buttonTitle,1,(int)btn.index,(int)btn.style];
        [self execSql:add];
    }];

}
/**
 *   add shelter to avoid touching recommand channels in unediting status
 */
- (void)addShelter
{
    _shelter = [[UIView alloc]init];
    _shelter.translatesAutoresizingMaskIntoConstraints = NO;
    _shelter.backgroundColor = [UIColor clearColor];
    [_bkg addSubview:_shelter];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_shelter]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_shelter)]];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_channelRecommend][_shelter(200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_shelter,_channelRecommend)]];
}

/**
 *   delete channel
 */
- (void)deleteButton:(NSInteger)index
{
    if (_myChannelButtons.count == 1) {
//        [self showAlertWithTitle:@"至少有一个频道！" message:nil];
        return;
    }
    ChannelButton *btn = _myChannelButtons[index];
    [btn removeFromSuperview];
    [_myChannelButtons removeObjectAtIndex:index];
    // database operation
    _needToUpdateDB = YES;
    [self updateMyChannels];
}
/**
 *   update other channels' layout,maintain any properties except index
 */
- (void)updateMyChannels
{
    _firstMyButton = nil;
    _lastMyButton = nil;
    
    NSArray *constraints = _bkg.constraints;
    for (NSLayoutConstraint *constaint in constraints) {
        [_bkg removeConstraint:constaint];
    }
    
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_myChannels(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_myChannels)]];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_myChannels(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_myChannels)]];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_edit(60)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_edit)]];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-73-[_edit(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_edit)]];
    
    [_myChannelButtons enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        ChannelButton *btn = (ChannelButton *)obj;
        btn.index = idx;
        if (!btn.index) {
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-10-[btn(%f)]",BTNWIDTH] options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_myChannels]-20-[btn(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn,_myChannels)]];
            _firstMyButton = btn;
        }else if (!(btn.index % 4)){
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_firstMyButton]-10-[btn(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstMyButton,btn)]];
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-10-[btn(%f)]",BTNWIDTH] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstMyButton,btn)]];
        }else {
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_lastMyButton]-5-[btn(%f)]",BTNWIDTH] options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(btn,_lastMyButton)]];
        }
        _lastMyButton = btn;
    }];
    [self updateRecommandChannels];
}
/**
 *   update reconmmand channels' layout
 */
- (void)updateRecommandChannels
{
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_channelRecommend]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_channelRecommend)]];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lastMyButton]-25-[_channelRecommend]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lastMyButton,_channelRecommend)]];
    
    StyleButton *first = nil;    // the no.1 of line
    for (int i = 0; i < _allChannelButtons.count; i++) {
        StyleButton *btn = _allChannelButtons[i];
        if (!i) {
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-10-[btn(%f)]",BTNWIDTH] options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_channelRecommend]-20-[btn(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn,_channelRecommend)]];
            first = btn;
        }else if (!(i % 4)){
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[first]-10-[btn(35)]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings(first,btn)]];
        }else {
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_lastAllButtons]-5-[btn(%f)]",BTNWIDTH] options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(btn,_lastAllButtons)]];
        }
        _lastAllButtons = btn;
    }
}

#pragma mark - add channel
/**
 *   button method
 */
- (void)clickToAddChannel:(StyleButton *)sender
{
    __block BOOL result = NO;
    [_myChannelButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        ChannelButton *btn = (ChannelButton *)obj;
        if (sender.type == btn.tag) {
            result = YES;
        }
    }];
    if (result) {
        return;
    }else {
        [self addMyChannelButton:sender];
    }
}
/**
 *   add button to mychannel and update layout
 */
- (void)addMyChannelButton:(StyleButton *)button
{
    ChannelButton *btn = [[ChannelButton alloc]init];
    [btn setEdited:YES];
    [btn setButtonTitle:button.titleLabel.text];
    btn.delegate = self;
    btn.index = _myChannelButtons.count;
    btn.style = button.style;
    // 因为推荐频道的顺序是不会变的，所以推荐频道按钮的tag值为唯一标识符，等同于我的频道的type
    btn.tag = button.type;
    [_bkg addSubview:btn];
    [_myChannelButtons addObject:btn];
    if (!(btn.index % 4)){
        [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_firstMyButton]-10-[btn(35)]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings(_firstMyButton,btn)]];
    }else {
        [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_lastMyButton]-5-[btn(%f)]",BTNWIDTH] options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(btn,_lastMyButton)]];
    }
    _lastMyButton = btn;
    [self updateAllChannels];
    _needToUpdateDB = YES;
}
/**
 *   update allchannels' layout
 */
- (void)updateAllChannels
{
    [_channelRecommend removeFromSuperview];
    [_bkg addSubview:_channelRecommend];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_channelRecommend]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_channelRecommend)]];
    [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lastMyButton]-25-[_channelRecommend]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lastMyButton,_channelRecommend)]];
    
    _lastAllButtons = nil;
    StyleButton *first = nil;    // the no.1 of line
    for (int i = 0; i < _allChannelButtons.count; i++) {
        StyleButton *btn = _allChannelButtons[i];
        if (!i) {
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-10-[btn(%f)]",BTNWIDTH] options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_channelRecommend]-20-[btn(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn,_channelRecommend)]];
            first = btn;
        }else if (!(i % 4)){
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[first]-10-[btn(35)]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings(first,btn)]];
        }else {
            [_bkg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_lastAllButtons]-5-[btn(%f)]",BTNWIDTH] options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(btn,_lastAllButtons)]];
        }
        _lastAllButtons = btn;
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
