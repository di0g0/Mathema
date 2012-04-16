//
//  GameObject.m
//  Mathema
//
//  Created by Diogo Henrique da Silva Costa on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject
@synthesize type;

- (id)init
{
    self = [super init];
    if (self) {
        type = kGameObjectNone;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
