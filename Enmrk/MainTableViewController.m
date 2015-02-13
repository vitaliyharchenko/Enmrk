//
//  MainTableViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "MainTableViewController.h"
#import "ENTransformator.h"
#import "DetailViewController.h"
#import "AddViewController.h"

@interface MainTableViewController ()

@property NSDictionary *options;

@end


@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Трансформаторы";
    
    self.transformators = [ENTransformator initTestArray];
    self.options = [ENTransformator initMenuDictionary];
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    AddViewController *source = [segue sourceViewController];
    [self.transformators insertObject:[ENTransformator initTransformatorWithOptions:source.selectedOptions] atIndex:0];
    [self.tableView reloadData];
}

- (IBAction)logoutAction:(id)sender {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app initWindowWithLogin];
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
    if (_transformators) {
        return ([_transformators count]+1);
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Add Cell" forIndexPath:indexPath];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Transformator Cell" forIndexPath:indexPath];
        
        if (_transformators) {
            ENTransformator *transformator = [_transformators objectAtIndex:indexPath.row-1];
            NSString *text = [NSString stringWithFormat:@"%ld %@ %@ %@ %@ %@ %@ %@",
                (long)[transformator.id integerValue],
                [[_options objectForKey:@"Марка"] objectAtIndex:[transformator.mark integerValue]],
                [[_options objectForKey:@"Соединение"] objectAtIndex:[transformator.conection integerValue]],
                [[_options objectForKey:@"Производитель"] objectAtIndex:[transformator.producer integerValue]],
                [[_options objectForKey:@"Мощность"] objectAtIndex:[transformator.power integerValue]],
                [[_options objectForKey:@"Верхнее напряжение"] objectAtIndex:[transformator.upVoltage integerValue]],
                [[_options objectForKey:@"Нижнее напряжение"] objectAtIndex:[transformator.downVoltage integerValue]],
                [[_options objectForKey:@"Год выпуска"] objectAtIndex:[transformator.year integerValue]]
            ];
            
            if ([transformator.sync isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                cell.backgroundColor = [UIColor colorWithRed:81/255.0f green:218/255.0f blue:132/255.0f alpha:0.5f];
            }
            
            cell.textLabel.text = text;
        }
        
        return cell;
    }
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
    if ([[segue identifier] isEqualToString:@"detailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath) {
            ENTransformator *transformator = [_transformators objectAtIndex:indexPath.row-1];
            [segue.destinationViewController setTransformator:transformator];
        }
    }
}
@end
