//
//  GPlusHelper.h
//  GooglePlus Helper
//
//  Created by TejvanshSingh Chhabra on 5/21/14.
//  Copyright (c) 2014 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface GPlusHelper : NSObject <GPPSignInDelegate>

typedef void (^GPPRequestBlock)(BOOL success, id result, NSError *error);

@property (nonatomic, strong) GPPSignIn *signIn;
@property (nonatomic, strong) GTLPlusPerson *loggedGoogleUser;
@property (nonatomic, readwrite, copy) GPPRequestBlock completionBlock;

+ (instancetype)sharedInstance;

#pragma mark - Public Methods

- (void)login:(GPPRequestBlock)completionHandler;
- (void)shareWithinApp:(BOOL)inApp withCompletion:(GPPRequestBlock)completionHandler;
- (void)shareFromURL:(NSString *)url withinApp:(BOOL)inApp withCompletion:(GPPRequestBlock)completionHandler;
- (void)disconnect;
- (void)logout;

@end
