//
//  InterfaceLayer.mm
//  SimpleBox2dScroller
//
//  Created by Diogo Henrique da Silva Costa on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InterfaceLayer.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"
#import "PauseLayer.h"

@implementation InterfaceLayer

-(id)initWithMainLayer:(GameLayer *)gameLayer
{
    
    if ((self = [super init])) {
        
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        mainLayer = gameLayer;
        
        SneakyButtonSkinnedBase *leftButton = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
        leftButton.position = ccp(winSize.width * 0.15,winSize.height * 0.05);
        leftButton.defaultSprite = [CCSprite spriteWithFile:@"bwButton.png"];
        leftButton.activatedSprite = [CCSprite spriteWithFile:@"bwButton_selected.png"];
        leftButton.pressSprite = [CCSprite spriteWithFile:@"bwButton_selected.png"];
        bwButton = [[SneakyButton alloc] initWithRect:leftButton.defaultSprite.textureRect];
        bwButton.isToggleable = NO;
        bwButton.isHoldable = YES;
        [bwButton setDelegate:self];
        [leftButton setButton:bwButton];
        [self addChild:leftButton];
        
        // Standard method to create a button
        SneakyButtonSkinnedBase *rightBut = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
        CGFloat x = leftButton.position.x + leftButton.defaultSprite.textureRect.size.width;
        rightBut.position = ccp(x,winSize.height * 0.05);
        rightBut.defaultSprite = [CCSprite spriteWithFile:@"fwButton.png"];
        rightBut.activatedSprite = [CCSprite spriteWithFile:@"fwButton_selected.png"];
        rightBut.pressSprite = [CCSprite spriteWithFile:@"fwButton_selected.png"];
        fwButton = [[SneakyButton alloc] initWithRect:rightBut.defaultSprite.textureRect];
        fwButton.isToggleable = NO;
        fwButton.isHoldable = YES;
        [fwButton setDelegate:self];
        [rightBut setButton:fwButton];
        [self addChild:rightBut];
        
//        CCMenu *pauseMenu = [CCMenu menuWithItems:[CCMenuItemImage itemFromNormalImage:@"pausebutton.png" selectedImage:@"pauseButton.png" block:^(id sender) {
//            NSLog(@"Pausando joguxo");
//            [mainLayer pause];
//        }], nil];
//        
//        [pauseMenu setPosition:ccp(winSize.width * 0.9, winSize.height * 0.9)];
//        [self addChild:pauseMenu];
    }
    return self;
}

- (void)restartTapped:(id)sender {
    
    // Reload the current scene
    CCScene *scene = [GameLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
    
}

- (void)quitTapped:(id)sender {
    
    // Reload the current scene
    CCScene *scene = [MainMenuScene scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
    
}


- (void)showRestartMenu:(BOOL)won {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    NSString *message;
    if (won) {
        message = @"You win!";
    } else {
        message = @"You lose!";
    }
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Helvetica" fontSize:60];
    
    //    CCLabelBMFont *label;
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial-hd.fnt"];
    //    } else {
    //        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
    //    }
    label.scale = 0.1;
    label.position = ccp(winSize.width/2, winSize.height * 0.6);
    [self addChild:label];
    
    CCLabelTTF *restartLabel = [CCLabelTTF labelWithString:@"Restart" fontName:@"Helvetica" fontSize:20];
    CCLabelTTF *quitLabel = [CCLabelTTF labelWithString:@"Quit Game" fontName:@"Helvetica" fontSize:20];
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        
    //        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial-hd.fnt"];    
    //    } else {
    //        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];    
    //    }
    
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
    restartItem.scale = 0.1;
    restartItem.position = ccp(winSize.width/2, winSize.height * 0.4);
    
    CCMenuItemLabel *quitItem = [CCMenuItemLabel itemWithLabel:quitLabel target:self selector:@selector(quitTapped:)];
    quitItem.scale = 0.1;
    quitItem.position = ccp(winSize.width/2, winSize.height * 0.3);
    
    CCMenu *menu = [CCMenu menuWithItems:restartItem,quitItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:10];
    
    [restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    [quitItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    [label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
}


#pragma mark - DirectionalButtonDelegate
-(void)directionalButtonPressed:(CCNode *)button{
    if (button == fwButton) {
        [mainLayer movePlayerFoward];
    }
    else if(button == bwButton){
        [mainLayer movePlayerBackward];
    }
}

-(void)directionalButtonReleased:(CCNode *)button{
    [mainLayer stopPlayer];
}


@end
