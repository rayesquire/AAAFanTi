//
//  First.h
//  afanti
//
//  Created by 尾巴超大号 on 15/11/25.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject

@property (nonatomic, readwrite, copy) NSString *time;

@property (nonatomic, readwrite, copy) NSString *name;

@property (nonatomic, readwrite, copy) NSString *image;

@property (nonatomic, readwrite, assign) BOOL isCollected;

@property (nonatomic, readwrite, assign) NSInteger type;

@property (nonatomic, readwrite, assign) NSInteger ID;

@property (nonatomic, readwrite, assign) NSInteger browse;

- (CellModel *)initWithID:(NSInteger)ID type:(NSInteger)type browse:(NSInteger)browse isCollected:(BOOL)isCollected name:(NSString *)name image:(NSString *)image time:(NSString *)time;
@end
