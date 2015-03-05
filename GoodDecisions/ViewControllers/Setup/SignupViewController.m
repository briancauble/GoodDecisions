//
//  SignupViewController.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()
@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *email;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UILabel *errorLabel;


@property (nonatomic, strong) PFUser *user;

@end

@implementation SignupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)signup:(id)sender{
    self.errorLabel.text= nil;
    self.user = [PFUser user];
    self.user.username = self.username.text;
    self.user.password = self.password.text;
    self.user.email = self.email.text;
        
    if(![self.user.username length]){
            self.errorLabel.text = @"missing username";
    }else if(![self.user.password length]){
        self.errorLabel.text = @"missing password";
    }else if(![self.user.email length]){
        self.errorLabel.text = @"missing email";
    }else{
        [self.user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [self performSegueWithIdentifier:@"SecondSetupScreen" sender:nil];
            }
            else{
                self.errorLabel.text = error.userInfo[@"error"]?:@"An unknown error occured.";
            }
        }];
    }
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"SecondSetupScreen"]) {
        if (![[PFUser currentUser].username isEqualToString:self.username.text]) {
            return NO;
        }
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}@end