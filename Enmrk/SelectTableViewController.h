//
//  SelectTableViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 08.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddViewController.h"

@interface SelectTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *selectedOptions;
@property (nonatomic, strong) NSMutableDictionary *options;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSNumber *keyRow;

@property (nonatomic, weak) AddViewController *addViewController;

- (void)setHeader:(NSString *)text;

@end
