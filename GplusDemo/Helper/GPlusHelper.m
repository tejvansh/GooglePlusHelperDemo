//
//  GPlusHelper.m
//  GooglePlus Helper
//
//  Created by TejvanshSingh Chhabra on 5/21/14.
//  Copyright (c) 2014 MAC. All rights reserved.
//
//Google Plus iOS SDK 1.7.1

#import "GPlusHelper.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

#define appDel ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kLOADING  @"Loading" // String you want to show with Indicator
#define kClientID @"870585275965-upq8jf8s4fl9rbdpa3qniqmfim15n374.apps.googleusercontent.com" // Your application's client ID

@implementation GPlusHelper

#pragma mark - Singleton Methods

+ (instancetype)sharedInstance {
	static GPlusHelper *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    sharedInstance = [[super allocWithZone:NULL] init];
	    [sharedInstance initialize];
	});
	return sharedInstance;
}

- (void)initialize {
	if (self.signIn == nil) {
		self.signIn = [GPPSignIn sharedInstance];
		self.signIn.shouldFetchGooglePlusUser = YES;
		//signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email

		// You previously set kClientId in the "Initialize the Google+ client" step
		self.signIn.clientID = kClientID;

		// Uncomment one of these two statements for the scope you chose in the previous step
		self.signIn.scopes = @[kGTLAuthScopePlusLogin, kGTLAuthScopePlusUserinfoProfile];    // "https://www.googleapis.com/auth/plus.login", "https://www.googleapis.com/auth/userinfo.profile" scope

		// Optional: declare signIn.actions, see "app activities"
		self.signIn.delegate = self;
	}
}

#pragma mark - Google Plus Methods

- (void)login:(GPPRequestBlock)completionHandler {
	self.completionBlock = completionHandler;

	// Show indicator
	[self showGlobalHUDWithTitle:kLOADING];

	if (![self.signIn trySilentAuthentication])
		[self.signIn authenticate];
}

- (void)shareWithinApp:(BOOL)inApp withCompletion:(GPPRequestBlock)completionHandler {
	[self login: ^(BOOL success, id result, NSError *error) {
	    if (success) {
	        id <GPPShareBuilder> shareBuilder;
	        if (inApp)
				shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
	        else
				shareBuilder = [[GPPShare sharedInstance] shareDialog];
	        [shareBuilder open];
		}
	}];
}

- (void)shareFromURL:(NSString *)url withinApp:(BOOL)inApp withCompletion:(GPPRequestBlock)completionHandler {
	[self login: ^(BOOL success, id result, NSError *error) {
	    if (success) {
	        id <GPPShareBuilder> shareBuilder;
	        if (inApp)
				shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
	        else
				shareBuilder = [[GPPShare sharedInstance] shareDialog];
	        [shareBuilder setURLToShare:[NSURL URLWithString:url]];
	        [shareBuilder open];
		}
	}];
}

- (void)disconnect {
	if (self.signIn) {
		[self.signIn disconnect];
	}
}

- (void)logout {
	if (self.signIn) {
		[self.signIn signOut];
	}
}

- (void)refreshInterfaceBasedOnSignIn {
	if ([self.signIn authentication]) {
		// The user is signed in.
		// Perform other actions here, such as showing a sign-out button

		// Store Current logged in user
		self.loggedGoogleUser = self.signIn.googlePlusUser;

		// Check if current user is set or not
		if (self.loggedGoogleUser == nil) {
			GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];

			// 1. Create a |GTLServicePlus| instance to send a request to Google+.
			GTLServicePlus *plusService = [[GTLServicePlus alloc] init];
			plusService.retryEnabled = YES;

			// 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
			[plusService setAuthorizer:self.signIn.authentication];

			// 3. Use the "v1" version of the Google+ API.*
			plusService.apiVersion = @"v1";
			[plusService executeQuery:query completionHandler: ^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) {
			    // Stop Indicator
			    [self hideGlobalHUD];

			    if (error) {
			        //Handle Error
                    if (self.completionBlock) {
                        self.completionBlock(NO, nil, error);
                        self.completionBlock = nil;
                    }
                }
			    else {
			        self.loggedGoogleUser = person;
			        if (self.completionBlock) {
			            self.completionBlock(YES, person, nil);
			            self.completionBlock = nil;
					}
				}
			}];
		}
		else if (self.completionBlock) {
			// Stop Indicator
			[self hideGlobalHUD];

			self.completionBlock(YES, self.loggedGoogleUser, nil);
			self.completionBlock = nil;
		}
		else {
			// Stop Indicator
			[self hideGlobalHUD];
		}
	}
	else {
		// Stop Indicator
		// Perform other actions here like Show alert
		[self hideGlobalHUD];
        if (self.completionBlock) {
            self.completionBlock(NO, nil, nil);
            self.completionBlock = nil;
        }
    }
}

#pragma mark - GPPSignIn Delegate Methods

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
	//NSLog(@"Received error %@ and auth object %@", error, auth);
	if (error) {
		// Do some error handling here.
		// Stop Indicator
		[self hideGlobalHUD];
	}
	else {
		[self refreshInterfaceBasedOnSignIn];
	}
}

- (void)didDisconnectWithError:(NSError *)error {
	if (error) {
		NSLog(@"Received error %@", error);
	}
	else {
		// The user is signed out and disconnected.
		// Clean up user data as specified by the Google+ terms.
	}
}

#pragma mark - Global Indicator Methods

/**
 *  This method displays MBProgressHUD on top of window to perform synchronous tasks.
 *
 *  @param title Title of the indicator you want to display while performing any task.
 */
- (void)showGlobalHUDWithTitle:(NSString *)title {
	[self hideGlobalHUD];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:(UIView *)appDel.window animated:YES];
	hud.labelText = title;
}

/**
 *  Method will hide any hud currently visible on the window.
 */
- (void)hideGlobalHUD {
	[MBProgressHUD hideAllHUDsForView:(UIView *)appDel.window animated:YES];
}

@end
