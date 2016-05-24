//
//  AFanTiNavigationController.m
//  afanti
//
//  Created by 尾巴超大号 on 15/11/23.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "AFanTiNavigationController.h"

@interface AFanTiNavigationController ()

@end

@implementation AFanTiNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"leftImage2"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

@end
