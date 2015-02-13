//
//  DescriptionViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 12.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = _about;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    _about = self.textView.text;
    [segue.destinationViewController setAbout:_about];
}

@end
