//
//  PauseLayer.m
//  SimpleBox2dScroller
//
//  Created by Diogo Henrique da Silva Costa on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PauseLayer.h"

@implementation PauseLayer
@synthesize delegate;


+ (id) layerWithColor:(ccColor4B)color delegate:(id)_delegate
{
	return [[[self alloc] initWithColor:color delegate:_delegate] autorelease];
}

- (id) initWithColor:(ccColor4B)c delegate:(id)_delegate 
{
    if ((self = [super initWithColor:c]))
    {
        delegate = _delegate;

        self.isTouchEnabled=YES;
        
        CCLabelTTF *resumeLabel = [CCLabelTTF labelWithString:@"Resume" fontName:@"Helvetica" fontSize:40];
        CCMenuItemLabel *resumeItem = [CCMenuItemLabel itemWithLabel:resumeLabel block:^(id sender) {
            [delegate onEnter];
            [self.parent removeChild:self cleanup:YES];
        }];
        resumeLabel.position = self.position;
        CCMenu *pauseMenu = [CCMenu menuWithItems:resumeItem, nil];

        [self addChild:pauseMenu];
  
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end