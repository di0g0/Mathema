//
//  BattleScene.m
//  SimpleBox2dScroller
//
//  Created by Diogo Costa on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BattleScene.h"

@interface BattleScene()
    
@end

@implementation BattleScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	BattleScene *layer = [BattleScene node];
    [scene addChild:layer];    
	// return the scene
    
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
        
	}
	return self;
}

@end
