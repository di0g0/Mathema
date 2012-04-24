//
//  LHFixture.mm
//
//  Created by Bogdan Vladu on 4/3/12.
//  Copyright (c) 2012 Bogdan Vladu. All rights reserved.
//

#import "LHFixture.h"
#import "LHDictionaryExt.h"
#import "LHSettings.h"
#import "LevelHelperLoader.h"
#import "LHSprite.h"

@implementation LHFixture

@synthesize fixtureName;
@synthesize fixtureID;
//------------------------------------------------------------------------------
-(b2Vec2)transformPoint:(CGPoint)point sprite:(LHSprite*)sprite offset:(CGPoint)offset scale:(CGPoint)scale
{
    float ptm = [[LHSettings sharedInstance] lhPtmRatio];

//    point.x *= [[LHSettings sharedInstance]  convertRatio].x;
//	point.y *= [[LHSettings sharedInstance]  convertRatio].y;
    
    point.x *= scale.x;
    point.y *= scale.y;
    
    if([[LHSettings sharedInstance] isHDImage:[sprite imageFile]])
    {
        point.x *=2.0f;
        point.y *=2.0f;
    }
    
    point.x += offset.x;
    point.y -= offset.y;
    
    point.x -= sprite.contentSize.width/2*scale.x;
    point.y = sprite.contentSize.height/2*scale.y - point.y;
    
    point.x += sprite.offsetPositionInPixels.x*scale.x/CC_CONTENT_SCALE_FACTOR();
    point.y -= sprite.offsetPositionInPixels.y*scale.y/CC_CONTENT_SCALE_FACTOR();
    
    return b2Vec2(point.x/ptm, point.y/ptm);
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
-(id)initWithDictionary:(NSDictionary*)dictionary 
                   body:(b2Body*)body
                    sprite:(LHSprite*)sprite{

    self = [super init];
    if (self != nil){

        fixtureName = [[NSString alloc] initWithString:[dictionary stringForKey:@"Name"]];
        fixtureID   = [dictionary intForKey:@"Tag"];
                
        int category = [dictionary intForKey:@"Category"];
        int group = [dictionary intForKey:@"Group"];
        int mask = [dictionary intForKey:@"Mask"];
        
        float density = [dictionary floatForKey:@"Density"];
        float friction = [dictionary floatForKey:@"Friction"];
        float restitution= [dictionary floatForKey:@"Restitution"];
        
        bool isCircle = [dictionary boolForKey:@"IsCircle"];
        bool isSensor = [dictionary boolForKey:@"IsSensor"];
        
        CGPoint offset = [dictionary pointForKey:@"ShapePositionOffset"];
        
        float width = [dictionary floatForKey:@"Width"];
        //float height= [dictionary floatForKey:@"Height"];
        
        NSArray* fixturePoints = [dictionary objectForKey:@"Fixture"];
        
        float ptm = [[LHSettings sharedInstance] lhPtmRatio];
        
        CGPoint scale = ccp(sprite.scaleX,sprite.scaleY);
        
        for(int i = 0; i < [fixturePoints count]; i += 3)
        {
            CGPoint pt0 = CGPointFromString([fixturePoints objectAtIndex:i+0]);
            CGPoint pt1 = CGPointFromString([fixturePoints objectAtIndex:i+1]);
            CGPoint pt2 = CGPointFromString([fixturePoints objectAtIndex:i+2]);
            
            b2Vec2 *verts = new b2Vec2[3];
            b2PolygonShape shapeDef;

            verts[0] = [self transformPoint:pt0 sprite:sprite offset:offset scale:scale];
            verts[1] = [self transformPoint:pt1 sprite:sprite offset:offset scale:scale];
            verts[2] = [self transformPoint:pt2 sprite:sprite offset:offset scale:scale];
                        
            shapeDef.Set(verts, 3);		
            
            b2FixtureDef fixture;
            //------------------------------------------------------------------
            fixture.density = density;
            fixture.friction = friction;
            fixture.restitution = restitution;
            
            fixture.filter.categoryBits = category;
            fixture.filter.maskBits = mask;
            fixture.filter.groupIndex = group;
            
            fixture.isSensor = isSensor;
            fixture.userData = self;
            //------------------------------------------------------------------            
            fixture.shape = &shapeDef;
            body->CreateFixture(&fixture);
            delete[] verts;
        }
            
        //handle isCircle and quads
        if([fixturePoints count] == 0)
        {
            b2PolygonShape shape;
            b2FixtureDef fixture;
            b2CircleShape circle;

            //------------------------------------------------------------------
            fixture.density = density;
            fixture.friction = friction;
            fixture.restitution = restitution;
            
            fixture.filter.categoryBits = category;
            fixture.filter.maskBits = mask;
            fixture.filter.groupIndex = group;
            
            fixture.isSensor = isSensor;
            fixture.userData = self;
            //------------------------------------------------------------------            

            if(isCircle)
            {
                if([[LHSettings sharedInstance] convertLevel])
                {
                    //circle look weird if we dont do this
                    float scaleSpr = [sprite scaleX];
                    [sprite setScaleY:scaleSpr];
                }
                
                float circleScale = scale.x; //if we dont do this we dont have collision
                if(circleScale < 0)
                    circleScale = -circleScale;
                
                float radius = (width/2.0f*circleScale)/ptm;
                
                if(![[LHSettings sharedInstance] isHDImage:[sprite imageFile]]){
                    radius /=2.0f;
                }

                
                if(radius < 0)
                    radius *= -1;
                circle.m_radius = radius; 
                
                CGPoint origin = ccp(offset.x, offset.y);

                if(![[LHSettings sharedInstance] isHDImage:[sprite imageFile]]){
                    origin.x /=2.0f;
                    origin.y /=2.0f;
                }

                origin.x -= sprite.contentSize.width/2;
                origin.y = sprite.contentSize.height/2 - origin.y;
                
                origin.x += sprite.offsetPositionInPixels.x/CC_CONTENT_SCALE_FACTOR();
                origin.y -= sprite.offsetPositionInPixels.y/CC_CONTENT_SCALE_FACTOR();

                
                circle.m_p.Set(origin.x/ptm,
                               origin.y/ptm);
                
                fixture.shape = &circle;
                body->CreateFixture(&fixture);
            }
            else
            {
                //this is for the case where no shape is defined and user selects the sprite to have physics inside LH
                b2PolygonShape shape;
                
                float boxWidth = sprite.contentSize.width*sprite.scaleX*CC_CONTENT_SCALE_FACTOR();
                float boxHeight= sprite.contentSize.height*sprite.scaleY*CC_CONTENT_SCALE_FACTOR();
                
                if(![[LHSettings sharedInstance] isHDImage:[sprite imageFile]]){
                    boxWidth /=2.0f;
                    boxHeight/=2.0f;
                }
                
                shape.SetAsBox(boxWidth/ptm, 
                               boxHeight/ptm);
                                
                fixture.shape = &shape;
                body->CreateFixture(&fixture);
            }
        }                
    }
    return self;
}
+(id)fixtureWithDictionary:(NSDictionary*)dictionary 
                      body:(b2Body*)body                     
                    sprite:(LHSprite*)sprite
{
#ifndef LH_ARC_ENABLED
    return [[[self alloc] initWithDictionary:dictionary body:body sprite:sprite] autorelease];
#else
    return [[self alloc] initWithDictionary:dictionary body:body sprite:sprite];
#endif     
}
//------------------------------------------------------------------------------
-(void)dealloc{

    NSLog(@"LH FIXTURE DEALLOC");
#ifndef LH_ARC_ENABLED
    [fixtureName release];
	[super dealloc];
#endif
}
//------------------------------------------------------------------------------
@end
