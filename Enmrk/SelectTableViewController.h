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

@property (nonatomic, strong) NSMutableDictionary *selectedOptions;
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, strong) NSString *key;

@property (nonatomic, weak) AddViewController *addViewController;

@end
