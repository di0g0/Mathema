//
//  MathemaEngine.m
//  Mathema
//
//  Created by Diogo Henrique da Silva Costa on 17/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MathemaEngine.h"
#import "NSArray+ShuffleArray.h"

@interface MathemaEngine() 

-(NSArray*)generateAlternativesToUnknown:(int)x;
-(int)generateNumberOfAlgarisms;
-(double)generateResultWithNumbers:(NSArray *)numbers andOperators:(NSArray *)ops;


@end
@implementation MathemaEngine
@synthesize range,minimum;

- (id)init
{
    self = [super init];
    if (self) {
        self.range = kInitialRange;
        self.minimum = 0;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(int) randomNumberBetweenMin:(int)min andMax:(int)max
{
	return ( (arc4random() % (max-min+1)) + min );
}

-(int)randomNumberLowerThan:(int)n{
    return (arc4random() % (n+1));
}

double calculateResult(int n1, int n2, MathOpType op){
    return (op == MathOpTypeSum) ? (n1 + n2) : (n1 * n2);
}

///*Gera o calculo aleatoriamente*/
-(MathExpression *)getCalc{
    MathExpression *cont = [[MathExpression alloc] init];

    int expressionSize = [self generateNumberOfAlgarisms];
    NSLog(@"tamanho da conta: %i",expressionSize);
    
    cont.numeros = [[NSMutableArray alloc] initWithCapacity:expressionSize];
    cont.operadores = [[NSMutableArray alloc] initWithCapacity:expressionSize - 1];
    
    
    double result;
    MathOpType op = [self randomNumberLowerThan:1];
    for (int i = 0; i<expressionSize; i++) {
        [cont.numeros addObject:[NSNumber numberWithInt:[self randomNumberBetweenMin:self.minimum andMax:self.range]]];
        if (i != expressionSize - 1) {

            [cont.operadores addObject: [NSNumber numberWithInt:op]];            
        }
        
    }
    
    result = [self generateResultWithNumbers:cont.numeros andOperators:cont.operadores];
    [cont.numeros addObject:[NSNumber numberWithDouble:result]];
    
    
    cont.indexIncognita = [self randomNumberLowerThan:expressionSize];
    int incognita = [[cont.numeros objectAtIndex:cont.indexIncognita] intValue];
    cont.alternativas = [[NSMutableArray alloc] initWithArray: [self generateAlternativesToUnknown: incognita]];
    cont.indexCorreta = [cont.alternativas indexOfObject:[NSNumber numberWithInt:incognita]];
    
    return cont;

}


///* MÈtodo para "jogar", tentando acertar qual o numero completa o calculo*/
//

//private String simbOp(int auxOp){
//    String simb = "?";
//    
//    if(auxOp == 1)
//        simb = "+";
//    else if (auxOp == 2)
//        simb = "*";
//    
//    return simb;		
//}
///*Calcula o resultado, de acordo com os numeros e o operador sorteados*/
//private int calcResult(int n1, int auxOp, int n2){
//    int x = -1;
//    if(auxOp == 1)
//        x=n1+n2;
//    else if (auxOp == 2)
//        x=n1*n2;
//    
//    return x;
//}



//private void playSoma(int n1, int op, int n2, int resultado){
//    int continuarSoma = 1;
//    /*sortear qual dos elementos ser· ocultado*/
//    /* No array Conta: num1, num2, resultado, operador*/
//    conta[0] = Integer.toString(n1);
//    conta[1] = Integer.toString(n2);
//    conta[2] = Integer.toString(resultado);
//    conta[3] = simbOp(op);
//    this.esconder = randomNum(3);
//    this.incognita = Integer.parseInt(conta[esconder-1]);/*armazenando o valor*/
//    conta[esconder-1] = "X";
//    /* imprimir na sequencia: [0]num1, [3]operador, [1]num3, [2]resultado*/
//    System.out.println(conta[0]+" "+conta[3]+" "+conta[1]+" = "+conta[2]);
//    System.out.println("X = "+incognita);
//    
//    /*gerar alternativas para a resposta*/
//    alternativas = gerarAlternativasSoma(incognita);
//    //System.out.println("teste"+alternativas[0]);
//    resultSoma = 0;
//    double qtdSomas = 0, qtdIdeal = 0;
//    int result=0, i = 0, j = 0, aux = 0, auxAlt[] = new int[5];
//    auxAlt = alternativas;
//    do{		
//        System.out.println("j="+j+" vetor: "+auxAlt[0]+" "+auxAlt[1]+" "+auxAlt[2]+" "+auxAlt[3]+" "+auxAlt[4]+" ");
//        for(i = j; i < 5; i++ ){//primeiro pega a maior alternativa, e vai ordenando o vetor
//            if(auxAlt[i]> aux){
//                aux = auxAlt[i];
//                auxAlt[i]= auxAlt[j];
//                auxAlt[j] = aux;
//            }
//        }
//        j++;
//        
//        while(result+aux <= incognita){
//            result+=aux;
//            qtdIdeal++;
//            System.out.println("Result = "+result+" Resulto desejado = "+incognita+" Qtd Ideal de somas = "+qtdIdeal);
//        }
//        aux=0;
//    }while(result < incognita);
//    
//    
//    
//    do {
//        /////////////////////////////////////
//        
//        escolha = Integer.parseInt(JOptionPane.showInputDialog("Calculo: "+conta[0]+" "+conta[3]+" "+conta[1]+" = "+conta[2]+"\n"+
//                                                               "Alternativas: "+
//                                                               "\n1)"+alternativas[0]+
//                                                               "\n2)"+alternativas[1]+
//                                                               "\n3)"+alternativas[2]+
//                                                               "\n4)"+alternativas[3]+
//                                                               "\n5)"+alternativas[4]+
//                                                               "\n\nEscolha o numero a ser somado ‡ incognita "));
//        //System.out.println("opÁ„o escolhida = "+escolha+" resposta correta = "+incognita);
//        
//        //conta[esconder-1] = "X";
//        
//        
//        //System.out.println("Somando:\n Atual = "+resultSoma+" + escolha: "+alternativas[escolha-1]);
//        if(escolha >= 1 && escolha <=5){
//            resultSoma = resultSoma+alternativas[escolha-1];
//            qtdSomas++;
//        }
//        else
//            JOptionPane.showMessageDialog(null, "Entre com uma alternativa v·lida entre 1 e 5!");
//        //System.out.println("Resultado da soma:"+resultSoma);
//        
//        if(resultSoma == incognita){
//            conta[esconder-1] = "[ "+Integer.toString(resultSoma)+" ]";
//            JOptionPane.showMessageDialog(null, "Voce acertou!\n  Sua Resposta final foi: "+conta[0]+" "+conta[3]+" "+conta[1]+" = "+conta[2]+"\nVocÍ Realizou "+qtdSomas+" somas."+"\nA quantidade ideal de somas para completar a resposta era "+qtdIdeal+"\nSua pontuaÁ„o foi de "+(qtdIdeal/qtdSomas)*100+"%");
//            continuarSoma = 0;
//            rangeUp();//Aumenta o range conforme acerta
//        }
//        else if(resultSoma > incognita){
//            conta[esconder-1] = "[ "+Integer.toString(resultSoma)+" ]";
//            JOptionPane.showMessageDialog(null, "Voce ERROU!\nSua Resposta final foi: "+conta[0]+" "+conta[3]+" "+conta[1]+" = "+conta[2]+"\n A resposta correta era: "+incognita+"\nVocÍ Realizou "+qtdSomas+" somas."+"\nA quantidade ideal de somas para completar a resposta era "+qtdIdeal);
//            continuarSoma = 0;
//        }
//        else{ //menor
//            //			continuarSoma = 1;
//            conta[esconder-1] = "[ "+Integer.toString(resultSoma)+" + X ]";
//        }
//        ////////////////////////////////////////
//    }
//    while(continuarSoma == 1);
//}
//


//private int[] gerarAlternativasSoma(int altcorreta){
//    int[] aux = new int[5];
//    int flag = 0;
//    int num, contem = 0,j = 0;
//    System.out.println("Gerando alternativas(soma)");
//    j=2;
//    aux[0]=1;
//    aux[1]=2;
//    //while(flag == 0 && j < 4){
//    while(flag == 0 && j < 5){//n„o tem "alt correta"
//        if (altcorreta >= 15)
//            num = randomNum(altcorreta/2);
//        else if(altcorreta>5 && altcorreta < 15)
//            num = randomNum(altcorreta-1);
//        else
//            num = randomNum(altcorreta);
//        //num = randomNum(4)+2;//min /3 max /6
//        //	num = altcorreta/num;
//        for(int i=0; i <5; i++){
//            if (aux[i] == num)
//                contem = 1;
//        }
//        if(contem == 0){
//            aux[j] = num;
//            j++;
//        }
//        else
//            contem = 0;
//    }
//    //aux[4] = altcorreta;
//    /*	System.out.println(	"\na)"+aux[0]+
//     "\nb)"+aux[1]+
//     "\nc)"+aux[2]+
//     "\nd)"+aux[3]+
//     "\ne)"+aux[4]);
//     */
//    
//    /* "Embaralhando" */
//    /*int a,b;
//     a = randomNum(5)-1;
//     if(a != 4){
//     b = aux[a];
//     aux[a] = aux[4];
//     aux[4] = b;
//     }*/
//    System.out.println("Alternativas finalizadas");
//    return aux;
//}

-(double)generateResultWithNumbers:(NSArray *)numbers andOperators:(NSArray *)ops{
    double result = -1;
    int i = 0;
    int opIndex = 0;
    while (i<[numbers count]) {
        MathOpType op = [[ops objectAtIndex:opIndex] intValue];
        opIndex++;
        if (result ==  -1) {
            result = (op == MathOpTypeSum)?[[numbers objectAtIndex:i] intValue] + [[numbers objectAtIndex:i+1] intValue]:[[numbers objectAtIndex:i] intValue] * [[numbers objectAtIndex:i+1] intValue];
            i+=2;
        }else{
            result = (op == MathOpTypeSum)?result + [[numbers objectAtIndex:i] intValue] : result * [[numbers objectAtIndex:i] intValue];
            i++;
        }

    }
    
    NSLog(@"Numeros: %@",numbers);
    NSLog(@"op: %@",ops);
    NSLog(@"result: %f",result);
    return result;
}


-(int)generateNumberOfAlgarisms{
    //Lógica de tamanho da conta de acordo com o desempenho do jogador vai aqui
    return [self randomNumberBetweenMin:2 andMax:3];

}
-(NSArray*)generateAlternativesToUnknown:(int)x{
    NSMutableArray *answers = [[[NSMutableArray alloc] init] autorelease];
    int aux,index = 0;
    [answers addObject:[NSNumber numberWithInt:x]];
    while (index < kNumberAlternatives - 1) {
        aux = [self randomNumberBetweenMin:self.minimum andMax:self.range];
        BOOL isNewAnswer = TRUE;
        for (NSNumber *n  in answers) {
            if ([n intValue] == aux) {
                isNewAnswer = FALSE; break;
            }
        }
        if (isNewAnswer) {
            [answers addObject:[NSNumber numberWithInt:aux]];
            index++;
        }
        
    }
    [answers shuffle];
    return answers;
}
@end
