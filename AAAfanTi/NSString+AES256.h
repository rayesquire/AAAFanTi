//
//  NSString+AES256.h
//  afanti
//
//  Created by 尾巴超大号 on 15/12/6.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+AES256.h"
@interface NSString (AES256)

- (NSString *) aes256_encrypt:(NSString *)key;

- (NSString *) aes256_decrypt:(NSString *)key;

- (NSString *)AES256EncryptWithKey:(NSString *)key;

- (NSString *)AES256DecryptWithKey:(NSString *)key;

@end
