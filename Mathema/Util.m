//
//  Util.m
//  Mathema
//
//  Created by Diogo Costa on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Util.h"

@implementation Util

+(float) pointDistanceBetween:(CGPoint)pt1 andPoint:(CGPoint) pt2;
{
	return sqrtf( ((pt1.x-pt2.x)*(pt1.x-pt2.x))+((pt1.y-pt2.y)*(pt1.y-pt2.y)) );
}

@end
