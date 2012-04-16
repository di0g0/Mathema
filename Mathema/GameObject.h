//
//  GameObject.h
//  Mathema
//
//  Created by Diogo Henrique da Silva Costa on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Constants.h"

@interface GameObject : CCSprite {
    GameObjectType  type;
}

@property (nonatomic, readwrite) GameObjectType type;
@end
