//
//  AddViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic) NSMutableDictionary *transformator;
@property (strong,nonatomic) NSArray *properties;
@property (strong,nonatomic) NSNumber *isNew;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
- (IBAction)unwindFromAbout:(UIStoryboardSegue *)segue;

@end
