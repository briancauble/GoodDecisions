//
//  ChekmarkSelectedTableViewCell.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "ChekmarkSelectedTableViewCell.h"

@implementation ChekmarkSelectedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.accessoryType = selected?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    // Configure the view for the selected state
}

@end
