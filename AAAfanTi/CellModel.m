//
//  First.m
//  afanti
//
//  Created by 尾巴超大号 on 15/11/25.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

- (CellModel *)initWithID:(NSInteger)ID type:(NSInteger)type browse:(NSInteger)browse isCollected:(BOOL)isCollected name:(NSString *)name image:(NSString *)image time:(NSString *)time
{
    if (self = [super init]) {
        self.ID = ID;
        self.type = type;
        self.browse = browse;
        self.isCollected = isCollected;
        self.name = name;
        self.image = image;
        self.time = time;
    }
    return self;
}

@end
