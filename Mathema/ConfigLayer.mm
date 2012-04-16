//
//  ConfigLayer.m
//  SimpleBox2dScroller
//
//  Created by Diogo Henrique da Silva Costa on 26/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ConfigLayer.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"

@implementation ConfigLayer
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	ConfigLayer *layer = [ConfigLayer node];
    [scene addChild:layer];    
	// return the scene
    
	return scene;
}

-(void)soundButtonTapped:(id)sender{
    CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    if (toggleItem.selectedItem == on) {
        [GameConfig sharedGame].musicEnabled = YES;
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Tema2.m4a" loop:YES];
        
    } else {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [GameConfig sharedGame].musicEnabled = NO;        
    }
}

-(void)backTapped:(id)sender{
    
    [self removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.4 scene:[MainMenuScene scene]]];
    
}
-(id)init
{
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
	if( (self=[super initWithColor:ccc4(0, 0, 0, 255) width:winSize.width height:winSize.height])) {
        // enable touches
		//self.isTouchEnabled = YES;
        
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"Config" fontName:@"Helvetica" fontSize:40];
        titleLabel.position = ccp(winSize.width/2, winSize.height * 0.9);
        [self addChild:titleLabel];
        
        CCLabelTTF *backLabel = [CCLabelTTF labelWithString:@"Back" fontName:@"Helvetica" fontSize:30];
        CCMenuItemLabel *back = [CCMenuItemLabel itemWithLabel:backLabel target:self selector:@selector(backTapped:)];
        back.position = ccp(50,winSize.height *  0.9);
        
        CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = CGPointZero;
        [self addChild:backMenu];
        
        
        CCLayerColor *menuLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 70) width:winSize.width * 0.6 height:winSize.height * 0.6];
        menuLayer.position = ccp((winSize.width - menuLayer.contentSize.width)/2,(winSize.height - menuLayer.contentSize.height)/2 - 30);
        [self addChild:menuLayer];
        
        
        CCLabelTTF *soundLabel = [CCLabelTTF labelWithString:@"Sound" fontName:@"Helvetica" fontSize:25];
        soundLabel.position = ccp(20 + soundLabel.contentSize.width/2, menuLayer.contentSize.height - soundLabel.contentSize.height - 20);
        [menuLayer addChild:soundLabel];
        
        CCLabelTTF *langLabel = [CCLabelTTF labelWithString:@"Language:" fontName:@"Helvetica" fontSize:25];
        langLabel.position = ccp(20 + langLabel.contentSize.width/2, soundLabel.position.y - soundLabel.contentSize.height - 10);
        [menuLayer addChild:langLabel];
        
        
        on = [[CCMenuItemImage itemFromNormalImage:@"som_on.PNG" 
                                     selectedImage:@"som_on.PNG" target:nil selector:nil] retain];
        
        off = [CCMenuItemImage itemFromNormalImage:@"som_off.PNG" 
                                     selectedImage:@"som_off.PNG" target:nil selector:nil];
        CCMenuItemToggle *toggleItem = [CCMenuItemToggle itemWithTarget:self 
                                                               selector:@selector(soundButtonTapped:) items:on, off , nil];
        toggleItem.position = ccp(soundLabel.position.x + soundLabel.textureRect.size.width , soundLabel.position.y);
        
        toggleItem.selectedIndex = ![[GameConfig sharedGame] musicEnabled];
        CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
        toggleMenu.position = CGPointZero;
        [menuLayer addChild:toggleMenu];
        
    }
    return self;
}

@end
