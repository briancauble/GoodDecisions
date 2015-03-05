//
//  UIView+Constraints.h
//  SchoolCast4Me
//
//  Created by Andria Jensen on 5/2/14.
//  Copyright (c) 2014 High Ground Solutions, Inc. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (Constraints)

- (NSLayoutConstraint *) addConstraintToCenterHorizontallyWithRelatedView:(UIView *)relatedView;
- (NSLayoutConstraint *) addConstraintToCenterVerticallyWithRelatedView:(UIView *)relatedView;
- (NSArray *) addConstraintsToFillSpaceOfRelatedView:(UIView *)relatedView;
- (NSLayoutConstraint *) addConstraintToCenterHorizontallyWithRelatedView:(UIView *)relatedView offsetFromCenter:(CGFloat)offsetFromCenter;
- (NSLayoutConstraint *) addConstraintToCenterVerticallyWithRelatedView:(UIView *)relatedView offsetFromCenter:(CGFloat)offsetFromCenter;
- (NSLayoutConstraint *) addEdgeConstraint:(NSLayoutAttribute)edge relatedView:(UIView *)relatedView;
- (NSLayoutConstraint *) addEdgeConstraint:(NSLayoutAttribute)edge relatedView:(UIView *)relatedView spaceToEdge:(CGFloat)spaceToEdge;
- (NSArray *) addFixedSizeConstraint:(CGSize)size;
- (NSLayoutConstraint *) addFixedHeightConstraint:(CGFloat)height;
- (NSLayoutConstraint *) addFixedWidthConstraint:(CGFloat)width;
- (NSLayoutConstraint *) addConstraintToMaintainAspectRatio:(CGFloat)ratio;


- (NSArray *) spaceViews:(NSArray *)views onAxis:(UILayoutConstraintAxis)axis;
@end
