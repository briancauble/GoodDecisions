//
//  HistoryListTableViewCell.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/17/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "HistoryListTableViewCell.h"
#import "RatingView.h"
#import "DataManager.h"
#import "DecisionOutcome.h"
#import "DecisionInfluence.h"


@interface HistoryListTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet RatingView *ratingView;
@property (nonatomic, weak) IBOutlet UIView *scoreIndicatorView;

@end

@implementation HistoryListTableViewCell


-(void)configureWithDecision:(Decision *)decision{
    self.descriptionLabel.text = @" ";

    
    self.descriptionLabel.text = [NSString stringWithFormat:@"Because of %@, I %@.", decision.influence.name, decision.outcome.name];
    
    if ([decision.score integerValue] >0) {
        CGFloat alpha = [decision.score floatValue]/6.;
        UIColor *testGoodColor = [UIColor colorWithRed:30./255. green:179./255. blue:23./255. alpha:1];
        self.scoreIndicatorView.backgroundColor = [testGoodColor colorWithAlphaComponent:alpha];
    }else{
        CGFloat alpha = (-[decision.score floatValue])/6.;
        UIColor *testBadColor = [UIColor colorWithRed:255./255. green:87./255. blue:59./255. alpha:1];

        self.scoreIndicatorView.backgroundColor = [testBadColor colorWithAlphaComponent:alpha];
    }
    self.dateLabel.text =[[DataManager sharedDateFormatter] stringFromDate:decision.createdAt];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
