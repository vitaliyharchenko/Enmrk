//
//  ENTransformator.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENTransformator : NSObject

@property (strong,nonatomic) NSNumber *transformator_id;
@property (strong,nonatomic) NSString *mark;
@property (strong,nonatomic) NSString *conection;
@property (strong,nonatomic) NSString *producer;
@property (strong,nonatomic) NSNumber *power;
@property (strong,nonatomic) NSNumber *upVoltage;
@property (strong,nonatomic) NSNumber *downVoltage;
@property (strong,nonatomic) NSNumber *year;
//@property (strong,nonatomic) NSString *description;

+ (NSMutableArray *)initTestArray;
+ (NSMutableDictionary *)initMenuDictionary;

@end
