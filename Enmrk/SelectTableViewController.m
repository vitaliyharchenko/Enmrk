//
//  SelectTableViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 08.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "SelectTableViewController.h"
#import "AddViewController.h"
#import "AppDelegate.h"

@interface SelectTableViewController ()

@property (nonatomic, strong) NSMutableArray *optionValues;

@end

@implementation SelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.optionValues = [_options objectForKey:_key];
    self.navigationItem.title = _key;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_optionValues count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Option Cell" forIndexPath:indexPath];
    
    NSObject *object = [_optionValues objectAtIndex:[indexPath row]+1];
    NSString *string = [NSString stringWithFormat:@"%@",object];
    
    NSInteger selectedPath = [indexPath row]+1;
    NSInteger selectedOption = [[_selectedOptions objectForKey:_key] integerValue];
    
    if (selectedPath == selectedOption) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    cell.textLabel.text = string;
    
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
    
    if (indexPath) {
        NSInteger selectedOption = [indexPath row]+1;
        [_selectedOptions setObject:[NSNumber numberWithInteger:selectedOption] forKey:_key];
    }
    
    NSArray *keys = [_selectedOptions allKeys];
    NSInteger countNull = 0;
    
    for (NSString *n in keys) {
        if ([[_selectedOptions valueForKey:n] isEqualToNumber:@0]) {
            countNull++;
        }
    }
    
    NSNumber *count = [NSNumber numberWithInteger:countNull];
    
    if ([count isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [segue.destinationViewController enableDoneButton:YES];
    } else {
        [segue.destinationViewController enableDoneButton:NO];
    }
}

@end
