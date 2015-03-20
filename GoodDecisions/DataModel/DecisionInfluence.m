//
//  DecisionInfluence.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/18/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "DecisionInfluence.h"

@implementation DecisionInfluence

@dynamic name;

+ (void)load {
    [self registerSubclass];
}


+ (NSString *)parseClassName {
    return @"DecisionInfluence";
}


//- (BOOL) isEqual:(id)object{
//    
//    if ([object isKindOfClass:[PFObject class]]){
//        PFObject* pfObject = object;
//        DDLogDebug(@"%@! %@:%@", [self.objectId isEqualToString:pfObject.objectId]?@"YES":@"NO", self.objectId, pfObject.objectId);
//        return [self.objectId isEqualToString:pfObject.objectId];
//    }
//    
//    return NO;
//}
//
//- (NSUInteger) hash{
//    return self.objectId.hash;
//}
@end
