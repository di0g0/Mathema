//
//  ConfigLayer.h
//  SimpleBox2dScroller
//
//  Created by Diogo Henrique da Silva Costa on 26/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "cocos2d.h"
#import "MainMenuScene.h"

@interface ConfigLayer : CCLayerColor{
    CCMenuItemImage *on;
    CCMenuItemImage *off;
}

+(id)scene;

@end
