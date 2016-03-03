//
//  LoginService.m
//  ReactiveCocoaLearn
//
//  Created by hyyy on 16/3/3.
//  Copyright © 2016年 hyyy. All rights reserved.
//

#import "LoginService.h"

@implementation LoginService

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(HYSignInResponse)completeBlock{
    BOOL usernameValid = [username isEqualToString:@"user"];
    BOOL passwordValid = [password isEqualToString:@"123456"];
    if (usernameValid && passwordValid) {
        completeBlock(YES);
    }else{
        completeBlock(NO);
    }
}
@end
