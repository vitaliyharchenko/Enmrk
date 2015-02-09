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

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong,nonatomic) ENTransformator *transformator;

- (void)setTransformatorData:(ENTransformator *)transformator;

@end
