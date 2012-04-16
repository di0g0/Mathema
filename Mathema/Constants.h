//
//  Constants.h
//  SimpleBox2dScroller
//
//  Created by min on 3/17/11.
//  Copyright 2011 Min Kwon. All rights reserved.
//

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
#define kVel 80.0

#define kGameLayerTag 1001

#define kWorldGravity   -25.0
#define kJumpImpulse   -0.85*kWorldGravity
#define kPlayerMass   1.0



typedef enum {
    kGameObjectNone,
    kGameObjectPlayer,
    kGameObjectEnemy,
    kGameObjectPlatform
} GameObjectType;