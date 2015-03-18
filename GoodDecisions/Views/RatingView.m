//
//  RatingView.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/6/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "RatingView.h"
#import "UIView+Constraints.h"

@interface RatingView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;

@end

@implementation RatingView

-(void)awakeFromNib {
    [[NSBundle mainBundle] loadNibNamed:@"RatingView" owner:self options:nil];
    [self addSubview: self.contentView];
    [self.contentView addConstraintsToFillSpaceOfRelatedView:self];
}

-(IBAction)selectRating:(UIButton *)sender{
    
    for (UIButton *button in self.buttonCollection) {
        if ((sender.tag <= button.tag && button.tag <0) || (0 < button.tag && button.tag <= sender.tag) ) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    self.selectedValue = sender.tag;
}

-(void)setRating:(NSInteger)score{
    
    for (UIButton *button in self.buttonCollection) {
        if ((score <= button.tag && button.tag <0) || (0 < button.tag && button.tag <= score) ) {
            button.selected = YES;
            button.hidden = NO;
        }else{
            button.hidden = YES;
            button.selected = NO;
        }
        button.tintColor = self.tintColor;
    }
    self.selectedValue = score;
    
}
@end
