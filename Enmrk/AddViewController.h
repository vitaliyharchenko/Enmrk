//
//  AddViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property NSMutableDictionary *selectedOptions;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic, strong) NSString *about;

- (void)enableDoneButton:(BOOL)enable;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
- (IBAction)unwindFromAbout:(UIStoryboardSegue *)segue;

@end
