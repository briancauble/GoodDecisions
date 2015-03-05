//
//  SetupDoneViewController.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/1/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "SetupDoneViewController.h"

@interface SetupDoneViewController ()

@end

@implementation SetupDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  At end of setup screens
 */

-(IBAction)setupDone:(id)sender{
    
//    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"needsSetup"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
