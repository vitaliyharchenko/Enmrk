//
//  ImageViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 27.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UITableViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (strong,nonatomic) NSDictionary *imsType;
@property (strong,nonatomic) NSMutableDictionary *transformator;
@property (strong,nonatomic) NSArray *properties;
@property (strong,nonatomic) NSNumber *isNew;
@property (strong,nonatomic) NSMutableArray *images;

@end
