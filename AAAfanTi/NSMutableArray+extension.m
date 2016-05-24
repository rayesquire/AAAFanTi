//
//  NSMutableArray+extension.m
//  afanti
//
//  Created by 尾巴超大号 on 15/12/2.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "NSMutableArray+extension.h"

@implementation NSMutableArray (extension)

+ (NSMutableArray *)arrayWithJsonString:(NSString *)jsonString
{
    if (!jsonString) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@",error);
        return nil;
    }
    return array;
}

@end
