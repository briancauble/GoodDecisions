//
//  ViewController.m
//  GoodDecisions
//
//  Created by Brian Cauble on 2/15/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // testing source control
    UIImage *backgroundImage = [UIImage imageNamed:@"Launchimage.png"];
    
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image = backgroundImage;
    
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
