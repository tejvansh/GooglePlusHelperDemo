//
//  ViewController.m
//  GooglePlusDemo
//
//  Created by Tejvansh Singh Chhabra on 27/01/15.
//  Copyright (c) 2015 Google Plus Demo. All rights reserved.
//

#import "ViewController.h"
#import "GPlusHelper.h"

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)btnSignIn:(id)sender {
	[[GPlusHelper sharedInstance] login: ^(BOOL success, id result, NSError *error) {
	    NSLog(@"Details : %@", [GPlusHelper sharedInstance].loggedGoogleUser);
	}];
}

- (IBAction)btnSignOut:(id)sender {
	[[GPlusHelper sharedInstance] logout];
}

- (IBAction)btnPost:(id)sender {
    if ([textFieldURL.text isEqualToString:@""])
        [[GPlusHelper sharedInstance] shareWithinApp:YES withCompletion:nil];
    else
        [[GPlusHelper sharedInstance] shareFromURL:textFieldURL.text withinApp:YES withCompletion:nil];
}

@end
