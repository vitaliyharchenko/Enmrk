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
#import "DescriptionViewController.h"

@interface AddViewController ()

@property NSDictionary *options;
@property NSArray *optionsTitles;

@end

@implementation AddViewController

- (void)loadInitialData {
    self.options = [ENTransformator initMenuDictionary];
    self.optionsTitles = [ENTransformator initMenuArray];
    
    self.about = @"Описание херписание";
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    NSMutableDictionary *array = [[NSMutableDictionary alloc] init];
    NSNumber *nill = @0;
    
    for (NSString *n in _optionsTitles) {
        [array setObject:nill forKey:n];
    }
    _selectedOptions = array;
}

- (void)enableDoneButton:(BOOL)enable {
    if (enable == YES) {
        [_addButton setEnabled:YES];
    } else {
        [_addButton setEnabled:NO];
    }
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    SelectTableViewController *source = [segue sourceViewController];
    self.selectedOptions = source.selectedOptions;
    
    [self.tableView reloadData];

}

- (IBAction)unwindFromAbout:(UIStoryboardSegue *)segue {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    
    self.navigationItem.title = @"Добавить трансформатор";
    
    [self loadInitialData];
    
    [self.tableView reloadData];
    
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
    return [self.optionsTitles count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = [self.optionsTitles count];
    if ([indexPath row] == count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Description Cell" forIndexPath:indexPath];
        cell.detailTextLabel.text = _about;
        return cell;
    }
    //
    //    if ([indexPath row] == count+1) {
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo Cell" forIndexPath:indexPath];
    //        return cell;
    //    }
    //    
    //    if ([indexPath row] == count+2) {
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Button Cell" forIndexPath:indexPath];
    //        return cell;
    //    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *key = [_optionsTitles objectAtIndex:[indexPath row]];
    NSArray *options = [_options objectForKey:key];
    
    cell.textLabel.text = key;
    
    NSNumber *selected = [_selectedOptions objectForKey:key];
    NSObject *option = [options objectAtIndex:[selected integerValue]];
    if ([key  isEqual: @"Мощность"] && ![[_selectedOptions valueForKey:@"Мощность"] isEqual: @0]) {
        NSString *text = [NSString stringWithFormat:@"%@ кВт",option];
        cell.detailTextLabel.text = text;
    } else {
        NSString *text = [NSString stringWithFormat:@"%@",option];
        cell.detailTextLabel.text = text;
    }
    
    if (![[_selectedOptions valueForKey:key] isEqual: @0]) {
        cell.backgroundColor = [UIColor colorWithRed:81/255.0f green:218/255.0f blue:132/255.0f alpha:0.5f];
    }

    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"optionSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath) {
            NSString *key = [_optionsTitles objectAtIndex:[indexPath row]];
            [segue.destinationViewController setSelectedOptions:_selectedOptions];
            [segue.destinationViewController setKey:key];
            [segue.destinationViewController setOptions:_options];
        }
    }
    
    if ([[segue identifier] isEqualToString:@"descriptionSegue"]) {
        [segue.destinationViewController setAbout:_about];
    }
}


@end
