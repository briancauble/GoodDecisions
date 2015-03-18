//
//  PFObject+isEqual.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/18/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "PFObject+isEqual.h"

@implementation PFObject (isEqual)


- (BOOL) isEqual:(id)object{
    
    if ([object isKindOfClass:[PFObject class]]){
        PFObject* pfObject = object;
        return [self.objectId isEqualToString:pfObject.objectId];
    }
    
    return NO;
}

- (NSUInteger) hash{
    return self.objectId.hash;
}
@end
