//
//  RegistrationViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 01.03.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
- (IBAction)registrationButton:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *dominateSlider;

@end
