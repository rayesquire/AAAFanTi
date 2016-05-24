//
//  NSData+AES256.h
//  afanti
//
//  Created by 尾巴超大号 on 15/12/6.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSData (AES256)

- (NSData *)aes256_encrypt:(NSString *)key;

- (NSData *)aes256_decrypt:(NSString *)key;

- (NSData *)AES256EncryptWithKey:(NSString *)key;

- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
