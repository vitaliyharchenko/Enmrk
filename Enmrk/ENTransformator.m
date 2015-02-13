//
//  ENTransformator.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "ENTransformator.h"

@implementation ENTransformator

+ (NSMutableArray *)initTestArray {
    
    NSMutableArray *transformatorsArray = [[NSMutableArray alloc] init];
    
    NSInteger i;
    for (i=0; i<3; i++) {
        ENTransformator *transformator = [[ENTransformator alloc] init];
        [transformator setId:[NSNumber numberWithInteger:i+1]];
        [transformator setMark:[NSNumber numberWithInteger:i+1]];
        [transformator setConection: [NSNumber numberWithInteger:i+1]];
        [transformator setProducer: [NSNumber numberWithInteger:i+1]];
        [transformator setPower: [NSNumber numberWithInteger:i+1]];
        [transformator setUpVoltage: [NSNumber numberWithInteger:i+1]];
        [transformator setDownVoltage: [NSNumber numberWithInteger:i+1]];
        [transformator setYear: [NSNumber numberWithInteger:i+1]];
        [transformator setSync: [NSNumber numberWithBool:YES]];
        [transformator setAbout:@"About"];
        [transformatorsArray addObject:transformator];
    }
    return transformatorsArray;
}

+ (NSDictionary *)initMenuDictionary {
    
    NSArray *markArray = @[ @"Не выбрано", @"ТДНС", @"ТДН", @"ТГМ", @"ТДТН", @"ТЗРЛ", @"ТЛС", @"ТМ", @"ТМБ", @"ТМБГ", @"ТМГ", @"ТГМ", @"ТМГ11", @"ТМГ12", @"ТМГМШ", @"ТМГСУ", @"ТМГФ", @"ТМЖ", @"ТМЗ", @"ТМН", @"ТМФ", @"ТМЭ", @"ТМЭГ", @"ТС", @"ТСГЛ", @"ТСЗ", @"ТСЗГЛ", @"ТСЗГЛФ", @"ТСЗИ", @"ТСЗК", @"ТСЗМ", @"ТСЗП", @"ТСЗУ", @"ТСЛ", @"ТСН" ];
    
    NSArray *connectionArray = @[ @"Не выбрано", @"Y/Yн", @"Д/Yн", @"Y/Zн", @"Y/Д", @"ДД", @"Д/Yн - 11" ];
    
    NSArray *producerArray = @[ @"Не выбрано", @"Барнаул", @"Кентау", @"Биробиджан", @"Минск", @"Запорожье", @"Чирчик", @"Хмельницкий", @"Самара" ];
    
    NSArray *powerArray = @[ @"Не выбрано", @16, @25, @40, @63, @100, @160, @250, @400, @630, @1000, @1600, @2500, @4000, @6300 ];
    
    NSArray *upVoltageArray = @[ @"Не выбрано", @330, @220, @110, @35, @110, @35, @20, @16, @10, @6, @0.4 ];
    
    NSArray *downVoltageArray = @[ @"Не выбрано", @0.4, @6, @10, @16, @20, @35, @110 ];
    
    NSArray *yearArray = @[ @"Не выбрано", @2012, @2013, @2014, @2015 ];
    
    NSDictionary *menuDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: markArray, @"Марка", connectionArray, @"Соединение", producerArray, @"Производитель", powerArray, @"Мощность", upVoltageArray, @"Верхнее напряжение", downVoltageArray, @"Нижнее напряжение", yearArray, @"Год выпуска", nil];
    
    return menuDictionary;
}

+ (ENTransformator *)initTransformatorWithOptions:(NSMutableDictionary *)selectedOptions {
    
    ENTransformator *transformator = [[ENTransformator alloc] init];
    [transformator setMark:[selectedOptions objectForKey:@"Марка"]];
    [transformator setProducer:[selectedOptions objectForKey:@"Производитель"]];
    [transformator setConection:[selectedOptions objectForKey:@"Соединение"]];
    [transformator setYear:[selectedOptions objectForKey:@"Год выпуска"]];
    [transformator setPower:[selectedOptions objectForKey:@"Мощность"]];
    [transformator setUpVoltage:[selectedOptions objectForKey:@"Верхнее напряжение"]];
    [transformator setDownVoltage:[selectedOptions objectForKey:@"Нижнее напряжение"]];
    [transformator setSync:[NSNumber numberWithBool:NO]];
    
    return transformator;    
}

+ (NSArray *)initMenuArray {
    
    NSArray *menuArray = [[NSArray alloc] initWithObjects: @"Марка", @"Соединение", @"Производитель", @"Мощность", @"Верхнее напряжение", @"Нижнее напряжение", @"Год выпуска", nil];

    return menuArray;
}

@end
