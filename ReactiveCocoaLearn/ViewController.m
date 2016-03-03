//
//  ViewController.m
//  ReactiveCocoaLearn
//
//  Created by hyyy on 16/3/2.
//  Copyright © 2016年 hyyy. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LoginService.h"

@interface ViewController ()

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) LoginService *signService;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACSignal *validUsernameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *text){
         return @([self isValidUsername:text]);
    }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text){
        return @([self isValidPassword:text]);
    }];
    
    RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid){
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RAC(self.usernameTextField, backgroundColor) = [validUsernameSignal map:^id(NSNumber *usernameValid){
        return [usernameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    // combining signals
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive){
        self.loginBtn.enabled = [signupActive boolValue];
    }];
    
    // touch up inside
    [[[[self.loginBtn
       rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x){
           self.loginBtn.enabled = NO;
           self.messageLabel.hidden = YES;
       }]
     flattenMap:^id(id x){
         return [self signInSignal];
     }]
     subscribeNext:^(NSNumber *signIn){
         self.messageLabel.hidden = NO;
         BOOL success = [signIn boolValue];
         if (success) {
             self.messageLabel.text = @"登陆成功";
         }else {
             self.messageLabel.text = @"登陆失败";
         }
    }];
    
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.messageLabel];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
- (BOOL)isValidUsername:(NSString *)text{
    return text.length > 3;
}

- (BOOL)isValidPassword:(NSString *)text{
    return text.length > 3;
}

- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        [self.signService signInWithUsername:self.usernameTextField.text password:self.passwordTextField.text complete:^(BOOL success){
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

#pragma mark - setter and getter
- (UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 30, 240, 30)];
        _usernameTextField.placeholder = @"Input your account";
    }
    return _usernameTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 70, 240, 30)];
        _passwordTextField.placeholder = @"Input your password";
    }
    return _passwordTextField;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 120, 120, 30)];
        [_loginBtn setBackgroundColor:[UIColor blueColor]];
        [_loginBtn setTitle:@"Login" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _loginBtn;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 160, 120, 30)];
        _messageLabel.textColor = [UIColor redColor];
    }
    return _messageLabel;
}

- (LoginService *)signService {
    if (!_signService) {
        _signService = [[LoginService alloc] init];
    }
    return _signService;
}
@end
