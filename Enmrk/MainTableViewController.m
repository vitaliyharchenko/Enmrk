//
//  MainTableViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "MainTableViewController.h"
#import "ENTransformator.h"
#import "DetailTableViewController.h"
#import "AddViewController.h"
#import "ENAuth.h"
#import "AFNetworking.h"
#import "Reachability.h"

@interface MainTableViewController ()

@property (strong,nonatomic) NSNumber *currentId;

@end


@implementation MainTableViewController

- (void)loadInitialData {
    NSDictionary *parameters = [ENAuth parametersForAPI];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://enmrk.ru/api/transformers/get/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"OK"]) {
            
            self.transformators = [responseObject objectForKey:@"transformers"];
            NSArray *properties = [responseObject objectForKey:@"properties"];
            NSArray *fields = [responseObject objectForKey:@"fields"];
            NSArray *ims = [responseObject objectForKey:@"ims"];
            self.properties = [ENTransformator initOptionsWithProperties:properties andFields:fields];
            self.imsTypes = ims;
            self.descriptionField = [ENTransformator initDescriptionWithFields:fields];
            self.playgrounds = [responseObject objectForKey:@"playgrounds"];
            self.playgroundsStatuses = [responseObject objectForKey:@"playground_statuses"];
            
            [[ENAuth alloc] reAuthWithResponseObject:responseObject];
            
            [self.tableView reloadData];
            
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
}

- (void)updateTransformator:(NSMutableDictionary *)transformator atRow:(NSInteger)transformatorRow {
    NSMutableArray *mutable = [[NSMutableArray alloc] initWithArray:_transformators];
    [mutable replaceObjectAtIndex:transformatorRow withObject:transformator];
    _transformators = mutable;
    
    [self.tableView reloadData];
}

- (void)addTransformator:(NSMutableDictionary *)transformator {
    NSMutableArray *mutable = [[NSMutableArray alloc] initWithArray:_transformators];
    [mutable insertObject:transformator atIndex:0];
    _transformators = mutable;
    
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Трансформаторы";
    
    [self.tableView setDelegate: self];
    
    [self.tableView setDataSource:self];
    
    [self loadInitialData];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)syncFirst{

    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    int newCount = 0;
    int k;
    for (k=0; k<_transformators.count; k++) {
        NSDictionary *transformator = [_transformators objectAtIndex:k];
        NSString *name = [transformator objectForKey:@"name"];
        if (!name) {
            newCount++;
        }
    }
    
    if (newCount>0) {
        int l;
        for (l=0; l<newCount; l++) {
            __block NSDictionary *transformator = [_transformators objectAtIndex:0];
            
            //transformator sync block begin
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[ENAuth parametersForAPI]];
            [parameters setObject:@"editTransformer" forKey:@"act"];
            
            NSArray *fields = [transformator objectForKey:@"fields"];
            
            int i;
            if (fields.count > 0) {
                for (i=0; i<fields.count; i++) {
                    NSDictionary *field = [fields objectAtIndex:i];
                    NSString *fieldId = [NSString stringWithFormat:@"fields[%@]",[field objectForKey:@"id"]];
                    NSString *fieldVal = [NSString stringWithFormat:@"%@",[field objectForKey:@"val"]];
                    [parameters setObject:fieldVal forKey:fieldId];
                }
            }
            
            NSArray *properties = [transformator objectForKey:@"properties"];
            
            if (properties.count > 0) {
                for (i=0; i<properties.count; i++) {
                    NSDictionary *property = [properties objectAtIndex:i];
                    NSString *propId = [NSString stringWithFormat:@"properties[%@]",[property objectForKey:@"id"]];
                    NSString *propVal = [NSString stringWithFormat:@"%@",[property objectForKey:@"val"]];
                    [parameters setObject:propVal forKey:propId];
                }
            }
            
            __block BOOL done = NO;
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            [manager POST:@"http://enmrk.ru/api/transformers/add/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                // NSLog(@"Sync Transformers: %@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status isEqualToString:@"OK"]) {
                    
                    NSNumber *insertedId = [responseObject objectForKey:@"inserted_id"];
                    _currentId = insertedId;
                    
                    [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                    
                    NSMutableArray *transformatorsMutable = [NSMutableArray arrayWithArray:_transformators];
                    [transformatorsMutable removeObjectAtIndex:0];
                    _transformators = transformatorsMutable;
                    [self.tableView reloadData];
                    
                    done = YES;
                    
                } else {
                    
                    [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                    
                    NSString *error = [responseObject objectForKey:@"error"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    
                    done = YES;
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                done = YES;
            }];
            
            int o = 0;
            
            while (!done)
            {
                [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
                o++;
                NSLog(@"While Loop:%i", o);
            }
            
            //transformator img sync block start
            
            NSArray *ims = [transformator objectForKey:@"ims"];
            if (ims) {
                
                __block BOOL doneImg = NO;
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[ENAuth parametersForAPI]];
                [parameters setObject:@"editTransformer" forKey:@"act"];
                [parameters setObject:[NSString stringWithFormat:@"%@",_currentId] forKey:@"transf"];
                
                __block int r;
                for (r=0; r<ims.count; r++) {
                    NSDictionary *img = [ims objectAtIndex:r];
                    [parameters setObject:@"add" forKey:[NSString stringWithFormat:@"ims[%d][act]",r]];
                    [parameters setObject:[NSString stringWithFormat:@"%@",[img objectForKey:@"type"]] forKey:[NSString stringWithFormat:@"ims[%d][type]",r]];
                    [parameters setObject:[NSString stringWithFormat:@"photo%d",r] forKey:[NSString stringWithFormat:@"ims[%d][fileid]",r]];
                }
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
                
                
                AFHTTPRequestOperation *op = [manager POST:@"http://enmrk.ru/api/transformers/add/" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    
                    for (r=0; r<ims.count; r++) {
                        NSDictionary *img = [ims objectAtIndex:r];
                        NSData *imageData = [img objectForKey:@"image"];
                        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"photo%d",r] fileName:@"photo.jpg" mimeType:@"image/png"];
                    }
                    
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    // NSLog(@"[UploadVC] success = %@", responseObject);
                    
                    NSString *status = [responseObject objectForKey:@"status"];
                    
                    if ([status isEqualToString:@"OK"]) {
                        
                        [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                        
                        doneImg = YES;
                        
                    } else {
                        [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                        NSString *error = [responseObject objectForKey:@"error"];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                        
                        doneImg = YES;
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    // NSLog(@"[UploadVC] error = %@", error);
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    NSLog(@"%@",error);
                    
                    doneImg = YES;
                }];
                [op start];
                
                
                int w = 0;
                
                while (!doneImg)
                {
                    [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
                    w++;
//                    NSLog(@"While Img Loop:%i", w);
                }
                
                
            }
            
            //transformator img sync block end
            
            
            //transformator sync block end
        }
        [self loadInitialData];
        
    } else {
        [self loadInitialData];
    }
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
}

- (IBAction)syncAction:(id)sender {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus != NotReachable)
    {
        [self syncFirst];
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Сеть недоступна. Попробуйте словить сеть и повторить синхронизацию." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    UIViewController *vc = [segue sourceViewController];
    if ([vc isKindOfClass:[ DetailTableViewController class]]) {
        DetailTableViewController *addViewController = (DetailTableViewController *)vc;
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if (networkStatus != NotReachable)
        {
            [self loadInitialData];
        } else {
            if ([addViewController.isNew integerValue] == 0)
            {
                [self updateTransformator:addViewController.transformator atRow:addViewController.transformatorRow];
            } else {
                NSMutableDictionary *transf = addViewController.transformator;
                
                if ([transf objectForKey:@"AlreadyInTable"]) {
                    [self updateTransformator:transf atRow:addViewController.transformatorRow];
                } else {
                    [transf setValue:@"YES" forKey:@"AlreadyInTable"];
                    [self addTransformator:transf];
                }
            }
        }
    }
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
            NSString *transformatorName = [[_transformators objectAtIndex:indexPath.row-1] objectForKey:@"name"];
            
            if (!transformatorName) {
                transformatorName = [NSString stringWithFormat:@"Новый №%ld",(long)indexPath.row];
            }
            
            cell.textLabel.text = transformatorName;
        }
        
        return cell;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if ([indexPath row] == 0) {
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[ENAuth parametersForAPI]];
        [parameters setObject:@"rmTransformer" forKey:@"act"];
        
        NSString *transf = [NSString stringWithFormat:@"%@",[[_transformators objectAtIndex:indexPath.row-1] objectForKey:@"id"]];
        [parameters setObject:transf forKey:@"transf"];
        
        // NSLog(@"Delete Transformer params: %@",parameters);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://enmrk.ru/api/transformers/add/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"delete Transformers: %@",responseObject);
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status isEqualToString:@"OK"]) {
                
                [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                
                NSMutableArray *transformatorsMutable = [NSMutableArray arrayWithArray:_transformators];
                [transformatorsMutable removeObjectAtIndex:indexPath.row-1];
                _transformators = transformatorsMutable;
                
                // Delete the row from the data source
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            } else {
                NSString *error = [responseObject objectForKey:@"error"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [[ENAuth alloc] reAuthWithResponseObject:responseObject];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath) {
            NSMutableDictionary *transformator = [_transformators objectAtIndex:indexPath.row-1];
            [segue.destinationViewController setTransformator:transformator];
            [segue.destinationViewController setTransformatorRow:indexPath.row-1];
            [segue.destinationViewController setProperties:_properties];
            [segue.destinationViewController setPlaygrounds:_playgrounds];
            [segue.destinationViewController setPlaygroundsStatuses:_playgroundsStatuses];
            if ([transformator objectForKey:@"added"]) {
                [segue.destinationViewController setIsNew:[NSNumber numberWithInt:0]];
            } else {
                [segue.destinationViewController setIsNew:[NSNumber numberWithInt:1]];
            }
            [segue.destinationViewController setDescriptionField:_descriptionField];
            [segue.destinationViewController setImsTypes:_imsTypes];
        }
    }
    if ([[segue identifier] isEqualToString:@"newSegue"]) {
        NSMutableDictionary *transformator = [ENTransformator createNewTransformator];
        [segue.destinationViewController setTransformator:transformator];
        NSLog(@"Transformator: %@", transformator);
        [segue.destinationViewController setProperties:_properties];
        [segue.destinationViewController setPlaygrounds:_playgrounds];
        [segue.destinationViewController setPlaygroundsStatuses:_playgroundsStatuses];
        [segue.destinationViewController setImsTypes:_imsTypes];
        [segue.destinationViewController setIsNew:[NSNumber numberWithInt:1]];
        [segue.destinationViewController setDescriptionField:_descriptionField];
    }
}
@end
