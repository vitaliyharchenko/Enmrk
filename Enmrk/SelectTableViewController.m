//
//  SelectTableViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 08.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "SelectTableViewController.h"
#import "AddViewController.h"

@interface SelectTableViewController ()

@property (nonatomic, strong) NSMutableArray *optionValues;

@end

@implementation SelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.optionValues = [_options objectForKey:_key];
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHeader:(NSString *)text{
    self.navigationItem.title = text;
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
    NSInteger selectedOption = [[_selectedOptions objectAtIndex:[_keyRow integerValue]] integerValue];
    
    if (selectedPath == selectedOption) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    cell.textLabel.text = string;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath) {
        NSInteger selectedOption = [indexPath row]+1;
        [_selectedOptions replaceObjectAtIndex:[_keyRow integerValue] withObject:[NSNumber numberWithInteger:selectedOption]];
    }
}


@end
