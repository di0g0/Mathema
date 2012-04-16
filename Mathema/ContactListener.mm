//
//  ContactListener.m
//  Mathema
//
//  Created by Diogo Henrique da Silva Costa on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactListener.h"
#import "Constants.h"
#import "GameObject.h"

#define IS_PLAYER(x, y)         (x.type == kGameObjectPlayer || y.type == kGameObjectPlayer)
#define IS_PLATFORM(x, y)       (x.type == kGameObjectPlatform || y.type == kGameObjectPlatform)


ContactListener::ContactListener() {
}

ContactListener::~ContactListener() {
}

void ContactListener::BeginContact(b2Contact *contact) {
	GameObject *o1 = (GameObject*)contact->GetFixtureA()->GetBody()->GetUserData();
	GameObject *o2 = (GameObject*)contact->GetFixtureB()->GetBody()->GetUserData();
	
	if (IS_PLATFORM(o1, o2) && IS_PLAYER(o1, o2)) {
        CCLOG(@"-----> Player made contact with platform!");
    }
}

void ContactListener::EndContact(b2Contact *contact) {
	GameObject *o1 = (GameObject*)contact->GetFixtureA()->GetBody()->GetUserData();
	GameObject *o2 = (GameObject*)contact->GetFixtureB()->GetBody()->GetUserData();
    
	if (IS_PLATFORM(o1, o2) && IS_PLAYER(o1, o2)) {
        CCLOG(@"-----> Player lost contact with platform!");
    }
}

void ContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold) {
}

void ContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse *impulse) {
}
