//
//  DetailViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENTransformator.h"

@interface DetailViewController : UIViewController

@property (strong,nonatomic) ENTransformator *transformator;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
