//
//  UIView+Constraints.m
//  SchoolCast4Me
//
//  Created by Andria Jensen on 5/2/14.
//  Copyright (c) 2014 High Ground Solutions, Inc. All rights reserved.
//

#import "UIView+Constraints.h"

@implementation UIView (Constraints)

- (NSLayoutConstraint *) addConstraintToCenterHorizontallyWithRelatedView:(UIView *)relatedView offsetFromCenter:(CGFloat)offsetFromCenter {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:relatedView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1
                                                                   constant:offsetFromCenter];
    [relatedView addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *) addConstraintToCenterVerticallyWithRelatedView:(UIView *)relatedView offsetFromCenter:(CGFloat)offsetFromCenter {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:relatedView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1
                                                                   constant:offsetFromCenter];
    [relatedView addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *) addConstraintToCenterHorizontallyWithRelatedView:(UIView *)relatedView {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:relatedView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1
                                                                   constant:0];
    [relatedView addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *) addConstraintToCenterVerticallyWithRelatedView:(UIView *)relatedView {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:relatedView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1
                                                                   constant:0];
    [relatedView addConstraint:constraint];
    return constraint;
}

- (NSArray *) addConstraintsToFillSpaceOfRelatedView:(UIView *)relatedView {
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObject:[self addEdgeConstraint:NSLayoutAttributeBottom relatedView:relatedView]];
    [constraints addObject:[self addEdgeConstraint:NSLayoutAttributeTop relatedView:relatedView]];
    [constraints addObject:[self addEdgeConstraint:NSLayoutAttributeLeading relatedView:relatedView]];
    [constraints addObject:[self addEdgeConstraint:NSLayoutAttributeTrailing relatedView:relatedView]];
    
    return [constraints copy];
}

- (NSLayoutConstraint *) addEdgeConstraint:(NSLayoutAttribute)edge relatedView:(UIView *)relatedView {
    return [self addEdgeConstraint:edge relatedView:relatedView spaceToEdge:0];
}

- (NSLayoutConstraint *) addEdgeConstraint:(NSLayoutAttribute)edge relatedView:(UIView *)relatedView spaceToEdge:(CGFloat)spaceToEdge {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:edge
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:relatedView
                                                                  attribute:edge
                                                                 multiplier:1
                                                                   constant:spaceToEdge];
    [relatedView addConstraint:constraint];
    return constraint;
}

- (NSArray *) addFixedSizeConstraint:(CGSize)size {
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObject:[self addFixedHeightConstraint:size.height]];
    [constraints addObject:[self addFixedWidthConstraint:size.width]];
    return [constraints copy];
}

- (NSLayoutConstraint *) addFixedHeightConstraint:(CGFloat)height {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:height];
    [self addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *) addFixedWidthConstraint:(CGFloat)width {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:width];
    [self addConstraint:constraint];
    return constraint;
}

- (NSArray *) spaceViews:(NSArray *)views onAxis:(UILayoutConstraintAxis)axis {
    NSAssert([views count] > 1,@"Can only distribute 2 or more views");
    
    NSLayoutAttribute attributeForView;
    NSLayoutAttribute attributeToPin;
    
    switch (axis) {
        case UILayoutConstraintAxisHorizontal:
            attributeForView = NSLayoutAttributeCenterX;
            attributeToPin = NSLayoutAttributeRight;
            break;
        case UILayoutConstraintAxisVertical:
            attributeForView = NSLayoutAttributeCenterY;
            attributeToPin = NSLayoutAttributeBottom;
            break;
        default:
            return @[];
    }
    
    CGFloat fractionPerView = 1.0 / (CGFloat)([views count] + 1);
    
    NSMutableArray *constraints = [NSMutableArray array];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGFloat multiplier = fractionPerView * (idx + 1.0);
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:attributeForView relatedBy:NSLayoutRelationEqual toItem:self attribute:attributeToPin multiplier:multiplier constant:0.0];
        [constraints addObject:constraint];
     }];
    
    [self addConstraints:constraints];
    return [constraints copy];
}


-(NSLayoutConstraint *)addConstraintToMaintainAspectRatio:(CGFloat)ratio{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:ratio
                                                                   constant:0.0];
    [self addConstraint:constraint];
    return constraint;
}


@end
