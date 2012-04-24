//
//  MathemaEngine.h
//  Mathema
//
//  Created by Diogo Henrique da Silva Costa on 17/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MathExpression.h"

#define kInitialRange 15
#define kNumberAlternatives 5

typedef enum{
    MathOpTypeSum = 0,
    MathOpTypeMult = 1
} MathOpType;


@interface MathemaEngine : NSObject{
    int esconder;
    NSString *conta[4];
    double alternativas[5];
//    private int escolha;
//    private int resultSoma;
//    private int min;
}

@property (nonatomic,assign) int range;
@property (nonatomic,assign) int minimum;

-(MathExpression *)getCalc;
@end
