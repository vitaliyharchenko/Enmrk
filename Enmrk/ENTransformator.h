//
//  ENTransformator.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENTransformator : NSObject

@property (strong,nonatomic) NSNumber *id;
@property (strong,nonatomic) NSNumber *mark;
@property (strong,nonatomic) NSNumber *conection;
@property (strong,nonatomic) NSNumber *producer;
@property (strong,nonatomic) NSNumber *power;
@property (strong,nonatomic) NSNumber *upVoltage;
@property (strong,nonatomic) NSNumber *downVoltage;
@property (strong,nonatomic) NSNumber *year;
@property (strong,nonatomic) NSNumber *sync;
@property (strong,nonatomic) NSString *about;

+ (NSMutableArray *)initTestArray;
+ (NSDictionary *)initMenuDictionary;
+ (NSArray *)initMenuArray;
+ (ENTransformator *)initTransformatorWithOptions:(NSMutableDictionary *)selectedOptions;

@end
