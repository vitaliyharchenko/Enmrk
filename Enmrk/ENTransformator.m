//
//  ENTransformator.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "ENTransformator.h"
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "ENAuth.h"

@implementation ENTransformator

+ (NSMutableArray *)loadArray {
    
    __block NSMutableArray *transformatorsArray = [[NSMutableArray alloc] init];
    
    NSDictionary *parameters = [ENAuth parametersForAPI];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://enmrk.ru/api/transformers/get/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Get Transformers: %@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"OK"]) {
            
            transformatorsArray = [responseObject objectForKey:@"transformers"];
            
            [[ENAuth alloc] reAuthWithResponseObject:responseObject];
            
        } else {
            NSString *error = [responseObject objectForKey:@"error"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
    
    return transformatorsArray;
    
}


+ (NSMutableDictionary *)createNewTransformator {
    
    NSMutableDictionary *transformator = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *playgrounds = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *ims = [[NSMutableDictionary alloc] init];
    [transformator setObject:properties forKey:@"properties"];
    [transformator setObject:fields forKey:@"fields"];
    [transformator setObject:playgrounds forKey:@"playgrounds"];
    [transformator setObject:ims forKey:@"ims"];
    return transformator;    
}

+ (NSArray *)initOptionsWithProperties:(NSArray *)properties andFields:(NSArray *)fields {
    
    NSMutableDictionary *optionsDict = [[NSMutableDictionary alloc] init];
    
    NSInteger propCount = [properties count];
    NSInteger fieldsCount = [fields count];
    int i;
    for (i=0; i<(int)propCount; i++) {
        [optionsDict setObject:[[properties objectAtIndex:i] objectForKey:@"sort"] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    for (i=0; i<(int)fieldsCount; i++) {
        [optionsDict setObject:[[fields objectAtIndex:i] objectForKey:@"sort"] forKey:[NSString stringWithFormat:@"%d",i+(int)propCount]];
    }
    
    NSArray *sortedKeysArray =
    [optionsDict keysSortedByValueUsingSelector:@selector(compare:)];
    
    NSMutableArray *sortedOptions = [[NSMutableArray alloc] init];
    
    for (i=0; i<(int)fieldsCount+(int)propCount; i++) {
        NSInteger optionId = [[sortedKeysArray objectAtIndex:i] integerValue];
        if (optionId<(int)propCount) {
            NSDictionary *obj = [properties objectAtIndex:optionId];
            [sortedOptions addObject:obj];
        } else {
            if (![[[fields objectAtIndex:optionId-propCount] objectForKey:@"name"] isEqualToString:@"description"]) {
                if (![[[fields objectAtIndex:optionId-propCount] objectForKey:@"name"] isEqualToString:@"price"]) {
                    NSDictionary *obj = [fields objectAtIndex:optionId-propCount];
                    [sortedOptions addObject:obj];
                }
            }
        }
    }
    
    return sortedOptions;
}

+ (NSDictionary *)initDescriptionWithFields:(NSArray *)fields {
    NSInteger fieldsCount = [fields count];
    int i;
    for (i=0; i<(int)fieldsCount; i++) {
        NSDictionary *field = [fields objectAtIndex:i];
        NSString *name = [field objectForKey:@"name"];
        if ([name isEqualToString:@"description"]) {
            return field;
        }
    }
    return nil;
}

+ (NSString *)searchValueOfPropertyWithId:(NSInteger)properyId isProp:(NSNumber *)isProp forTransformator:(NSMutableDictionary *)transformator forPropertiesArray:(NSArray *)propertiesArray {
    
    NSMutableDictionary *selectedProp = [[NSMutableDictionary alloc] init]; //search property in array
    int k;
    for (k=0; k<propertiesArray.count; k++) {
        NSMutableDictionary *prop = [propertiesArray objectAtIndex:k];
        NSInteger propId = [[prop objectForKey:@"id"] integerValue];
        BOOL isPropVal = NO;
        if ([prop objectForKey:@"values"]) {
            isPropVal = YES;
        }
        if ([isProp isEqualToNumber:[NSNumber numberWithBool:isPropVal]] && (propId == properyId)) {
            selectedProp = prop;
        }
    }
    
    if ([isProp isEqualToNumber:@1]) {
        NSMutableArray *properties = [transformator objectForKey:@"properties"];
        if (properties) {
            int i;
            for (i=0; i<properties.count; i++) {
                NSDictionary *property = [properties objectAtIndex:i];
                NSInteger currentId = [[property objectForKey:@"id"] integerValue];
                if (currentId == properyId) {
                    NSInteger val = [[property objectForKey:@"val"] integerValue];
                    
                    if (selectedProp) {
                        NSMutableArray *values = [selectedProp objectForKey:@"values"];
                        for (i=0; i<values.count; i++) {
                            NSDictionary *value = [values objectAtIndex:i];
                            NSInteger valueId = [[value objectForKey:@"id"] integerValue];
                            if (valueId == val) {
                                return [NSString stringWithFormat:@"%@", [value objectForKey:@"val"]];
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    if ([isProp isEqualToNumber:@0]) {
        NSMutableArray *fields = [transformator objectForKey:@"fields"];
        if (fields) {
            NSInteger propId = [[selectedProp objectForKey:@"id"] integerValue];
            int i;
            for (i=0; i<fields.count; i++) {
                NSDictionary *field = [fields objectAtIndex:i];
                NSInteger currentId = [[field objectForKey:@"id"] integerValue];
                if (currentId == propId) {
                    return [NSString stringWithFormat:@"%@", [field objectForKey:@"val"]];
                }
            }
        }
    }
    
    return nil;
}

+ (NSObject *)parseSelectedValueForProperty:(NSDictionary *)selectedProperty forTransformator:(NSMutableDictionary *)transformator {

    NSMutableArray *properties = [transformator objectForKey:@"properties"];
    NSInteger propertyId = [[selectedProperty objectForKey:@"id"] integerValue];
    
    int i;
    for (i=0; i<properties.count; i++) {
        NSDictionary *property = [properties objectAtIndex:i];
        NSInteger currentId = [[property objectForKey:@"id"] integerValue];
        if (currentId == propertyId) {
            NSInteger val = [[property objectForKey:@"val"] integerValue];
            
            NSMutableArray *values = [selectedProperty objectForKey:@"values"];
            for (i=0; i<values.count; i++) {
                NSDictionary *value = [values objectAtIndex:i];
                NSInteger valueId = [[value objectForKey:@"id"] integerValue];
                NSObject *valueVal = [value objectForKey:@"val"];
                if (valueId == val) {
                    return valueVal;
                }
            }
        }
    }
    
    return nil;
}

+ (NSString *)parseDescriptionForField:(NSDictionary *)selectedProperty forTransformator:(NSMutableDictionary *)transformator {
    NSMutableArray *fields = [transformator objectForKey:@"fields"];
    NSInteger fieldId = [[selectedProperty objectForKey:@"id"] integerValue];
    
    int i;
    for (i=0; i<fields.count; i++) {
        NSDictionary *field = [fields objectAtIndex:i];
        NSInteger currentId = [[field objectForKey:@"id"] integerValue];
        if (currentId == fieldId) {
            NSString *val = [field objectForKey:@"val"];
            return val;
        }
    }
    
    return nil;
}

+ (NSString *)parseStatusForTransformator:(NSDictionary *)transformator forPlayground:(NSDictionary *)playground forPlaygroundStatuses:(NSArray *)playgroundsStatuses {
    
    NSNumber *selectedPlaygroundId = [playground objectForKey:@"id"];
    
    NSInteger playgroundValueId;
    
    NSArray *transformatorPlaygrounds = [transformator objectForKey:@"playgrounds"];
    if (transformatorPlaygrounds) {
        int l;
        for (l=0; l<transformatorPlaygrounds.count; l++) {
            NSDictionary *transformatorPlayground = [transformatorPlaygrounds objectAtIndex:l];
            NSString *transformatorPlaygroundId = [transformatorPlayground objectForKey:@"playground"];
            NSInteger transfPlaygroundId = [transformatorPlaygroundId integerValue];
            
            NSString *transformatorPlaygroundStatus = [transformatorPlayground objectForKey:@"status"];
            NSInteger transfPlaygroundStatus = [transformatorPlaygroundStatus integerValue];
        
            if (transfPlaygroundId == [selectedPlaygroundId integerValue]) {
                playgroundValueId = transfPlaygroundStatus;
            }
        }
    }
    
    if (playgroundValueId) {
        int i;
        for (i=0; i<playgroundsStatuses.count; i++) {
            NSDictionary *playgroundStatus = [playgroundsStatuses objectAtIndex:i];
            NSNumber *playgroundStatusId = [playgroundStatus objectForKey:@"id"];
            if ([playgroundStatusId integerValue] == playgroundValueId) {
                return [playgroundStatus objectForKey:@"status"];
            }
        }
    }
    
    return @"Не выкладывалось";
}

+ (NSString *)parsePriceForTransformator:(NSDictionary *)transformator forPlayground:(NSDictionary *)playground {
    
    NSNumber *selectedPlaygroundId = [playground objectForKey:@"id"];
    
    NSArray *transformatorPlaygrounds = [transformator objectForKey:@"playgrounds"];
    if (transformatorPlaygrounds) {
        int l;
        for (l=0; l<transformatorPlaygrounds.count; l++) {
            NSDictionary *transformatorPlayground = [transformatorPlaygrounds objectAtIndex:l];
            NSString *transformatorPlaygroundId = [transformatorPlayground objectForKey:@"playground"];
            NSInteger transfPlaygroundId = [transformatorPlaygroundId integerValue];
            
            NSString *transformatorPrice = [transformatorPlayground objectForKey:@"price"];
            NSInteger transfPlaygroundPrice = [transformatorPrice integerValue];
            
            if (transfPlaygroundId == [selectedPlaygroundId integerValue]) {
                if (!(transfPlaygroundPrice == 0)) {
                    return transformatorPrice;
                }
            }
        }
    }
    
    return nil;
}

+ (NSNumber *)parseStatusIdForTransformator:(NSDictionary *)transformator forPlayground:(NSDictionary *)playground forPlaygroundStatuses:(NSArray *)playgroundsStatuses {
    
    NSNumber *selectedPlaygroundId = [playground objectForKey:@"id"];
    
    NSArray *transformatorPlaygrounds = [transformator objectForKey:@"playgrounds"];
    if (transformatorPlaygrounds) {
        int l;
        for (l=0; l<transformatorPlaygrounds.count; l++) {
            NSDictionary *transformatorPlayground = [transformatorPlaygrounds objectAtIndex:l];
            NSNumber *transformatorPlaygroundId = [transformatorPlayground objectForKey:@"playground"];
            NSNumber *transformatorPlaygroundStatus = [transformatorPlayground objectForKey:@"status"];
            if (transformatorPlaygroundId == selectedPlaygroundId) {
                return transformatorPlaygroundStatus;
            }
        }
    }
    
    return nil;
}


+ (NSObject *)parseSelectedValueForField:(NSMutableDictionary *)selectedProperty forTransformator:(NSMutableDictionary *)transformator {
    
    NSMutableArray *fields = [transformator objectForKey:@"fields"];
    NSInteger fieldId = [[selectedProperty objectForKey:@"id"] integerValue];
    
    int i;
    for (i=0; i<fields.count; i++) {
        NSDictionary *field = [fields objectAtIndex:i];
        NSInteger currentId = [[field objectForKey:@"id"] integerValue];
        if (currentId == fieldId) {
            NSObject *val = [field objectForKey:@"val"];
            return val;
        }
    }
    
    return nil;
}

+ (NSString *)parseImageUrlForTransformator:(NSDictionary *)transformator forImsType:(NSDictionary *)imsType{
    return nil;
}

+ (NSMutableDictionary *)editTransformator:(NSMutableDictionary *)transformator setValue:(NSInteger)value forProperty:(NSMutableDictionary *)selectedProperty {
    
    NSArray *propertiesPre = [transformator objectForKey:@"properties"];
    NSMutableArray *properties = [[NSMutableArray alloc] init];
    if (propertiesPre.count > 0) {
        properties = [NSMutableArray arrayWithArray:propertiesPre];
    }
    NSInteger propertyId = [[selectedProperty objectForKey:@"id"] integerValue];
    
    int i;
    int k = 0;
    if (propertiesPre.count > 0) {
        for (i=0; i<properties.count; i++) {
            NSDictionary *propertyPre = [properties objectAtIndex:i];
            NSMutableDictionary *property = [NSMutableDictionary dictionaryWithDictionary:propertyPre];
            NSInteger currentId = [[property objectForKey:@"id"] integerValue];
            if (currentId == propertyId) {
                NSNumber *valNumb = [NSNumber numberWithInt:(int)value];
                [property setValue:valNumb forKey:@"val"];
                properties[i] = property;
                k++;
            }
        }
    }
    
    if (k == 0) {
        NSNumber *valNumb = [NSNumber numberWithInt:(int)value];
        NSNumber *idNumb = [NSNumber numberWithInt:(int)propertyId];
        NSMutableDictionary *newProperty = [[NSMutableDictionary alloc] init];
        [newProperty setObject:valNumb forKey:@"val"];
        [newProperty setObject:idNumb forKey:@"id"];
        [properties addObject:newProperty];
    }
    
    NSDictionary *newTransformatorPre = transformator;
    NSMutableDictionary *newTransformator = [NSMutableDictionary dictionaryWithDictionary:newTransformatorPre];
    [newTransformator setObject:properties forKey:@"properties"];
    return newTransformator;
}

+ (NSMutableDictionary *)editTransformator:(NSMutableDictionary *)transformator setValue:(NSString *)value forField:(NSDictionary *)selectedProperty {
    
    NSArray *fieldsPre = [transformator objectForKey:@"fields"];
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    if (fieldsPre.count > 0) {
        fields = [NSMutableArray arrayWithArray:fieldsPre];
    }
    NSInteger fieldId = [[selectedProperty objectForKey:@"id"] integerValue];
    
    int i;
    int k = 0;
    if (fieldsPre.count > 0) {
        for (i=0; i<fields.count; i++) {
            NSDictionary *fieldPre = [fields objectAtIndex:i];
            NSMutableDictionary *field = [NSMutableDictionary dictionaryWithDictionary:fieldPre];
            NSInteger currentId = [[field objectForKey:@"id"] integerValue];
            if (currentId == fieldId) {
                [field setValue:value forKey:@"val"];
                fields[i] = field;
                k++;
            }
        }
    }
    
    if (k == 0) {
        NSNumber *idNumb = [NSNumber numberWithInt:(int)fieldId];
        NSMutableDictionary *newField = [[NSMutableDictionary alloc] init];
        [newField setObject:value forKey:@"val"];
        [newField setObject:idNumb forKey:@"id"];
        [fields addObject:newField];
    }
    
    NSDictionary *newTransformatorPre = transformator;
    NSMutableDictionary *newTransformator = [NSMutableDictionary dictionaryWithDictionary:newTransformatorPre];
    [newTransformator setObject:fields forKey:@"fields"];
    return newTransformator;
}

+ (NSMutableDictionary *)editTransformator:(NSMutableDictionary *)transformator setStatus:(NSNumber *)statusId forPlayground:(NSDictionary *)selectedPlayground {
    
    NSArray *playgroundsPre = [transformator objectForKey:@"playgrounds"];
    NSMutableArray *playgrounds = [[NSMutableArray alloc] init];
    if (playgroundsPre.count > 0) {
        playgrounds = [NSMutableArray arrayWithArray:playgroundsPre];
    }
    NSInteger playgroundId = [[selectedPlayground objectForKey:@"id"] integerValue];
    
    int i;
    int k = 0;
    if (playgroundsPre.count > 0) {
        for (i=0; i<playgrounds.count; i++) {
            NSDictionary *playgroundPre = [playgrounds objectAtIndex:i];
            NSMutableDictionary *playground = [NSMutableDictionary dictionaryWithDictionary:playgroundPre];
            NSInteger currentId = [[playground objectForKey:@"playground"] integerValue];
            if (currentId == playgroundId) {
                [playground setValue:[NSString stringWithFormat:@"%ld", (long)playgroundId] forKey:@"playground"];
                [playground setValue:[NSString stringWithFormat:@"%@", statusId] forKey:@"status"];
                playgrounds[i] = playground;
                k++;
            }
        }
    }
    
    if (k == 0) {
        NSNumber *idNumb = [NSNumber numberWithInt:(int)playgroundId];
        NSMutableDictionary *newField = [[NSMutableDictionary alloc] init];
        [newField setObject:statusId forKey:@"status"];
        [newField setObject:idNumb forKey:@"playground"];
        [playgrounds addObject:newField];
    }
    
    NSDictionary *newTransformatorPre = transformator;
    NSMutableDictionary *newTransformator = [NSMutableDictionary dictionaryWithDictionary:newTransformatorPre];
    [newTransformator setObject:playgrounds forKey:@"playgrounds"];
    return newTransformator;
}

+ (NSMutableDictionary *)editTransformator:(NSMutableDictionary *)transformator setPrice:(NSString *)price forPlayground:(NSDictionary *)selectedPlayground {
    
    NSArray *playgroundsPre = [transformator objectForKey:@"playgrounds"];
    NSMutableArray *playgrounds = [[NSMutableArray alloc] init];
    if (playgroundsPre.count > 0) {
        playgrounds = [NSMutableArray arrayWithArray:playgroundsPre];
    }
    NSInteger playgroundId = [[selectedPlayground objectForKey:@"id"] integerValue];
    
    int i;
    int k = 0;
    if (playgroundsPre.count > 0) {
        for (i=0; i<playgrounds.count; i++) {
            NSDictionary *playgroundPre = [playgrounds objectAtIndex:i];
            NSMutableDictionary *playground = [NSMutableDictionary dictionaryWithDictionary:playgroundPre];
            NSInteger currentId = [[playground objectForKey:@"playground"] integerValue];
            if (currentId == playgroundId) {
                [playground setValue:[NSString stringWithFormat:@"%ld", (long)playgroundId] forKey:@"playground"];
                [playground setValue:[NSString stringWithFormat:@"%@", price] forKey:@"price"];
                playgrounds[i] = playground;
                k++;
            }
        }
    }
    
    if (k == 0) {
        NSNumber *idNumb = [NSNumber numberWithInt:(int)playgroundId];
        NSMutableDictionary *newField = [[NSMutableDictionary alloc] init];
        [newField setObject:price forKey:@"price"];
        [newField setObject:idNumb forKey:@"playground"];
        [playgrounds addObject:newField];
    }
    
    NSDictionary *newTransformatorPre = transformator;
    NSMutableDictionary *newTransformator = [NSMutableDictionary dictionaryWithDictionary:newTransformatorPre];
    [newTransformator setObject:playgrounds forKey:@"playgrounds"];
    return newTransformator;
}

@end
