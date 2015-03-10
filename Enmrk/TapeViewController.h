//
//  TapeViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 26.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapeViewController : UIViewController

@property (nonatomic, strong) NSDictionary *selectedProperty;
@property (strong,nonatomic) NSMutableDictionary *transformator;
@property (strong,nonatomic) NSNumber *isNew;
@property (strong,nonatomic) NSDictionary *descriptionField;
@property (strong,nonatomic) NSDictionary *selectedPlayground;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
