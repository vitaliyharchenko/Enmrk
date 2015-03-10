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

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _images = [ENTransformator parseImagesForTransformator:_transformator forImsType:_imsType];
    
    self.navigationItem.title = [_imsType objectForKey:@"name"];
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
    
    #warning http://www.appcoda.com/ios-programming-camera-iphone-app/
    
    NSDictionary *image = [_images objectAtIndex:[indexPath row]-1];
    
    NSString *urlString = [image objectForKey:@"url"];
    NSURL *imgUrl = [NSURL URLWithString:urlString];
    
    [cell.cellImageView setImageWithURL:imgUrl];
    
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
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[ENAuth parametersForAPI]];
//        [parameters setObject:@"rmTransformer" forKey:@"act"];
//        
//        NSString *transf = [NSString stringWithFormat:@"%@",[[_transformators objectAtIndex:indexPath.row-1] objectForKey:@"id"]];
//        [parameters setObject:transf forKey:@"transf"];
//        
//        NSMutableArray *transformatorsMutable = [NSMutableArray arrayWithArray:_transformators];
//        [transformatorsMutable removeObjectAtIndex:indexPath.row-1];
//        _transformators = transformatorsMutable;
//        
//        // NSLog(@"Delete Transformer params: %@",parameters);
//        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        [manager POST:@"http://enmrk.ru/api/transformers/add/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSLog(@"delete Transformers: %@",responseObject);
//            
//            NSString *status = [responseObject objectForKey:@"status"];
//            
//            if ([status isEqualToString:@"OK"]) {
//                
//                [[ENAuth alloc] reAuthWithResponseObject:responseObject];
//                
//            } else {
//                NSString *error = [responseObject objectForKey:@"error"];
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alertView show];
//                [[ENAuth alloc] reAuthWithResponseObject:responseObject];
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alertView show];
//        }];
//        
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}


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
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    
    //NSMutableDictionary *newTransformator = [ENTransformator editTransformator:_transformator addImage:imageData forImsType:_imsType];
    //_transformator = newTransformator;
    
    NSNumber *transformatorId = [_transformator objectForKey:@"id"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://enmrk.ru/api/transformers/add/"]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[ENAuth parametersForAPI]];
    [parameters setObject:@"editTransformer" forKey:@"act"];
    
    AFHTTPRequestOperation *op = [manager POST:@"http://enmrk.ru/api/transformers/add/" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:[_imsType objectForKey:@"name"] fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
        if (!transformatorId) {
            NSNumber *insertedId = [responseObject objectForKey:@"inserted_id"];
            [_transformator setValue:insertedId forKey:@"id"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
