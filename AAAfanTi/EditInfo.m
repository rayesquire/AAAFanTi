//
//  EditInfo.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/7.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "EditInfo.h"
#import "AVFoundation/AVFoundation.h"
#import "PersonInfo.h"
#import "EditName.h"
#import "ViewController.h"
#import <AFNetworking.h>
#import "RESideMenu.h"
#import "AFanTiNavigationController.h"
#import "NSMutableDictionary+extension.h"
#import "SlideViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define JSON @"http://121.43.104.78:8081/webservice/setUser"
//#define JSON @"http://121.43.104.78:8081/webservice/setUser?userId=6&nickname=小号那个&headUrl=http://www.ddi.com/ddd.png"
#define POSTIMAGE @"http://121.43.104.78:8081/WebService/UploadImage?type=0"
@interface EditInfo () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, readwrite, strong) UITableView *tableView;

@property (nonatomic, readwrite, strong) UIImageView *avator;

@property (nonatomic, readwrite, copy) NSString *imageurl;
@end

@implementation EditInfo

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"name"]) {
        if (_tableView) {
            [_tableView reloadData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    self.title = @"个人资料";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(pop)];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView(133)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
}

- (void)pop
{
    [self.sideMenuViewController setContentViewController:[[AFanTiNavigationController alloc]initWithRootViewController:[[ViewController alloc]init]] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"info"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        PersonInfo *cell = [[PersonInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstinfo"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"]) {
            [cell setAvator:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatorurl"]];
        }else {
            [cell setUserAvator:[UIImage imageNamed:@"firstPage_leftButton"]];
        }
        cell.textLabel.text = @"头像";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"昵称";
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"name"]) {
            cell.detailTextLabel.text = @"请填写";
        }else{
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }else
        return 44;
}

#pragma mark - post image
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [self useCamera];
    }else if (indexPath.row == 1){
        [self.navigationController presentViewController:[[AFanTiNavigationController alloc] initWithRootViewController:[[EditName alloc]init]]  animated:YES completion:nil];
    }
}

// 调用相机
- (void)useCamera
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择照片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相机",@"从手机相册选择",nil];
    [actionSheet showInView:self.view];
}

//选择弹窗
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:     // 相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 1:     // 相册
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
    }
}

// 使用照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 保存/上传图片
- (void)saveImage:(UIImage *)image
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"avator.jpg"];
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件

    _avator.image = selfPhoto;
    _imageurl = imageFilePath;
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:POSTIMAGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
         [formData appendPartWithFileData:UIImageJPEGRepresentation(selfPhoto, 1) name:@"Image" fileName:imageFilePath mimeType:@"image/jpg"];
     }success:^(AFHTTPRequestOperation *operation, id responseObject){
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([[dic objectForKey:@"code"] integerValue] == 200 ) {
             NSString *path = [dic objectForKey:@"data"];
             [self postInfo:path localPath:imageFilePath];
         }
     }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self showAlertWithTitle:@"修改头像失败" message:nil];
     }];
}

- (void)postInfo:(NSString *)url localPath:(NSString *)localPath
{
    __block NSString *avator = url;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *parameters =@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"Id"],@"nickname":@"",@"headUrl":url};
    [manager POST:[JSON stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"code"] integerValue] == 200 ) {
            avator = [avator substringWithRange:NSMakeRange(1, avator.length-2)];
            [[NSUserDefaults standardUserDefaults] setObject:avator forKey:@"avatorurl"];
            [_tableView reloadData];
        }else {
            [self showAlertWithTitle:@"修改头像失败" message:nil];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self showAlertWithTitle:@"修改头像失败" message:nil];
    }];
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
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
