//
//  MainTableViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MainTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *transformators;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
- (IBAction)logoutAction:(id)sender;

@end
