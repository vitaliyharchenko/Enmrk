//
//  DetailTableViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 24.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "DetailTableViewController.h"
#import "AddViewController.h"
#import "MainTableViewController.h"
#import "ImagesTableViewController.h"
#import "TapeViewController.h"
#import "Reachability.h"
#import "PlaygroundsTableViewController.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue{
    UIViewController *vc = [segue sourceViewController];
    if ([vc isKindOfClass:[ AddViewController class]]) {
        AddViewController *addViewController = (AddViewController *)vc;
        if (addViewController.transformator != nil) {
            _transformator = addViewController.transformator;
            _isNew = addViewController.isNew;
        }
    }
    if ([vc isKindOfClass:[ TapeViewController class]]) {
        TapeViewController *addViewController = (TapeViewController *)vc;
        if (addViewController.transformator != nil) {
            _transformator = addViewController.transformator;
            _isNew = addViewController.isNew;
        }
    }
    if ([vc isKindOfClass:[ PlaygroundsTableViewController class]]) {
        PlaygroundsTableViewController *addViewController = (PlaygroundsTableViewController *)vc;
        if (addViewController.transformator != nil) {
            _transformator = addViewController.transformator;
            _isNew = addViewController.isNew;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ([indexPath row] == 2) {
        
        if ([_isNew integerValue] == 0) {
            if (networkStatus == NotReachable)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Редактирование полей закрыто. Отсутствует подключение к интернету" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                [self performSegueWithIdentifier:@"descriptionSegue" sender:self];
            }
        } else {
            [self performSegueWithIdentifier:@"descriptionSegue" sender:self];
        }
    }
    
    if ([indexPath row] == 1) {
        
        if ([_isNew integerValue] == 0) {
            if (networkStatus == NotReachable)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Просмотр изображений закрыт. Отсутствует подключение к интернету" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                [self performSegueWithIdentifier:@"photoSegue" sender:self];
            }
        } else {
            [self performSegueWithIdentifier:@"photoSegue" sender:self];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"markSegue"]) {
        [segue.destinationViewController setTransformator:_transformator];
        [segue.destinationViewController setProperties:_properties];
        [segue.destinationViewController setIsNew:_isNew];
    } else if ([[segue identifier] isEqualToString:@"photoSegue"]) {
        [segue.destinationViewController setTransformator:_transformator];
        [segue.destinationViewController setProperties:_properties];
        [segue.destinationViewController setIsNew:_isNew];
        [segue.destinationViewController setImsTypes:_imsTypes];
    } else if ([[segue identifier] isEqualToString:@"descriptionSegue"]) {
        [segue.destinationViewController setTransformator:_transformator];
        [segue.destinationViewController setIsNew:_isNew];
        [segue.destinationViewController setDescriptionField:_descriptionField];
    } else if ([[segue identifier] isEqualToString:@"playgroundsSegue"]) {
        [segue.destinationViewController setTransformator:_transformator];
        [segue.destinationViewController setIsNew:_isNew];
        [segue.destinationViewController setPlaygrounds:_playgrounds];
        [segue.destinationViewController setPlaygroundsStatuses:_playgroundsStatuses];
        [segue.destinationViewController setProperties:_properties];
    }
}

@end
