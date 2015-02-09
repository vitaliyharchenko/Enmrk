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
    for (i=0; i<20; i++) {
        ENTransformator *transformator = [[ENTransformator alloc] init];
        [transformator setMark:@"Label"];
        [transformator setTransformator_id:[NSNumber numberWithInteger:i+1]];
        [transformatorsArray addObject:transformator];
    }
    return transformatorsArray;
}

+ (NSMutableDictionary *)initMenuDictionary {
    NSMutableDictionary *menuDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *markArray = @[ @"Не выбрано", @"ТДНС", @"ТДН", @"ТГМ", @"ТДТН", @"ТЗРЛ", @"ТЛС", @"ТМ", @"ТМБ", @"ТМБГ", @"ТМГ", @"ТГМ", @"ТМГ11", @"ТМГ12", @"ТМГМШ", @"ТМГСУ", @"ТМГФ", @"ТМЖ", @"ТМЗ", @"ТМН", @"ТМФ", @"ТМЭ", @"ТМЭГ", @"ТС", @"ТСГЛ", @"ТСЗ", @"ТСЗГЛ", @"ТСЗГЛФ", @"ТСЗИ", @"ТСЗК", @"ТСЗМ", @"ТСЗП", @"ТСЗУ", @"ТСЛ", @"ТСН" ];
    [menuDictionary setValue:markArray forKey:@"Марка"];
    
    NSArray *connectionArray = @[ @"Не выбрано", @"Y/Yн", @"Д/Yн", @"Y/Zн", @"Y/Д", @"ДД", @"Д/Yн - 11" ];
    [menuDictionary setValue:connectionArray forKey:@"Соединение"];
    
    NSArray *producerArray = @[ @"Не выбрано", @"Барнаул", @"Кентау", @"Биробиджан", @"Минск", @"Запорожье", @"Чирчик", @"Хмельницкий", @"Самара" ];
    [menuDictionary setValue:producerArray forKey:@"Производитель"];
    
    NSArray *powerArray = @[ @"Не выбрано", @16, @25, @40, @63, @100, @160, @250, @400, @630, @1000, @1600, @2500, @4000, @6300 ];
    [menuDictionary setValue:powerArray forKey:@"Мощность"];
    
    NSArray *upVoltageArray = @[ @"Не выбрано", @1, @2, @3 ];
    [menuDictionary setValue:upVoltageArray forKey:@"Верхнее напряжение"];
    
    NSArray *downVoltageArray = @[ @"Не выбрано", @1, @2, @3 ];
    [menuDictionary setValue:downVoltageArray forKey:@"Нижнее напряжение"];
    
    NSArray *yearArray = @[ @"Не выбрано", @2012, @2013, @2014, @2015 ];
    [menuDictionary setValue:yearArray forKey:@"Год выпуска"];
    
    return menuDictionary;
}

@end
