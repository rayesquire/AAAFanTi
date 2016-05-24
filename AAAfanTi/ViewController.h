//
//  ViewController.h
//  afanti
//
//  Created by 尾巴超大号 on 15/11/23.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerDelegate <NSObject>

@optional
- (void)passMenus:(NSMutableArray *)menus tags:(NSMutableArray *)tags style:(NSMutableArray *)style;

@end


@interface ViewController : UIViewController

@property (nonatomic,weak) id<ViewControllerDelegate> delegate;

@property (nonatomic, readwrite, assign) NSInteger type;

@end

