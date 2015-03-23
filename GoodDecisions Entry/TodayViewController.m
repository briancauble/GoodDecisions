//
//  TodayViewController.m
//  GoodDecisions Entry
//
//  Created by Abigail Fritz on 3/21/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.stepper setDecrementImage:[UIImage imageNamed:@"thumbs_down_icon"] forState:UIControlStateNormal];
    [self.stepper setIncrementImage:[UIImage imageNamed:@"thumbs_up_icon"] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)stepperValueChanged:(UIStepper *)sender {
    if (sender.value == 0) {
        sender.tintColor = [UIColor colorWithRed:1. green:1. blue:59./255. alpha:1];
    }else if(sender.value <0){
        sender.tintColor = [UIColor colorWithRed:1. green:(255 +sender.value*34)/255. blue:59./255. alpha:1];
    }else if (sender.value >0){
        sender.tintColor = [UIColor colorWithRed:(255 -sender.value*34)/255. green:1. blue:59./255. alpha:1];
    }
//    switch ((NSInteger)sender.value) {
//        case -5:
//            sender.tintColor = [UIColor colorWithRed:1. green:87./255. blue:59./255. alpha:1];
//            break;
//        case -4:
//            sender.tintColor = [UIColor colorWithRed:1. green:120./255. blue:59./255. alpha:1];
//            break;
//        case -3:
//            sender.tintColor = [UIColor colorWithRed:1. green:153./255. blue:59./255. alpha:1];
//            break;
//        case -2:
//            sender.tintColor = [UIColor colorWithRed:1. green:187./255. blue:59./255. alpha:1];
//            break;
//        case -1:
//            sender.tintColor = [UIColor colorWithRed:1. green:221./255. blue:59./255. alpha:1];
//            break;
//        default:
//            break;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
