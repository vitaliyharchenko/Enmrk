//
//  ResetViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 01.03.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "ResetViewController.h"
#import "ENAuth.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface ResetViewController ()

@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_passwordField setDelegate:self];
    [_passwordField1 setDelegate:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
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

- (IBAction)reset:(id)sender {
    NSString *pass = _passwordField.text;
    NSString *pass1 = _passwordField.text;
    
    if ([pass isEqualToString:pass1]) {
        NSDictionary *parametersPre = [ENAuth parametersForAPI];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:parametersPre];
        
        [parameters setValue:@"passchange" forKey:@"act"];
        [parameters setValue:[ENAuth passEncodedForPassword:pass] forKey:@"newpass"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://enmrk.ru/api/auth/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *status = [responseObject objectForKey:@"status"];
            
            if ([status isEqualToString:@"OK"]) {
                
                AppDelegate *app = [[UIApplication sharedApplication] delegate];
                [app initWindowWithLogin];
                
            } else {
                
                [[ENAuth alloc] reAuthWithResponseObject:responseObject];
                
                NSString *error = [responseObject objectForKey:@"error"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Упс!" message:@"Пароль и его подтверждение должны совпадать." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}
@end
