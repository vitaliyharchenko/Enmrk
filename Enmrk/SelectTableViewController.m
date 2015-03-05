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
#import "ENTransformator.h"
#import "ENAuth.h"
#import "AFNetworking.h"
#import "Reachability.h"

@interface SelectTableViewController ()

@property (nonatomic, strong) NSObject *selectedValue;

@end

@implementation SelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedValue = [ENTransformator parseSelectedValueForProperty:_selectedProperty forTransformator:_transformator];
    
    NSString *propertyName = [_selectedProperty objectForKey:@"name"];
    self.navigationItem.title = propertyName;
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
    return [[_selectedProperty objectForKey:@"values"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Option Cell" forIndexPath:indexPath];
    
    NSMutableArray *values = [_selectedProperty objectForKey:@"values"];
    
    NSDictionary *value = [values objectAtIndex:[indexPath row]];
    NSObject *valueVal = [value objectForKey:@"val"];

    cell.textLabel.text = [NSString stringWithFormat:@"%@",valueVal];
    
    if (valueVal == _selectedValue) {
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.95];
    }
    
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
    
    NSMutableArray *values = [_selectedProperty objectForKey:@"values"];
    NSInteger selectedPropertyId = [[_selectedProperty objectForKey:@"id"] integerValue];
    NSDictionary *value = [values objectAtIndex:[indexPath row]];
    NSInteger valueId = [[value objectForKey:@"id"] integerValue];
    
    NSMutableDictionary *newTransformator = [ENTransformator editTransformator:_transformator setValue:valueId forProperty:_selectedProperty];
    _transformator = newTransformator;
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus != NotReachable)
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[ENAuth parametersForAPI]];
        [parameters setObject:@"editTransformer" forKey:@"act"];
        
        NSString *text = [NSString stringWithFormat:@"properties[%ld]",(long)selectedPropertyId];
        NSString *transf = [NSString stringWithFormat:@"%@",[_transformator objectForKey:@"id"]];
        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)valueId] forKey:text];
        
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

@end
