//
//  LoginViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"
#import "AESCrypt.h"

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
    
    NSString *login = self.loginField.text;
    NSString *password = self.passwordField.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:@"http://enmrk.ru/api/auth/" parameters:@{@"login": login} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [responseObject objectForKey:@"status"];
        NSString *rnd = [responseObject objectForKey:@"rnd"];
        
        if ([status isEqualToString:@"OK"]) {
            
            NSString *md5pass = [password MD5];
            NSLog(@"Password: %@", password);
            NSLog(@"PasswordMD5: %@", md5pass);
            
            NSLog(@"RND in request: %@", rnd);
            
            NSString *rndDecoded = [AESCrypt decrypt:rnd password:password];
            NSLog(@"rdnDecoded: %@", rndDecoded);
            
            NSString *rndEncoded = [AESCrypt encrypt:rnd password:password];
            NSLog(@"rdnEncoded: %@", rndEncoded);
            
            
            NSString *pass = [password MD5];
            
            NSString *msgEncoded = [AESCrypt encrypt:@"Mesage" password:pass];
            NSLog(@"msgEncoded: %@", msgEncoded);
            
            NSString *msgDecoded = [AESCrypt decrypt:msgEncoded password:pass];
            NSLog(@"msgDecoded: %@", msgDecoded);
            
            
            
            NSDictionary *parameters = @{@"login": login, @"pass": password};
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:@"http://enmrk.ru/api/auth/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"Success Auth: %@",responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"API Auth Connection Error: %@", error);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }];
            
        }
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:status message:rnd delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//        [self.activityIndicator setHidden:YES];
//        
//        AppDelegate *app = [[UIApplication sharedApplication] delegate];
//        [app initWindowAfterLogin];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"API Auth Connection Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}
@end
