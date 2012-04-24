//  This file was generated by LevelHelper
//  http://www.levelhelper.org
//
//  LevelHelperLoader.mm
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//  The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//  Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//  This notice may not be removed or altered from any source distribution.
//  By "software" the author refers to this code file and not the application 
//  that was used to generate this file.
//
////////////////////////////////////////////////////////////////////////////////
#import "LHAnimationNode.h"
#import "LevelHelperLoader.h"
#import "LHSettings.h"
#import "LHDictionaryExt.h"
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface LHAnimationFrameInfo : NSObject
{
    float   delayPerUnit;
    CGPoint offset;
    NSDictionary* notifications;
    NSString* spriteframeName;
    CGRect rect;
    bool rectIsRotated;
    CGPoint spriteFrameOffset;
    CGSize spriteFrameSize;
}

@property float delayPerUnit;
@property CGPoint offset;
@property (readonly) NSDictionary* notifications;
@property (readonly) NSString* spriteframeName;
@property (readonly) CGRect rect;
@property (readonly) bool rectIsRotated;
@property (readonly) CGPoint spriteFrameOffset;
@property (readonly) CGSize spriteFrameSize;

+(id)frameWithDictionary:(NSDictionary*)dictionary sprite:(LHSprite*)sprite;
@end

@implementation LHAnimationFrameInfo
@synthesize delayPerUnit;
@synthesize offset;
@synthesize notifications;
@synthesize spriteframeName;
@synthesize rect;
@synthesize rectIsRotated;
@synthesize spriteFrameOffset;
@synthesize spriteFrameSize;

-(void)dealloc{
    
#ifndef LH_ARC_ENABLED
    [notifications release];
    [spriteframeName release];
	[super dealloc];
#endif
}
-(id)initWithDictionary:(NSDictionary*)dictionary sprite:(LHSprite*)sprite
{
    self = [super init];    
    if (self != nil){
        
        delayPerUnit = [dictionary floatForKey:@"delayPerUnit"];
        offset = [dictionary pointForKey:@"offset"];
        
        notifications= [[NSDictionary alloc] initWithDictionary:[dictionary objectForKey:@"notifications"]];
        
        spriteframeName= [[NSString alloc] initWithString:[dictionary objectForKey:@"spriteframe"]];
        
        rect = [dictionary rectForKey:@"Frame"];
        rect = CC_RECT_POINTS_TO_PIXELS(rect);
        
        rect = [[LHSettings sharedInstance] transformedTextureRect:rect
                                                          forImage:[sprite imageFile]];
        
        spriteFrameOffset = [dictionary pointForKey:@"TextureOffset"];
        
        CGPoint tempOffset = spriteFrameOffset;
        
        tempOffset.x += offset.x;
        tempOffset.y -= offset.y;

        if(![[LHSettings sharedInstance] isHDImage:[sprite imageFile]]){
            tempOffset.x /= 2.0f;
            tempOffset.y /= 2.0f;
        }
        offset = tempOffset;
        
        
        rectIsRotated = [dictionary boolForKey:@"IsRotated"];
        
        
        spriteFrameSize = [dictionary sizeForKey:@"SpriteSize"];
    }
    return self;
}

+(id)frameWithDictionary:(NSDictionary*)dictionary sprite:(LHSprite*)sprite{
#ifndef LH_ARC_ENABLED
    return [[[self alloc] initWithDictionary:dictionary sprite:sprite] autorelease];
#else
    return [[self alloc] initWithDictionary:dictionary sprite:sprite];
#endif 
}
@end
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface LHAnimationNode (Private)

@end
////////////////////////////////////////////////////////////////////////////////
@implementation LHAnimationNode
@synthesize uniqueName;
@synthesize sheetName;
@synthesize delayPerUnit;
@synthesize loop;
@synthesize repetitions;
@synthesize restoreOriginalFrame;
@synthesize sprite;
@synthesize paused;
////////////////////////////////////////////////////////////////////////////////
-(void) dealloc{		
    
    //NSLog(@"LH Animation Dealloc");
#ifndef LH_ARC_ENABLED
    [uniqueName release];
    [sheetName release];
    [frames release];
    sprite = nil;
	[super dealloc];
#endif
}
////////////////////////////////////////////////////////////////////////////////
-(id) initWithDictionary:(NSDictionary*)dictionary onSprite:(LHSprite*)spr{

    self = [super init];
    if (self != nil)
    {
        uniqueName = [[NSString alloc] initWithString:[dictionary stringForKey:@"UniqueName"]];
        sheetName = [[NSString alloc] initWithString:[dictionary stringForKey:@"SheetName"]];
        restoreOriginalFrame = [dictionary boolForKey:@"RestoreOriginalFrame"];
        repetitions = [dictionary intForKey:@"Repetitions"];
        delayPerUnit = [dictionary floatForKey:@"DelayPerUnit"];
        sprite = spr;
        oldRect = [sprite textureRect];
        
        NSArray* framesInfo = [dictionary objectForKey:@"Frames"];
        
        frames = [[NSMutableArray alloc] init];
        for(NSDictionary* frmInfo in framesInfo){
            [frames addObject:[LHAnimationFrameInfo frameWithDictionary:frmInfo 
                                                                 sprite:sprite]];
        }       

        paused = true;
    }
    return self;
}

+(id) animationWithDictionary:(NSDictionary*)dic 
                     onSprite:(LHSprite*)sprite{
#ifndef LH_ARC_ENABLED
    return [[[self alloc] initWithDictionary:dic onSprite:sprite] autorelease];
#else
    return [[self alloc] initWithDictionary:dic onSprite:sprite];
#endif

}
-(void)setActiveFrameTexture
{
    if(nil == activeFrame) return;
                
    CCSpriteFrame* sprFrame = [CCSpriteFrame frameWithTexture:sprite.texture
                                                 rectInPixels:activeFrame.rect
                                                      rotated:activeFrame.rectIsRotated
                                                       offset:activeFrame.offset
                                                 originalSize:sprite.contentSize];
    
    [sprite setDisplayFrame:sprFrame];    
}

-(void)update:(ccTime)dt
{
    if(!activeFrame)
    {
        NSLog(@"ERROR: No active frame found in animation %@ on sprite %@", uniqueName, [sprite uniqueName]);
        return;
    }
    
    if(!paused)
        elapsedFrameTime += dt;
        
    if([activeFrame delayPerUnit]*delayPerUnit <= elapsedFrameTime){
        elapsedFrameTime = 0.0f;
        currentFrame++;
        if(currentFrame >= [frames count]){
            
            //we should trigger a notification that the animation has ended
            [[NSNotificationCenter defaultCenter] postNotificationName:LHAnimationHasEndedNotification
                                                                object:sprite
                                                              userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self, 
                                                                                                                                     sprite, nil]
                                                                                                   forKeys:[NSArray arrayWithObjects:LHAnimationObject, 
                                                                                                                                     LHAnimationSpriteObject, nil]]];
            if(loop){
                currentFrame = 0;
            }
            else {
                paused = true;
                currentFrame = [frames count] -1;
                
                //restore original frame is handled by stopAnimation
                
                //we should remove the animation from the sprite
                [sprite stopAnimation];
                return;
            }
        }
        
        activeFrame = [frames objectAtIndex:currentFrame];
        
        //check if this frame has any info and trigger a notification if it has
        if([[[activeFrame notifications] allKeys] count] > 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:LHAnimationFrameNotification
                                                                object:sprite
                                                              userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self, 
                                                                                                            sprite,
                                                                                                            [activeFrame notifications],
                                                                                                            [activeFrame spriteframeName], nil]
                                                                                                   forKeys:[NSArray arrayWithObjects:LHAnimationObject,    
                                                                                                                                     LHAnimationSpriteObject,
                                                                                                                                     LHAnimationUserInfo,
                                                                                                                                     LHAnimationFrameName, nil]]];
        }
        
        [self setActiveFrameTexture];
    }
}
//------------------------------------------------------------------------------
-(void)prepare
{
    currentFrame = 0;
    elapsedFrameTime = 0.0f;
    if([frames count] > 0)
        activeFrame = [frames objectAtIndex:0];
    else {
        activeFrame = nil;
    } 
    
    [self setActiveFrameTexture];
}
//------------------------------------------------------------------------------
-(void)play{
    paused = false;
}
//------------------------------------------------------------------------------
-(void)restart{
    [self prepare];
    [self play];
}
//------------------------------------------------------------------------------
-(int)numberOfFrames{
    return [frames count];
}
//------------------------------------------------------------------------------
-(void)setFrame:(int)frm{
    if(frm >= 0 && frm < [frames count]){
        currentFrame = frm;
    }
}
//------------------------------------------------------------------------------
-(int)currentFrame{
    return currentFrame;
}
//------------------------------------------------------------------------------
-(void) nextFrame{
    int curFrame = [self currentFrame];
    curFrame +=1;
    
    if(curFrame >= 0 && curFrame < [self numberOfFrames]){
        [self setFrame:curFrame];
    }    
}
//------------------------------------------------------------------------------
-(void) prevFrame{
    
    int curFrame = [self currentFrame];
    curFrame -=1;
    
    if(curFrame >= 0 && curFrame < (int)[self numberOfFrames]){
        [self setFrame:curFrame];
    }        
}
//------------------------------------------------------------------------------
-(void) nextFrameAndRepeat{
    
    int curFrame = [self currentFrame];
    curFrame +=1;
    
    if(curFrame >= [self numberOfFrames]){
        curFrame = 0;
    }
    
    if(curFrame >= 0 && curFrame < [self numberOfFrames]){
        [self setFrame:curFrame];
    }    
}
//------------------------------------------------------------------------------
-(void) prevFrameAndRepeat{
    
    int curFrame = [self currentFrame];
    curFrame -=1;
    
    if(curFrame < 0){
        curFrame = [self numberOfFrames] - 1;        
    }
    
    if(curFrame >= 0 && curFrame < (int)[self numberOfFrames]){
        [self setFrame:curFrame];
    }        
}
//------------------------------------------------------------------------------
-(bool) isAtLastFrame{
    return ([self numberOfFrames]-1 == [self currentFrame]);
}
//------------------------------------------------------------------------------
-(void)restoreFrame{
    if(!restoreOriginalFrame)return;
    
    if(oldBatch){
        [sprite removeFromParentAndCleanup:NO];
        [sprite setTexture:oldTexture];
        [oldBatch addChild:sprite z:[sprite zOrder]];
    }
    else if(oldTexture){
        [sprite setTexture:oldTexture];
    }
    [sprite setTextureRect:oldRect];
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
-(void)setOldBatch:(LHBatch*)b{
    oldBatch = b;
    oldTexture = [b texture];
}
-(void)setOldTexture:(CCTexture2D*)tex{
    oldTexture = tex;
    oldBatch = nil;
}
-(void)setOldRect:(CGRect)r{
    oldRect = r;
}
@end
