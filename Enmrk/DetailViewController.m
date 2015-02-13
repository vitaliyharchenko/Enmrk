//
//  DetailViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "DetailViewController.h"
#import "ENTransformator.h"

@interface DetailViewController ()

@property NSDictionary *options;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.options = [ENTransformator initMenuDictionary];
    
    self.navigationItem.title = @"Карточка товара";

    NSString *text = [NSString stringWithFormat:@"%ld %@ %@ %@ %@ %@ %@ %@",
        (long)[_transformator.id integerValue],
        [[_options objectForKey:@"Марка"] objectAtIndex:[_transformator.mark integerValue]],
        [[_options objectForKey:@"Соединение"] objectAtIndex:[_transformator.conection integerValue]],
        [[_options objectForKey:@"Производитель"] objectAtIndex:[_transformator.producer integerValue]],
        [[_options objectForKey:@"Мощность"] objectAtIndex:[_transformator.power integerValue]],
        [[_options objectForKey:@"Верхнее напряжение"] objectAtIndex:[_transformator.upVoltage integerValue]],
        [[_options objectForKey:@"Нижнее напряжение"] objectAtIndex:[_transformator.downVoltage integerValue]],
        [[_options objectForKey:@"Год выпуска"] objectAtIndex:[_transformator.year integerValue]]
    ];
    
    _label.text = text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
