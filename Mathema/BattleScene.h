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
    CircleAnswers *selectedAnswer;
    BOOL moving;
}

+(id)scene;

@end
