//
//  DescriptionViewController.h
//  Enmrk
//
//  Created by Vitaliy Harchenko on 12.02.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSString *about;

//- (void)pasteAbout:(NSString *)text;

@end
