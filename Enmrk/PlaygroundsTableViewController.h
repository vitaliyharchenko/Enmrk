//
//  PlaygroundsTableViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 01.03.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaygroundsTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *playgrounds;
@property (strong,nonatomic) NSMutableArray *playgroundsStatuses;
@property (strong,nonatomic) NSMutableDictionary *transformator;
@property (strong,nonatomic) NSNumber *isNew;
@property (strong,nonatomic) NSArray *properties;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
