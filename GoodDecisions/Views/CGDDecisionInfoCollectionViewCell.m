//
//  WhyCollectionViewCell.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/6/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "CGDDecisionInfoCollectionViewCell.h"
@interface CGDDecisionInfoCollectionViewCell ()
@end

@implementation CGDDecisionInfoCollectionViewCell

-(void)setHighlighted:(BOOL)highlighted{
    //invert
    if (self.highlighted != highlighted) {
        UIColor *currentTextColor = self.textLabel.textColor;
        UIColor *currentBackgroundColor = self.backgroundColor;
        
        self.textLabel.textColor = currentBackgroundColor;
        self.backgroundColor = currentTextColor;
    }
    
    [super setHighlighted:highlighted];
}

-(void)setSelected:(BOOL)selected{
    //invert
    if (self.selected != selected) {
        UIColor *currentTextColor = self.textLabel.textColor;
        UIColor *currentBackgroundColor = self.backgroundColor;
        
        self.textLabel.textColor = currentBackgroundColor;
        self.backgroundColor = currentTextColor;
    }
    
    [super setSelected:selected];
}
@end
