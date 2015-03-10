//
//  ImageViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 27.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ENTransformator.h"
#import "ImageTableViewCell.h"
#import "AFNetworking.h"
#import "ENAuth.h"
#import "Reachability.h"
#import "ImagesTableViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadInitial];
    
    self.navigationItem.title = [_imsType objectForKey:@"name"];
}

- (void)loadInitial {
    _images = [ENTransformator parseImagesForTransformator:_transformator forImsType:_imsType];
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
    return [_images count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] != 0) {
        return 400;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Image Add" forIndexPath:indexPath];
        return cell;
    }
    
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Image Cell 1" forIndexPath:indexPath];
    
    NSDictionary *image = [_images objectAtIndex:[indexPath row]-1];
    
    NSString *urlString = [image objectForKey:@"url"];
    if (urlString) {
        NSURL *imgUrl = [NSURL URLWithString:urlString];
        [cell.cellImageView setImageWithURL:imgUrl];
    } else {
        NSData *imsData = [image objectForKey:@"image"];
        UIImage *image = [UIImage imageWithData:imsData];
        [cell.cellImageView setImage:image];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Отменить" destructiveButtonTitle:nil otherButtonTitles:@"Сфотографировать", @"Выбрать из галереи", nil];
        
        [actionSheet showInView:self.view];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if ([indexPath row] == 0) {
        return NO;
    }
    return YES;
}

#warning deleting images
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if (networkStatus != NotReachable) {
        
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[ENAuth parametersForAPI]];
            [parameters setObject:@"editTransformer" forKey:@"act"];
            
            NSDictionary *img = [_images objectAtIndex:indexPath.row-1];
            
            NSString *imgId = [NSString stringWithFormat:@"%@",[img objectForKey:@"id"]];
            [parameters setObject:imgId forKey:@"ims[0][id]"];
            [parameters setObject:@"rm" forKey:@"ims[0][act]"];
            
            NSString *transf = [NSString stringWithFormat:@"%@",[_transformator objectForKey:@"id"]];
            [parameters setObject:transf forKey:@"transf"];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:@"http://enmrk.ru/api/transformers/add/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"delete Transformers: %@",responseObject);
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status isEqualToString:@"OK"]) {
                    
                    NSMutableDictionary *transformatorMutable = [NSMutableDictionary dictionaryWithDictionary:_transformator];
                    NSDictionary *deleteImg = [_images objectAtIndex:indexPath.row-1];
                    
                    transformatorMutable = [ENTransformator editTransformator:_transformator deleteImg:deleteImg];
                    _transformator = transformatorMutable;
                    
                    [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                    
                    _images = [ENTransformator parseImagesForTransformator:_transformator forImsType:_imsType];
                    
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
        
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Работа с изображениями невозможна. Отсутствует подключение к интернету." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
    picker1.delegate = self;
    picker1.allowsEditing = YES;
    picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    switch (buttonIndex) {
        case 0:
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        case 1:
            [self presentViewController:picker1 animated:YES completion:NULL];
            break;
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    
    //NSMutableDictionary *newTransformator = [ENTransformator editTransformator:_transformator addImage:imageData forImsType:_imsType];
    //_transformator = newTransformator;
    
    NSNumber *transformatorId = [_transformator objectForKey:@"id"];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus != NotReachable) {
    
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[ENAuth parametersForAPI]];
        [parameters setObject:@"editTransformer" forKey:@"act"];
        
        [parameters setObject:@"add" forKey:@"ims[0][act]"];
        [parameters setObject:[NSString stringWithFormat:@"%@",[_imsType objectForKey:@"id"]] forKey:@"ims[0][type]"];
        [parameters setObject:@"photo" forKey:@"ims[0][fileid]"];
        
        if (!(transformatorId == 0)) {
            NSString *transf = [NSString stringWithFormat:@"%@",[_transformator objectForKey:@"id"]];
            [parameters setObject:transf forKey:@"transf"];
        }
        
        AFHTTPRequestOperation *op = [manager POST:@"http://enmrk.ru/api/transformers/add/" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary as I did, but append it!
            [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.png" mimeType:@"image/png"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status isEqualToString:@"OK"]) {
                
                if (!transformatorId) {
                    NSNumber *insertedId = [responseObject objectForKey:@"inserted_id"];
                    [_transformator setValue:insertedId forKey:@"id"];
                }
                
                NSDictionary *img = [[[responseObject objectForKey:@"report"] objectForKey:@"ims"] objectAtIndex:0];
                if (img) {
                    NSMutableDictionary *newTransformator = [ENTransformator editTransformator:_transformator addImg:img];
                    _transformator = newTransformator;
                } else {
                    NSString *error = [responseObject objectForKey:@"error"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
                
                [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                
                [self loadInitial];
                
            } else {
                [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                NSString *error = [responseObject objectForKey:@"error"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            NSLog(@"%@",error);
        }];
        [op start];
        
        
        [picker dismissViewControllerAnimated:YES completion:NULL];
    } else {
        NSMutableDictionary *newTransformator = [ENTransformator editNewTransformator:_transformator addImgData:imageData andImsType:_imsType];
        _transformator = newTransformator;
        
        [self loadInitial];
        
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    [segue.destinationViewController setTransformator:_transformator];
}


@end
