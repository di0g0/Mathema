//
//  InterfaceLayer.h
//  SimpleBox2dScroller
//
//  Created by Diogo Henrique da Silva Costa on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "GameLayer.h"

@interface InterfaceLayer : CCLayer <DirectionalButtonDelegate>{
    SneakyButton *fwButton;
    SneakyButton *bwButton;
    GameLayer *mainLayer;
}
-(id)initWithMainLayer:(GameLayer *)gameLayer;
- (void)showRestartMenu:(BOOL)won;
@end
