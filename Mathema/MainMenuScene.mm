//
//  MainMenuScene.m
//  SimpleBox2dScroller
//
//  Created by Diogo Costa on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"
#import "ConfigLayer.h"
#import "GameLayer.h"

@interface MainMenuScene()

- (void)playTapped:(id)sender;
- (void)configTapped:(id)sender;

@end

@implementation MainMenuScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	MainMenuScene *layer = [MainMenuScene node];
    [scene addChild:layer];    
	// return the scene
    
	return scene;
}

-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)])) {
		
        if([[GameConfig sharedGame] musicEnabled]){
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Tema2.m4a" loop:YES];            
        }
        
		// enable touches
        //	self.isTouchEnabled = YES;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCLabelTTF *playLabel = [CCLabelTTF labelWithString:@"Play" fontName:@"Helvetica" fontSize:50];
        [playLabel setColor:ccc3(0, 0, 0)];
        
        CCMenuItemLabel *playItem = [CCMenuItemLabel itemWithLabel:playLabel target:self selector:@selector(playTapped:)];
        playItem.position = ccp(winSize.width/2, winSize.height * 0.6);
        
        CCLabelTTF *configLabel = [CCLabelTTF labelWithString:@"About" fontName:@"Helvetica" fontSize:50];
        [configLabel setColor:ccc3(0, 0, 0)];
        
        CCMenuItemLabel *configItem = [CCMenuItemLabel itemWithLabel:configLabel target:self selector:@selector(configTapped:)];
        configItem.position = ccp(winSize.width/2, playItem.position.y - playLabel.textureRect.size.height);
        
        CCMenuItemImage *configImageItem = [CCMenuItemImage itemFromNormalImage:@"config.png" selectedImage:@"config-selected.png" block:^(id sender) {
            CCScene *scene = [ConfigLayer scene];
            [[CCDirector sharedDirector] pushScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:scene]];
        }];
        configImageItem.position = ccp(winSize.width * 0.9, winSize.height * 0.85);
        
        CCMenu *menu = [CCMenu menuWithItems:playItem,configItem,configImageItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu z:10];
        
        
        
	}
	return self;
}

-(void)configTapped:(id)sender{
    NSLog(@"Vai para tela de config");
    CCScene *scene = [ConfigLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:0.5 scene:scene]];
    
}

- (void)playTapped:(id)sender {
    
    // Reload the current scene
    CCScene *scene = [GameLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:0.5 scene:scene]];
    
}

@end

