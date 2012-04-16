//
//  Player.h
//  Mathema
//
//  Created by Diogo Henrique da Silva Costa on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GameObject.h"

@interface Player : GameObject {
    b2Body          *body;
}

- (void)updatePlayer:(ccTime)dt;
-(void) createBox2dObject:(b2World*)world;
-(void) jump;
-(void) moveRight;

@property (nonatomic, readwrite) b2Body *body;
@property (nonatomic) double vel;
@property (nonatomic) BOOL walking;
@property (nonatomic, retain) CCAction *walkAction;


@end
