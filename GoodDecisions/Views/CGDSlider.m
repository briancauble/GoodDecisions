//
//  CGDSlider.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/23/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "CGDSlider.h"
#import "UIColor+GoodDecisions.h"

@implementation CGDSlider

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setThumbImage:[self thumbImageForState:UIControlStateNormal] forState:UIControlStateNormal];

    self.minimumTrackTintColor = [UIColor lightOrangeColor];
    self.maximumTrackTintColor = [UIColor darkOrangeColor];
    self.thumbTintColor = [UIColor tealColor];
}
-(CGRect)trackRectForBounds:(CGRect)bounds{
    CGRect rect=[super trackRectForBounds:bounds];
    return CGRectInset(rect, 0, -1);;
};
@end
