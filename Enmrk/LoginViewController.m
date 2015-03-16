//
//  LoginViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 07.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ENAuth.h"
#import "ENTransformator.h"
#import "MainTableViewController.h"
#import "FDKeychain.h"


#pragma mark Constants

static NSString * const KeychainItem_Service = @"ENmrk";
static NSString * const KeychainItem_Key_LocalPassword = @"LocalPassword";
static NSString * const KeychainItem_Key_LocalLogin = @"LocalLogin";


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_loginField setDelegate:self];
    [_passwordField setDelegate:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    NSString *password = [FDKeychain itemForKey: KeychainItem_Key_LocalPassword
                                               forService: KeychainItem_Service
                                                    error: nil];
    NSString *login = [FDKeychain itemForKey: KeychainItem_Key_LocalLogin
                                     forService: KeychainItem_Service
                                          error: nil];
    
    if (password && login) {
        [_loginField setText:login];
        [_passwordField setText:password];
        [self loginButton:self];
    }
}

-(void)dismissKeyboard {
//    [_loginField resignFirstResponder];
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
    
    [[ENAuth alloc] firstAuthWithLogin:login andPassword:password];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:@"http://enmrk.ru/api/auth/" parameters:@{@"login": login} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"First req. Response = %@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"OK"]) {
            
            [[ENAuth alloc] reAuthWithResponseObject:responseObject];
            
            NSDictionary *parameters = [ENAuth parametersForAPI];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:@"http://enmrk.ru/api/auth/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                //NSLog(@"First Auth. Response = %@",responseObject);
                
                [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                if ([status isEqualToString:@"OK"]) {
                    [self.activityIndicator setHidden:YES];
                    
                    AppDelegate *app = [[UIApplication sharedApplication] delegate];
                    [app initWindowAfterLogin];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Auth Error" message:@"Wrong user,pass" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    [self.activityIndicator setHidden:YES];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"API Auth Connection Error: %@", error);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                [self.activityIndicator setHidden:YES];
            }];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"API Auth Connection Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        [self.activityIndicator setHidden:YES];
    }];
}

- (IBAction)resetPass:(id)sender {
    
    NSString *login = self.loginField.text;
    if (login) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:@"http://enmrk.ru/api/auth/" parameters:@{@"login": login, @"act": @"passreset"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status isEqualToString:@"OK"]) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Успешно." message:@"Ваш пароль сброшен, проверьте свой электронный ящик." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Что-то пошло не так." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"API Auth Connection Error: %@", error);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
    }
    
}
@end
