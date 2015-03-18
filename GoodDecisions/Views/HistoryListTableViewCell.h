//
//  HistoryListTableViewCell.h
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/17/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Decision.h"

@interface HistoryListTableViewCell : UITableViewCell

-(void)configureWithDecision:(Decision *)decision;

@end
