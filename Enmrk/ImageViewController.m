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

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlString = [ENTransformator parseImageUrlForTransformator:_transformator forImsType:_imsType];
    
    #warning http://www.appcoda.com/ios-programming-camera-iphone-app/
    
    //NSString *UrlString = @"http://mtdata.ru/u8/photo993D/20942667724-0/original.jpg";
    NSURL *imgUrl = [NSURL URLWithString:urlString];
    [self.image setImageWithURL:imgUrl];
    
    self.navigationItem.title = [_imsType objectForKey:@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
