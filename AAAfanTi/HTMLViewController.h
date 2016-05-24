//
//  HTMLViewController.h
//  afanti
//
//  Created by 尾巴超大号 on 15/12/16.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JSPassBrowseValueDelegate <NSObject>

@optional
- (void)passBrowseNumber:(NSString *)number indexPath:(NSIndexPath *)indexPath id:(NSInteger)ID;

@end

@interface HTMLViewController : UIViewController

@property (nonatomic, readwrite, copy) NSString *urlString;

@property (nonatomic, readwrite, assign) NSInteger ID;

@property (nonatomic, readwrite, strong) NSIndexPath *indexPath;

@property (nonatomic, readwrite, weak) id<JSPassBrowseValueDelegate> delegate;

@end
