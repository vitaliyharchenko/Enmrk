//
//  TapeViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 26.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "TapeViewController.h"
#import "ENTransformator.h"
#import "ENAuth.h"
#import "AFNetworking.h"
#import "Reachability.h"

@interface TapeViewController ()

@property (nonatomic, strong) NSObject *selectedValue;

@end


@implementation TapeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    
    if (_selectedProperty) {
        _selectedValue = [ENTransformator parseSelectedValueForField:_selectedProperty forTransformator:_transformator];
        
        NSString *propertyName = [_selectedProperty objectForKey:@"name"];
        NSString *propertyType = [_selectedProperty objectForKey:@"type"];
        
        if ([propertyType isEqual:@"int"]) {
            [self.textView setKeyboardType:UIKeyboardTypeNumberPad];
            [self.textView sizeToFit];
            self.label.text = @"Введите значение";
        } else {
            [self.textView sizeToFit];
        }
        
        self.navigationItem.title = propertyName;
        self.navigationItem.leftBarButtonItem = nil;
        
        if (_selectedValue) {
            self.textView.text = [NSString stringWithFormat:@"%@",_selectedValue];
        }
    } else if (_descriptionField) {
        _selectedValue = [ENTransformator parseDescriptionForField:_descriptionField forTransformator:_transformator];
        NSString *propertyName = [_descriptionField objectForKey:@"name"];
        self.navigationItem.title = propertyName;
        self.navigationItem.leftBarButtonItem = nil;
        self.label.text = @"Наберите описание или продиктуйте";
        if (_selectedValue) {
            self.textView.text = [NSString stringWithFormat:@"%@",_selectedValue];
        }
        [self.textView sizeToFit];
        [self.textView layoutIfNeeded];
    } else if (_selectedPlayground) {
        NSInteger price = [ENTransformator parsePriceForTransformator:_transformator forPlayground:_selectedPlayground];
        
        
        [self.textView setKeyboardType:UIKeyboardTypeNumberPad];
        [self.textView sizeToFit];
        self.label.text = @"Введите значение";
        
        self.navigationItem.title = @"Цена";
        self.navigationItem.leftBarButtonItem = nil;
        
        if (!(price == 0)) {
            self.textView.text = [NSString stringWithFormat:@"%ld",(long)price];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString *transf = [NSString stringWithFormat:@"%@",self.textView.text];
    
    NSInteger selectedFieldId = 0;
    
    if (_selectedProperty) {
        selectedFieldId = [[_selectedProperty objectForKey:@"id"] integerValue];
        NSMutableDictionary *newTransformator = [ENTransformator editTransformator:_transformator setValue:transf forField:_selectedProperty];
        _transformator = newTransformator;
    }
    if (_descriptionField) {
        selectedFieldId = [[_descriptionField objectForKey:@"id"] integerValue];
        NSMutableDictionary *newTransformator = [ENTransformator editTransformator:_transformator setValue:transf forField:_descriptionField];
        _transformator = newTransformator;
    }
    
    if (_selectedPlayground) {
        selectedFieldId = [[_selectedPlayground objectForKey:@"id"] integerValue];
        NSMutableDictionary *newTransformator = [ENTransformator editTransformator:_transformator setPrice:transf forPlayground:_selectedPlayground];
        _transformator = newTransformator;
    }
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus != NotReachable)
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[ENAuth parametersForAPI]];
        [parameters setObject:@"editTransformer" forKey:@"act"];
        
        if (!_selectedPlayground) {
            NSString *text = [NSString stringWithFormat:@"fields[%ld]",(long)selectedFieldId];
            [parameters setObject:transf forKey:text];
        } else {
            NSString *text = [NSString stringWithFormat:@"playgrounds[%ld][price]",(long)selectedFieldId];
            [parameters setObject:transf forKey:text];
            NSString *text1 = [NSString stringWithFormat:@"playgrounds[%ld][status]",(long)selectedFieldId];
            [parameters setObject:@"1" forKey:text1];
        }
        
        NSNumber *transformatorId = [_transformator objectForKey:@"id"];
        if (!(transformatorId == 0)) {
            [parameters setObject:[NSString stringWithFormat:@"%@", transformatorId] forKey:@"transf"];
        }
        
        NSLog(@"Edit Transformers params: %@",parameters);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://enmrk.ru/api/transformers/add/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // NSLog(@"Edit Transformers: %@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status isEqualToString:@"OK"]) {
                
                if (!transformatorId) {
                    NSNumber *insertedId = [responseObject objectForKey:@"inserted_id"];
                    [_transformator setValue:insertedId forKey:@"id"];
                }
                
                [segue.destinationViewController setTransformator:_transformator];
                [segue.destinationViewController setIsNew:_isNew];
                [segue.destinationViewController reloadData];
                
                [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                
            } else {
                
                [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                NSString *error = [responseObject objectForKey:@"error"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
    } else {
        [segue.destinationViewController setTransformator:_transformator];
        [segue.destinationViewController setIsNew:_isNew];
    }

}

@end
