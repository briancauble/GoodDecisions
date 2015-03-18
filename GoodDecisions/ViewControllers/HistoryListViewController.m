//
//  HistoryListViewController.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/17/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "HistoryListViewController.h"
#import "HistoryListTableViewCell.h"
#import "Decision.h"

@interface HistoryListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableData;

@end

@implementation HistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Decision findAllDecisionsWithResult:^(NSArray *objects, NSError *error) {
        self.tableData = objects;
        [self.tableView reloadData];
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell configureWithDecision:self.tableData[indexPath.row]];
    
    return cell;
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
