//
//  RegistrationViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 01.03.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "RegistrationViewController.h"
#import "ENAuth.h"
#import "AFNetworking.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_emailField setDelegate:self];
    // Do any additional setup after loading the view.
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
- (IBAction)registrationButton:(id)sender {
    
    NSString *email = _emailField.text;
    BOOL isOn = _dominateSlider.on;

    NSDictionary *parametersPre = [ENAuth parametersForAPI];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:parametersPre];
    
    if (isOn) {
        [parameters setValue:@"1" forKey:@"dominate"];
    }
    [parameters setValue:@"register" forKey:@"act"];
    [parameters setValue:email forKey:@"email"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://enmrk.ru/api/auth/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *status = [responseObject objectForKey:@"status"];

        if ([status isEqualToString:@"OK"]) {

            [[ENAuth alloc] reAuthWithResponseObject:responseObject];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Все хорошо!" message:@"Регистрация выполнена успешно." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];

            [self.navigationController popViewControllerAnimated:YES];

        } else {

            [[ENAuth alloc] reAuthWithResponseObject:responseObject];

            NSString *error = [responseObject objectForKey:@"error"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}
@end
