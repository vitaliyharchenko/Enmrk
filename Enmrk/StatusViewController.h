//
//  StatusTableViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 01.03.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusViewController : UITableViewController

@property (strong,nonatomic) NSDictionary *selectedPlayground;
@property (strong,nonatomic) NSMutableArray *playgroundsStatuses;
@property (strong,nonatomic) NSMutableDictionary *transformator;
@property (strong,nonatomic) NSNumber *isNew;
@property (strong,nonatomic) NSArray *properties;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *statusField;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
- (void)reloadData;

@end
