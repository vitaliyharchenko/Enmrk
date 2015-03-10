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

+ (NSMutableArray *)loadArray;
+ (NSMutableDictionary *)createNewTransformator;

+ (NSArray *)initOptionsWithProperties:(NSArray *)properties andFields:(NSArray *)fields;
+ (NSDictionary *)initDescriptionWithFields:(NSArray *)fields;

+ (NSString *)searchValueOfPropertyWithId:(NSInteger)properyId isProp:(NSNumber *)isProp forTransformator:(NSMutableDictionary *)transformator forPropertiesArray:(NSArray *)propertiesArray;

+ (NSObject *)parseSelectedValueForProperty:(NSDictionary *)selectedProperty forTransformator:(NSMutableDictionary *)transformator;
+ (NSObject *)parseSelectedValueForField:(NSDictionary *)selectedProperty forTransformator:(NSMutableDictionary *)transformator;
+ (NSString *)parseDescriptionForField:(NSDictionary *)selectedProperty forTransformator:(NSMutableDictionary *)transformator;
+ (NSString *)parseStatusForTransformator:(NSDictionary *)transformator forPlayground:(NSDictionary *)playground forPlaygroundStatuses:(NSArray *)playgroundsStatuses;
+ (NSNumber *)parseStatusIdForTransformator:(NSDictionary *)transformator forPlayground:(NSDictionary *)playground forPlaygroundStatuses:(NSArray *)playgroundsStatuses;
+ (NSInteger)parsePriceForTransformator:(NSDictionary *)transformator forPlayground:(NSDictionary *)selectedPlayground;
+ (NSString *)parseImageUrlForTransformator:(NSDictionary *)transformator forImsType:(NSDictionary *)imsType;

+ (NSMutableDictionary *)editTransformator:(NSMutableDictionary *)transformator setValue:(NSInteger)value forProperty:(NSDictionary *)selectedProperty;
+ (NSMutableDictionary *)editTransformator:(NSMutableDictionary *)transformator setValue:(NSString *)value forField:(NSDictionary *)selectedProperty;
+ (NSMutableDictionary *)editTransformator:(NSMutableDictionary *)transformator setStatus:(NSNumber *)statusId forPlayground:(NSDictionary *)selectedPlayground;
+ (NSMutableDictionary *)editTransformator:(NSMutableDictionary *)transformator setPrice:(NSString *)price forPlayground:(NSDictionary *)selectedPlayground;

@end
