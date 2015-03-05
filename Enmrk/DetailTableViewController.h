//
//  DetailTableViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 24.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableDictionary *transformator;
@property (nonatomic) NSInteger transformatorRow;
@property (strong,nonatomic) NSArray *properties;
@property (strong,nonatomic) NSArray *imsTypes;
@property (strong,nonatomic) NSMutableArray *playgrounds;
@property (strong,nonatomic) NSMutableArray *playgroundsStatuses;
@property (strong,nonatomic) NSNumber *isNew;
@property (strong,nonatomic) NSDictionary *descriptionField;

- (void)setTransformator:(NSMutableDictionary *)transformator;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
