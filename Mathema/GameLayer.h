//
//  GameLayer.h
//  SimpleBox2dScroller
//
//  Created by Diogo Henrique da Silva Costa on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactListener.h"

@class Player;

@interface GameLayer : CCLayer
{
    CGSize screenSize;
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	CCTMXTiledMap *tileMapNode;	
    Player *player;
    NSMutableArray *enemies;
    ContactListener *contactListener;
    double _playerVelX;
    BOOL gameOver;
    CCAction *_moveAction;
    BOOL _moving;
    
    
}

@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;

+(id) scene;
-(void)movePlayerFoward;
-(void)movePlayerBackward;
-(void)stopPlayer;
-(void)pause;


@end