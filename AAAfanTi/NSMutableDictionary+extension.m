//
//  NSMutableArray+extension.m
//  afanti
//
//  Created by 尾巴超大号 on 15/11/30.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "NSMutableDictionary+extension.h"

@implementation NSMutableDictionary (extension)

+ (NSMutableDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (!jsonString) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@",error);
        return nil;
    }
    return dic;
}

@end
