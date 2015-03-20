//
//  DecisionViewController.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/1/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "DecisionViewController.h"
#import "UIView+Constraints.h"
#import "MinimalDecisionViewController.h"
#import "DataManager.h"
#import "PFQuery+Local.h"

@interface DecisionViewController ()
@property (nonatomic, strong) UIViewController *setupVC;
@property (nonatomic, strong) UIImageView *launchImageView;
@property (nonatomic, assign) BOOL needsSetup;
@property (nonatomic, strong) DecisionType *selectedType;

@end

@implementation DecisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFQuery *query = [DecisionType query];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.selectedType = (DecisionType*)object;
    }];
   
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.needsSetup = ![[NSUserDefaults standardUserDefaults] boolForKey:@"hasDoneSetup"];
    if (self.needsSetup) {
        self.setupVC = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        self.launchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Launchimage"]];
        [self.view addSubview:self.launchImageView];
        [self.launchImageView addConstraintsToFillSpaceOfRelatedView:self.view];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needsSetup) {
        self.setupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:self.setupVC animated:YES completion:^{
            [self.launchImageView removeFromSuperview];
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)showSettings:(id)sender{
    UIViewController *remindersVC = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SetupRemindersViewController"];
    [self presentViewController:remindersVC animated:YES completion:nil];
}

-(IBAction)logout:(id)sender{
    if ([PFUser currentUser]) {
        [PFUser logOut];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"minimalDecisionViewSegue"]){
        MinimalDecisionViewController *destVC = segue.destinationViewController;

        destVC.type = self.selectedType;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)unwindToMainViewController:(UIStoryboardSegue *)unwindSegue{
    
}

@end
