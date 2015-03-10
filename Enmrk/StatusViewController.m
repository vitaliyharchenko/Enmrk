//
//  StatusTableViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 01.03.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "StatusViewController.h"
#import "ENTransformator.h"
#import "Reachability.h"
#import "ENAuth.h"
#import "AFNetworking.h"
#import "PlaygroundsTableViewController.h"
#import "TapeViewController.h"

@interface StatusViewController ()

@property (strong,nonatomic) NSMutableArray *commands;
@property (strong,nonatomic) NSMutableDictionary *priceProperty;

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [_selectedPlayground objectForKey:@"name"];
    
    NSMutableArray *commandsArray = [[NSMutableArray alloc] init];
    
    int i;
    for (i=0; i<_playgroundsStatuses.count; i++) {
        NSDictionary *playgroundStatus = [_playgroundsStatuses objectAtIndex:i];
        NSNumber *playgroungStatusId = [playgroundStatus objectForKey:@"id"];
        NSString *playgroungStatusCommand = [playgroundStatus objectForKey:@"command"];
        if (![playgroungStatusCommand isEqualToString:@""]) {
            NSMutableDictionary *command = [[NSMutableDictionary alloc] init];
            [command setObject:playgroungStatusId forKey:@"id"];
            [command setObject:playgroungStatusCommand forKey:@"command"];
            [commandsArray addObject:command];
        }
    }
    
    _commands = commandsArray;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)reloadData{
    [self.tableView reloadData];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_commands count]+3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Status" forIndexPath:indexPath];
        NSString *text = [ENTransformator parseStatusForTransformator:_transformator forPlayground:_selectedPlayground forPlaygroundStatuses:_playgroundsStatuses];
        cell.textLabel.text = [NSString stringWithFormat:@"Статус: %@", text];
        return cell;
    }
    
    if ([indexPath row] == [_commands count]+1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Empty" forIndexPath:indexPath];
        
        return cell;
    }
    
    if ([indexPath row] == [_commands count]+2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Price" forIndexPath:indexPath];
        
        cell.textLabel.text = @"Цена";
        NSString *price = [NSString stringWithFormat:@"%ld", (long)[ENTransformator parsePriceForTransformator:_transformator forPlayground:_selectedPlayground]];
        if (!([price isEqualToString:@"0"])) {
            cell.detailTextLabel.text = price;
        }
        
        return cell;
    }

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Command" forIndexPath:indexPath];
    
    cell.textLabel.text = [[_commands objectAtIndex:[indexPath row]-1] objectForKey:@"command"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        return 80;
    }
    return 44;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tapeSegue"]) {
        [segue.destinationViewController setTransformator:_transformator];
        [segue.destinationViewController setIsNew:_isNew];
        [segue.destinationViewController setSelectedPlayground:_selectedPlayground];
    } else {
        NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
        
        NSDictionary *command = [_commands objectAtIndex:[indexPath row]-1];
        NSNumber *commandId = [command objectForKey:@"id"];
        
        NSNumber *playgroundId = [_selectedPlayground objectForKey:@"id"];
        
        NSMutableDictionary *newTransformator = [ENTransformator editTransformator:_transformator setStatus:commandId forPlayground:_selectedPlayground];
        _transformator = newTransformator;
        
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if (networkStatus != NotReachable)
        {
            [segue.destinationViewController setTransformator:_transformator];
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[ENAuth parametersForAPI]];
            [parameters setObject:@"editTransformer" forKey:@"act"];
            
            NSString *text = [NSString stringWithFormat:@"playgrounds[%@][status]",playgroundId];
            NSString *transf = [NSString stringWithFormat:@"%@",[_transformator objectForKey:@"id"]];
            [parameters setObject:[NSString stringWithFormat:@"%@",commandId] forKey:text];
            
            NSNumber *transformatorId = [_transformator objectForKey:@"id"];
            if (!(transformatorId == 0)) {
                [parameters setObject:transf forKey:@"transf"];
            }
            
            NSLog(@"Edit Transformers params: %@",parameters);
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:@"http://enmrk.ru/api/transformers/add/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                // NSLog(@"Edit Transformers: %@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status isEqualToString:@"OK"]) {
                    
                    if (!transformatorId) {
                        NSNumber *insertedId = [responseObject objectForKey:@"inserted_id"];
                        [_transformator setValue:insertedId forKey:@"id"];
                    }
                    
                    [segue.destinationViewController setTransformator:_transformator];
                    [segue.destinationViewController setIsNew:_isNew];
                    
                    [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                    
                } else {
                    
                    [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                    NSString *error = [responseObject objectForKey:@"error"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }];
        } else {
            [segue.destinationViewController setTransformator:_transformator];
            [segue.destinationViewController setIsNew:_isNew];
        }
    }
}


@end
