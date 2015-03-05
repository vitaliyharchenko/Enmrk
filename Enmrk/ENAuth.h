//
//  ENAuth.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 18.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENAuth : NSObject

- (void)reAuthWithResponseObject:(NSMutableDictionary *)responseObject;
- (void)firstAuthWithLogin:(NSString *)login andPassword:(NSString *)password;
+ (NSString *)passEncodedForPassword:(NSString *)password;
+ (NSString *)passEncoded;
+ (NSDictionary *)parametersForAPI;
+ (NSString *)decrypthRNDforRNDEncoded:(NSString *)rndEncoded;
+ (NSData *) createDataWithHexString:(NSString *)inputString;

@end
