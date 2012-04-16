//
//  Player.mm
//  Mathema
//
//  Created by Diogo Henrique da Silva Costa on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Constants.h"

@implementation Player
@synthesize body,vel;
@synthesize walkAction,walking;
- (id) init {
	if ((self = [super init])) {
		type = kGameObjectPlayer;
        
        
	}
	return self;
}

-(void) createBox2dObject:(b2World*)world {
    b2BodyDef playerBodyDef;
	playerBodyDef.type = b2_dynamicBody;
	playerBodyDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
	playerBodyDef.userData = self;
	playerBodyDef.fixedRotation = true;
	
    
	body = world->CreateBody(&playerBodyDef);
	
    b2PolygonShape spriteShape;
    spriteShape.SetAsBox(self.contentSize.width/PTM_RATIO/2,
                         self.contentSize.height/PTM_RATIO/2);
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.density = kPlayerMass;
    spriteShapeDef.friction = 1.0;
    //    spriteShapeDef.isSensor = true;
    body->CreateFixture(&spriteShapeDef);
    
    //	b2CircleShape circleShape;
    //	circleShape.m_radius = 1.5f;
    //	b2FixtureDef fixtureDef;
    //	fixtureDef.shape = &circleShape;
    //     fixtureDef.density = kPlayerMass;
    ////	fixtureDef.density = 1.0f;
    //	fixtureDef.friction = 1.0f;
    //	fixtureDef.restitution =  0.0f;
    //	body->CreateFixture(&fixtureDef);
}

-(void) moveRight {
    b2Vec2 impulse = b2Vec2(7.0f, 0.0f);
    body->ApplyLinearImpulse(impulse, body->GetWorldCenter());		
}

-(void) jump {
    
    
    //    body->ApplyLinearImpulse(b2Vec2(0.0,kJumpImpulse), body->GetWorldCenter());
    
    body->ApplyLinearImpulse(b2Vec2(kVel/PTM_RATIO, 10), body->GetWorldCenter());
    
    //    b2Vec2 impulse = b2Vec2(4.0f, 15.0f);
    
    //    body->ApplyLinearImpulse(impulse, body->GetWorldCenter());		    
}

- (void)updatePlayer:(ccTime)dt {
    if (self.vel != 0) {
        if (!walking) {
            [self runAction:self.walkAction];
            walking = TRUE;
        }
        
        b2Vec2 b2Vel = body->GetLinearVelocity();
        b2Vel.x = self.vel / PTM_RATIO;
        body->SetLinearVelocity(b2Vel);    
    }
    
    //        if (_numGroundContacts > 0 && CACurrentMediaTime() - _lastGround > 0.25) {
    //            _lastGround = CACurrentMediaTime();
    //            [[SimpleAudioEngine sharedEngine] playEffect:@"ground.wav"];
    //            if ([_hero numberOfRunningActions] == 0) {
    //                [_lhelper startAnimationWithUniqueName:@"Walk" onSprite:_hero];
    //            }
    //        }
    
    //    } else if (_playerVelX == 0 && _numGroundContacts > 0) {
    //        [_lhelper stopAnimationWithUniqueName:@"Walk" onSprite:_hero];
    //    }
    
    
}


-(void)setVel:(double)v{
    if (vel != v) {
        vel = v;
        if (vel == 0) {
            [self stopAction:walkAction];
            walking = FALSE;
        } else if (vel > 0){
            self.flipX = YES;
        }else{
            self.flipX = NO;
        }
    }
}

@end