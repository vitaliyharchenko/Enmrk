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
#import "AFNetworkReachabilityManager.h"
#import "DetailTableViewController.h"
#import "Reachability.h"

@interface AddViewController ()

@property (strong,nonatomic) NSMutableDictionary *selectedProperty;

@end

@implementation AddViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    [self.tableView reloadData];
}

- (void)setTransformator:(NSMutableDictionary *)transformator {
    _transformator = transformator;
    [self.tableView reloadData];
}

- (IBAction)unwindFromAbout:(UIStoryboardSegue *)segue {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"Марка трансформатора";
    
    [self.tableView reloadData];
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
    return [self.properties count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *prop = [self.properties objectAtIndex:[indexPath row]];
    NSInteger propId = [[prop objectForKey:@"id"] integerValue];
    
    BOOL isp = NO;
    if ([prop objectForKey:@"values"]) {
        isp = YES;
    }
    
    NSNumber *isProp = [NSNumber numberWithBool:isp];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Value Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [prop objectForKey:@"name"];
    
    NSString *fieldValue = [ENTransformator searchValueOfPropertyWithId:propId isProp:isProp forTransformator:_transformator forPropertiesArray:_properties];
    if (fieldValue) {
        cell.detailTextLabel.text = fieldValue;
    } else {
        cell.detailTextLabel.text = @"Не выбрано";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *property = [self.properties objectAtIndex:[indexPath row]];
    BOOL isProp = NO;
    if ([property objectForKey:@"values"]) {
        isProp = YES;
    }
    self.selectedProperty = property;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ([_isNew integerValue] == 0) {
        if (networkStatus == NotReachable)
        {
            NSLog(@"There is NO Internet connection");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Редактирование полей закрыто. Отсутствует подключение к интернету" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else
        {
            NSLog(@"There is Internet connection");
            if (isProp) {
                [self performSegueWithIdentifier:@"selectSegue" sender:self];
            } else {
                [self performSegueWithIdentifier:@"writeSegue" sender:self];
            }
        }
    } else {
        if (isProp) {
            [self performSegueWithIdentifier:@"selectSegue" sender:self];
        } else {
            [self performSegueWithIdentifier:@"writeSegue" sender:self];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"selectSegue"]) {
        [segue.destinationViewController setSelectedProperty:_selectedProperty];
        [segue.destinationViewController setTransformator:_transformator];
        [segue.destinationViewController setIsNew:_isNew];
    } else if ([[segue identifier] isEqualToString:@"writeSegue"]) {
        [segue.destinationViewController setSelectedProperty:_selectedProperty];
        [segue.destinationViewController setTransformator:_transformator];
        [segue.destinationViewController setIsNew:_isNew];
    }
}


@end
