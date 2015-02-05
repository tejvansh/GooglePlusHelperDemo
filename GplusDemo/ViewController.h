//
//  ViewController.h
//  GooglePlusDemo
//
//  Created by Tejvansh Singh Chhabra on 27/01/15.
//  Copyright (c) 2015 Google Plus Demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UITextField *textFieldURL;
}

- (IBAction)btnSignIn:(id)sender;
- (IBAction)btnSignOut:(id)sender;
- (IBAction)btnPost:(id)sender;

@end
