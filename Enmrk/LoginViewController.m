//
//  LoginViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)loginButton:(id)sender {
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    
    if ([email isEqualToString:@"test"] && [password isEqualToString:@"test"]) {
        NSLog(@"Success auth");
        // go to main navigation
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app initWindowAfterLogin];
    } else {
        NSLog(@"Auth error");
    }
}
@end
