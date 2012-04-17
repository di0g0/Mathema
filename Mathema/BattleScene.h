//
//  BattleScene.h
//  Mathema
//
//  Created by Diogo Henrique da Silva Costa on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CircleAnswers.h"

@interface BattleScene : CCLayer{
    NSArray *answers;
    NSMutableArray *numbers;
    
    
    CircleAnswers *selectedAnswer;
    BOOL moving;
    CCSprite *alvo1;
    
}

+(id)scene;

@end
