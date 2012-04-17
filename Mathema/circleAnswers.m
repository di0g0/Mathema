//
//  CircleAnswers.m
//  Mathema
//
//  Created by Diogo Henrique da Silva Costa on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CircleAnswers.h"

@implementation CircleAnswers
@synthesize value;

- (id)init {
    self = [super init];
    if (self) {
        valueLabel = [CCLabelTTF labelWithString:@"  " fontName:@"Helvetica" fontSize:18];
        [self addChild: valueLabel];
    }
    return self;
}
-(void)setValue:(double)v{
    if (value != v) {
        value = v;
        [valueLabel setString:[NSString stringWithFormat:@"%.f",value]];
        valueLabel.position = [self convertToNodeSpace:self.position];
    }
}


@end
