//
//  SignupViewController.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "SignupViewController.h"
#import "UIView+Constraints.h"

@interface SignupViewController ()
@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *email;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (nonatomic, strong) PFUser *user;

@end

@implementation SignupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat spaceToBottom =self.bottomView.frame.origin.y + self.bottomView.frame.size.height -self.view.frame.size.height;
    NSLayoutConstraint *bottomConstraint = [self.bottomView addEdgeConstraint:NSLayoutAttributeBottom relatedView:self.view spaceToEdge:spaceToBottom];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        bottomConstraint.constant = MIN(spaceToBottom, -keyboardFrame.size.height-10);
        [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        bottomConstraint.constant = spaceToBottom;
        [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
        
    }];
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
                if (error.code == 202) {
                    [PFUser logInWithUsernameInBackground:self.user.username password:self.user.password block:^(PFUser *user, NSError *error) {
                        if(!error){
                            user.email = self.user.email;
                            [user saveEventually];
                            [self performSegueWithIdentifier:@"SecondSetupScreen" sender:nil];
                        }else{
                            self.errorLabel.text = [NSString stringWithFormat:@"Enter unique username or correct password for %@.",self.user.username];
                        }
                    }];
                }else{
                    self.errorLabel.text = error.userInfo[@"error"]?:@"An unknown error occured.";
                }
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