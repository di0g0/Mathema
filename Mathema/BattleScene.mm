//
//  BattleScene.mm
//  Mathema
//
//  Created by Diogo Henrique da Silva Costa on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "BattleScene.h"
#import "Util.h"

#define POSSIBLE_ANSWERS 6

@implementation BattleScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	BattleScene *layer = [BattleScene node];
    [scene addChild:layer];    
	// return the scene
    
	return scene;
}


-(double)getValue{
    return CCRANDOM_0_1() * 10;
}

-(NSArray *)generateAnswers{
    NSMutableArray *a = [[[NSMutableArray alloc] init] autorelease];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    for (int i = 0; i<POSSIBLE_ANSWERS; i++) {
        CircleAnswers *answer = [CircleAnswers spriteWithFile:@"Circle.png"];
        answer.value = [self getValue];//motor
//        answer.position = ccp((i+1)*40,230);
        float offsetFraction = ((float)(i+1))/(POSSIBLE_ANSWERS + 1);
        answer.position = ccp(winSize.width*offsetFraction, winSize.height/2);
        [self addChild:answer z:2];
        [a addObject:answer];
    }
    
    return a;
}
- (void)dealloc {
    [answers release];
    answers = nil;
    [super dealloc];
}
-(id) init
{
	if( (self=[super init])) {
		
        answers = [[NSArray alloc] initWithArray:[self generateAnswers]];
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        alvo1 = [CCSprite spriteWithFile:@"bullseye.png"];
        alvo1.position = ccp(200,200);
        [self addChild:alvo1 z:1];
        
        numbers = [[NSMutableArray alloc] init];
        for (int i = 0; i<3; i++) {
            NSString *string = (i == 1)?@"_":@"9";
            CCLabelTTF *valueLabel = [CCLabelTTF labelWithString:string fontName:@"Helvetica" fontSize:130];
            valueLabel.position = ccp(100 + (i* (valueLabel.contentSize.width + 30)),200);
            [self addChild:valueLabel z:1];
            [numbers addObject:valueLabel];            
        }

        
	}
	return self;
}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CircleAnswers * newSprite = nil;
    int i = 0;
    for (CircleAnswers *sprite in answers) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {            
            newSprite = sprite;
            NSLog(@"sprite selecionado na posicao: %i",i);
            i++;
            break;
        }
    }    
    if (newSprite != selectedAnswer) {
//        [selectedAnswer stopAllActions];
//        [selectedAnswer runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
//        CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
//        CCRotateTo * rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
//        CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
//        CCSequence * rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
//        [newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];            
        selectedAnswer = newSprite;
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];      
    return TRUE;    
}

- (void)panForTranslation:(CGPoint)translation {    
    if (selectedAnswer) {
        CGPoint newPos = ccpAdd(selectedAnswer.position, translation);
        selectedAnswer.position = newPos;
    } 
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {       
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);    
    [self panForTranslation:translation];    
}

//-(float)minimumContactArea:()

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if (selectedAnswer) {
        [selectedAnswer stopAllActions];
        	
        for (CCLabelTTF *label in numbers) {
            if ([Util pointDistanceBetween:label.position andPoint:selectedAnswer.position] < label.textureRect.size.width/2 + selectedAnswer.textureRect.size.width/2)
            {
                [selectedAnswer setPosition:label.position];
                break;
            }
            else 
            {
                /*Chip Go back*/
                //            chipMoving = TRUE;
                //            
                //            LX_MoveTo *move = [LX_MoveTo actionWithDestination:[betValButtons[[self indexForBetValue:[tempSptChip value]]] pos] duration:0.3f];
                //            LX_CallFunction *call = [LX_CallFunction actionWithSelector:@selector(removeTempChip) target:self];
                //            LX_ActionSequence *sequence = [LX_ActionSequence actionWithActionList:[NSArray arrayWithObjects:move, call, nil]];
                //            [tempSptChip runAction:sequence];
            }
        }
        
        
        selectedAnswer = nil;
    }
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    [self ccTouchEnded:touch withEvent:event];
}

@end
