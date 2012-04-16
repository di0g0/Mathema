//
//  PauseLayer.h
//  SimpleBox2dScroller
//
//  Created by Diogo Henrique da Silva Costa on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface PauseLayerProtocol: CCNode 

-(void)pauseLayerDidPause;
-(void)resumeLayer;

@end

@interface PauseLayer : CCLayerColor {
    
}

@property (nonatomic,assign)PauseLayerProtocol * delegate;
+ (id) layerWithColor:(ccColor4B)color delegate:(CCNode *)_delegate;
- (id) initWithColor:(ccColor4B)c delegate:(PauseLayerProtocol *)_delegate;

@end