//
//  RatingView.h
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/6/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingView : UIView

@property (nonatomic, assign) NSInteger selectedValue;


-(void)setRating:(NSInteger)score;

@end
