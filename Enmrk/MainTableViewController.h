//
//  MainTableViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MainTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *transformators;
@property (strong,nonatomic) NSArray *imsTypes;
@property (strong,nonatomic) NSDictionary *descriptionField;
@property (strong,nonatomic) NSArray *properties;
@property (strong,nonatomic) NSMutableArray *playgrounds;
@property (strong,nonatomic) NSMutableArray *playgroundsStatuses;


- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
- (IBAction)syncAction:(id)sender;

- (void)updateTransformator:(NSMutableDictionary *)transformator atRow:(NSInteger)transformatorRow;
- (void)addTransformator:(NSMutableDictionary *)transformator;

@end
