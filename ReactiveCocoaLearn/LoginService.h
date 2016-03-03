//
//  LoginService.h
//  ReactiveCocoaLearn
//
//  Created by hyyy on 16/3/3.
//  Copyright © 2016年 hyyy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HYSignInResponse)(BOOL);
@interface LoginService : NSObject

- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                  complete:(HYSignInResponse)completeBlock;

@end
