//
//  ENAuth.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 18.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "ENAuth.h"
#import "NSString+MD5.h"
#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>
#import "FDKeychain.h"


#pragma mark Constants

static NSString * const KeychainItem_Service = @"ENmrk";
static NSString * const KeychainItem_Key_LocalPassword = @"LocalPassword";
static NSString * const KeychainItem_Key_LocalLogin = @"LocalLogin";


@implementation ENAuth

- (void)reAuthWithResponseObject:(NSMutableDictionary *)responseObject {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *registerDefaults = [NSMutableDictionary dictionary];
    
    NSString *rnd = [responseObject objectForKey:@"rnd"];
    NSString *rndDecoded = [ENAuth decrypthRNDforRNDEncoded:rnd];
    
    [registerDefaults setObject:rndDecoded forKey:@"ENSettingRND"];

    [userDefaults registerDefaults:registerDefaults];
    [userDefaults synchronize];
}

- (void)firstAuthWithLogin:(NSString *)login andPassword:(NSString *)password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *registerDefaults = [NSMutableDictionary dictionary];
    if (login) {
        [registerDefaults setObject:login forKey:@"ENSettingLogin"];
    }
    [registerDefaults setObject:password forKey:@"ENSettingPassword"];
    NSString *md5pass = [password MD5];
    [registerDefaults setObject:md5pass forKey:@"ENSettingMD5Password"];
    [userDefaults registerDefaults:registerDefaults];
    [userDefaults synchronize];
    
    NSError *error;
    [FDKeychain saveItem: password
                  forKey: KeychainItem_Key_LocalPassword
              forService: KeychainItem_Service
                   error: &error];
    
    NSError *error1;
    [FDKeychain saveItem: login
                  forKey: KeychainItem_Key_LocalLogin
              forService: KeychainItem_Service
                   error: &error1];
    
}

+ (NSDictionary *)parametersForAPI {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *login = [userDefaults stringForKey:@"ENSettingLogin"];
    NSString *passEncoded = [self passEncoded];
    
    NSDictionary *parameters = @{@"login": login, @"pass": passEncoded};
    return parameters;
}

+ (NSString *)passEncodedForPassword:(NSString *) password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *newrnd = [userDefaults stringForKey:@"ENSettingRND"];
    
    NSData *keyData = [self createDataWithHexString:newrnd];
    
    int iv_size = 16;
    
    NSMutableData *iv_data = [NSMutableData dataWithCapacity:iv_size];
    for( unsigned int i = 0 ; i < iv_size/4 ; ++i )
    {
        u_int32_t randomBits = arc4random();
        [iv_data appendBytes:(void*)&randomBits length:4];
    }
    
    NSData *pre_val_data_pre = [password dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *pre_val_data = [NSMutableData dataWithData:pre_val_data_pre];
    NSInteger pre_val_length = pre_val_data.length;
    NSInteger crt = pre_val_length % iv_size;
    if (!(crt == 0)) {
        crt = iv_size - crt;
    }
    NSMutableData *add_data = [NSMutableData dataWithLength:crt];
    [pre_val_data appendData:add_data];
    NSMutableData *val_data = pre_val_data;
    
    NSMutableData *cipherData = [NSMutableData dataWithLength:32];
    size_t outLength;
    
    CCCryptorStatus result
    = CCCrypt(kCCEncrypt, // operation, replace with kCCDecrypt to decrypt
              kCCAlgorithmAES128, // Same as MCRYPT_RIJNDAEL_256
              kCCOptionPKCS7Padding , // CBC mode
              keyData.bytes, // key
              kCCKeySizeAES128, // Since you are using AES256
              iv_data.bytes,// iv
              val_data.bytes, // dataIn
              val_data.length, // dataInLength,
              cipherData.mutableBytes, // dataOut
              cipherData.length, // dataOutAvailable
              &outLength); // dataOutMoved
    
    NSRange range = NSMakeRange(0,16);
    NSData *cipherDataNew = [cipherData subdataWithRange:range];
    
    NSMutableData *new_data = iv_data;
    [new_data appendData:cipherDataNew];
    
    NSString *resultString = [[NSString alloc] init];
    
    if (result == kCCSuccess) {
        resultString = [new_data base64EncodedStringWithOptions:0];
        
    } else {
        NSLog(@"Error of encrypt: %@",[[NSString alloc] initWithFormat:@"Crypthor status: %d", result]);
    }
    
    return resultString;
}

+ (NSString *)passEncoded {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [userDefaults stringForKey:@"ENSettingPassword"];
    NSString *newrnd = [userDefaults stringForKey:@"ENSettingRND"];
    
    NSData *keyData = [self createDataWithHexString:newrnd];
    
    int iv_size = 16;
    
    NSMutableData *iv_data = [NSMutableData dataWithCapacity:iv_size];
    for( unsigned int i = 0 ; i < iv_size/4 ; ++i )
    {
        u_int32_t randomBits = arc4random();
        [iv_data appendBytes:(void*)&randomBits length:4];
    }
    
    NSData *pre_val_data_pre = [password dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *pre_val_data = [NSMutableData dataWithData:pre_val_data_pre];
    NSInteger pre_val_length = pre_val_data.length;
    NSInteger crt = pre_val_length % iv_size;
    if (!(crt == 0)) {
        crt = iv_size - crt;
    }
    NSMutableData *add_data = [NSMutableData dataWithLength:crt];
    [pre_val_data appendData:add_data];
    NSMutableData *val_data = pre_val_data;
    
    NSMutableData *cipherData = [NSMutableData dataWithLength:32];
    size_t outLength;
    
    CCCryptorStatus result
    = CCCrypt(kCCEncrypt, // operation, replace with kCCDecrypt to decrypt
              kCCAlgorithmAES128, // Same as MCRYPT_RIJNDAEL_256
              kCCOptionPKCS7Padding , // CBC mode
              keyData.bytes, // key
              kCCKeySizeAES128, // Since you are using AES256
              iv_data.bytes,// iv
              val_data.bytes, // dataIn
              val_data.length, // dataInLength,
              cipherData.mutableBytes, // dataOut
              cipherData.length, // dataOutAvailable
              &outLength); // dataOutMoved
    
    NSRange range = NSMakeRange(0,16);
    NSData *cipherDataNew = [cipherData subdataWithRange:range];
    
    NSMutableData *new_data = iv_data;
    [new_data appendData:cipherDataNew];
    
    NSString *resultString = [[NSString alloc] init];
    
    if (result == kCCSuccess) {
        resultString = [new_data base64EncodedStringWithOptions:0];
        
    } else {
        NSLog(@"Error of encrypt: %@",[[NSString alloc] initWithFormat:@"Crypthor status: %d", result]);
    }
    
    return resultString;
}

+ (NSString *)decrypthRNDforRNDEncoded:(NSString *)rndEncoded {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *md5pass = [userDefaults stringForKey:@"ENSettingMD5Password"];
    
    const char *pass_md5 = [md5pass cStringUsingEncoding:[NSString defaultCStringEncoding]];
    char key[32];
    for(int i = 0; i < 16; i++){
        int q;
        sscanf(pass_md5 + i * 2, "%02x", &q);
        key[i] = q;
    }
    for(int i = 16; i < 32; i ++)
        key[i] = 0;
    
    int iv_size = 16;
    
    NSMutableData *ciphertext_dec_data = [[NSMutableData alloc] initWithBase64EncodedString:rndEncoded options:0];
    NSInteger ciphertext_length = ciphertext_dec_data.length;
    
    NSRange iv_dec_range = NSMakeRange(0, iv_size);
    NSData *iv_dec_data = [ciphertext_dec_data subdataWithRange:iv_dec_range];
    
    NSRange ciphertext_dec_range = NSMakeRange(iv_size, ciphertext_length - iv_size);
    NSData *ciphertext_dec = [ciphertext_dec_data subdataWithRange:ciphertext_dec_range];
    
    NSData *iv = iv_dec_data;
    NSData *data = ciphertext_dec;
    NSMutableData *cipherData = [NSMutableData dataWithLength:32];
    size_t outLength;
    
    CCCryptorStatus result
    = CCCrypt(kCCDecrypt, // operation, replace with kCCDecrypt to decrypt
              kCCAlgorithmAES128, // Same as MCRYPT_RIJNDAEL_256
              kCCOptionPKCS7Padding , // CBC mode
              key, // key
              kCCKeySizeAES128, // Since you are using AES256
              iv.bytes,// iv
              data.bytes, // dataIn
              data.length, // dataInLength,
              cipherData.mutableBytes, // dataOut
              cipherData.length, // dataOutAvailable
              &outLength); // dataOutMoved
    NSString *resultString = [[NSString alloc] init];
    if (result == kCCSuccess) {
        resultString = [[NSString alloc] initWithData:cipherData encoding:NSASCIIStringEncoding];
    } else {
        resultString = [[NSString alloc] initWithFormat:@"Crypthor status: %d", result];
    }
    
    return resultString;
}


+ (NSData *) createDataWithHexString:(NSString *)inputString
{
    NSUInteger inLength = [inputString length];
    
    unichar *inCharacters = alloca(sizeof(unichar) * inLength);
    [inputString getCharacters:inCharacters range:NSMakeRange(0, inLength)];
    
    UInt8 *outBytes = malloc(sizeof(UInt8) * ((inLength / 2) + 1));
    
    NSInteger i, o = 0;
    UInt8 outByte = 0;
    for (i = 0; i < inLength; i++) {
        UInt8 c = inCharacters[i];
        SInt8 value = -1;
        
        if      (c >= '0' && c <= '9') value =      (c - '0');
        else if (c >= 'A' && c <= 'F') value = 10 + (c - 'A');
        else if (c >= 'a' && c <= 'f') value = 10 + (c - 'a');
        
        if (value >= 0) {
            if (i % 2 == 1) {
                outBytes[o++] = (outByte << 4) | value;
                outByte = 0;
            } else {
                outByte = value;
            }
            
        } else {
            if (o != 0) break;
        }
    }
    
    return [[NSData alloc] initWithBytesNoCopy:outBytes length:o freeWhenDone:YES];
}

@end
