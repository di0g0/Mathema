//
//  MathExpression.h
//  Mathema
//
//  Created by Diogo Henrique da Silva Costa on 17/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathExpression : NSObject
/*
    array de strings, sendo a ultima sempre o resultado. 
    int incognita (indice do que está sendo escondido)
    array de alternativas 
    int correta (indice da certa)
 
 */

@property (nonatomic,retain) NSMutableArray *numeros;
@property (nonatomic,assign) int indexIncognita;
@property (nonatomic,retain) NSMutableArray *operadores;
@property (nonatomic, retain) NSMutableArray *alternativas;
@property (nonatomic,assign) int indexCorreta;


@end
