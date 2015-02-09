//
//  AddViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "AddViewController.h"
#import "ENTransformator.h"
#import "SelectTableViewController.h"

@interface AddViewController ()

@property NSMutableArray *selectedOptions;
@property NSMutableDictionary *options;
@property NSArray *optionsTitles;

@end

@implementation AddViewController

- (void)loadInitialData {
    self.options = [ENTransformator initMenuDictionary];
    self.optionsTitles = [_options allKeys];
    NSInteger count = [_optionsTitles count];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSNumber *nill = @1;
    NSInteger i;
    for (i=0; i<count; i++) {
        [array addObject:nill];
    }
    _selectedOptions = array;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    SelectTableViewController *source = [segue sourceViewController];
    self.selectedOptions = source.selectedOptions;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    
    self.navigationItem.title = @"Добавить трансформатор";
    
    [self loadInitialData];
    
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.optionsTitles count]+3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = [self.optionsTitles count];
    
    if ([indexPath row] == count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Description Cell" forIndexPath:indexPath];
        return cell;
    }
    
    if ([indexPath row] == count+1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo Cell" forIndexPath:indexPath];
        return cell;
    }
    
    if ([indexPath row] == count+2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Button Cell" forIndexPath:indexPath];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *key = [_optionsTitles objectAtIndex:[indexPath row]];
    NSArray *options = [_options objectForKey:key];
    NSInteger row = [indexPath row];
    
    cell.textLabel.text = key;
    
    NSNumber *selected = [_selectedOptions objectAtIndex:row];
    NSObject *option = [options objectAtIndex:[selected integerValue]];
    if ([key  isEqual: @"Мощность"]) {
        NSString *text = [NSString stringWithFormat:@"%@ кВт",option];
        cell.detailTextLabel.text = text;
    } else {
        NSString *text = [NSString stringWithFormat:@"%@",option];
        cell.detailTextLabel.text = text;
    }

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        NSString *key = [_optionsTitles objectAtIndex:[indexPath row]];
        [segue.destinationViewController setSelectedOptions:_selectedOptions];
        [segue.destinationViewController setKey:key];
        [segue.destinationViewController setKeyRow:[NSNumber numberWithInteger:[indexPath row]]];
        [segue.destinationViewController setOptions:_options];
        [segue.destinationViewController setHeader:key];
    }
}


@end
