//
//  SetupRemindersViewController.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "SetupRemindersViewController.h"
#import "DataManager.h"
#import "Habit.h"

@interface SetupRemindersViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableData;
@end

@implementation SetupRemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [DecisionType findAllDecisionTypesWithResult:^(NSArray *objects, NSError *error) {
        if(!error){
            PFQuery *query = [Habit query];
        
            [query whereKey:@"type" containedIn:objects];

            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    self.tableData = objects;
                    [self.tableView reloadData];
                }else {
                    DDLogError(@"%@", [error userInfo][@"error"]);
                }
            }];
        }
    }];

    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Habit *habit = self.tableData[indexPath.row];
    cell.textLabel.text = habit.name;
    if (habit.isSelected) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}


#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"setupDoneSegue"]) {
        if (!self.navigationController) {
            [self saveSelection];
            [self dismissViewControllerAnimated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"setupDoneSegue"]) {
        [self saveSelection];
    }
}

-(void)saveSelection{
    [[DataManager sharedManager] clearAllHabits];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Habit *habit = self.tableData[indexPath.row];
    [[DataManager sharedManager] addHabit:habit];
}
@end
