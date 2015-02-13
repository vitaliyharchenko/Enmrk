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
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    //    NSString *email = self.emailField.text;
    //    NSString *password = self.passwordField.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:@"http://enmrk.ru/api/auth/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [responseObject objectForKey:@"status"];
        NSString *rdn = [responseObject objectForKey:@"rdn"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Все окей" message:status delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self.activityIndicator setHidden:YES];
        
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app initWindowAfterLogin];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"API Auth Connection Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}
@end
