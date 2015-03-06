//
//  TintedBackgroundImageButton.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/6/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "TintedBackgroundImageButton.h"

@implementation TintedBackgroundImageButton

-(void)awakeFromNib{
    UIImage *backgroundImage = [self backgroundImageForState:UIControlStateNormal];
    UIImage *tintableBackgroundImage = [backgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setBackgroundImage:tintableBackgroundImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:tintableBackgroundImage forState:UIControlStateSelected];


}

@end
