//
//  HelloWorldScene.mm
//  SimpleBox2dScroller
//
//  Created by min on 1/13/11.
//  Copyright Min Kwon 2011. All rights reserved.
//



#import "GameLayer.h"
#import "GameScene.h"
#import "Constants.h"
#import "Player.h"
#import "GameObject.h"
#import "InterfaceLayer.h"
#import "SimpleAudioEngine.h"
#import "GameConfig.h"
#import "PauseLayer.h"

@interface GameLayer() 
@property (nonatomic,retain) InterfaceLayer *interfaceLayer;

-(void) setupPhysicsWorld;
@end

@implementation GameLayer
@synthesize interfaceLayer;
@synthesize moveAction = _moveAction;
@synthesize walkAction = _walkAction;

+(id) scene
{
	// 'scene' is an autorelease object.
	GameScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer z:0 tag:kGameLayerTag];
    
    InterfaceLayer *interfaceLayer = [[[InterfaceLayer alloc] initWithMainLayer:layer] autorelease];
    [layer setInterfaceLayer:interfaceLayer];
    [scene addChild:interfaceLayer z:1];
    
	// return the scene
	return scene;
}

#pragma mark - physics
-(void) setupPhysicsWorld {
    b2Vec2 gravity = b2Vec2(0.0f, -9.8f);
    gravity.Set(0.0f, kWorldGravity);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
    
    m_debugDraw = new GLESDebugDraw(PTM_RATIO);
    world->SetDebugDraw(m_debugDraw);
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    m_debugDraw->SetFlags(flags);
    
    contactListener = new ContactListener();
    world->SetContactListener(contactListener);
}


- (void) makeBox2dObjAt:(CGPoint)p 
			   withSize:(CGPoint)size 
				dynamic:(BOOL)d 
			   rotation:(long)r 
			   friction:(long)f 
				density:(long)dens 
			restitution:(long)rest 
				  boxId:(int)boxId {
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
    //	bodyDef.angle = r;
	
	if(d)
		bodyDef.type = b2_dynamicBody;
	
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    
    GameObject *platform = [[GameObject alloc] init];
    [platform setType:kGameObjectPlatform];
	bodyDef.userData = platform;
	
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(size.x/2/PTM_RATIO, size.y/2/PTM_RATIO);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = dens;
	fixtureDef.friction = f;
	fixtureDef.restitution = rest;
	body->CreateFixture(&fixtureDef);
}
#pragma mark - drawing
- (void) drawCollisionTiles {
	CCTMXObjectGroup *objects = [tileMapNode objectGroupNamed:@"Collision"];
	NSMutableDictionary * objPoint;
	
	int x, y, w, h;	
	for (objPoint in [objects objects]) {
		x = [[objPoint valueForKey:@"x"] intValue];
		y = [[objPoint valueForKey:@"y"] intValue];
		w = [[objPoint valueForKey:@"width"] intValue];
		h = [[objPoint valueForKey:@"height"] intValue];	
		
		CGPoint _point=ccp(x+w/2,y+h/2);
		CGPoint _size=ccp(w,h);
		
		[self makeBox2dObjAt:_point 
					withSize:_size 
					 dynamic:false 
					rotation:0 
					friction:1.5f 
					 density:0.0f 
				 restitution:0 
					   boxId:-1];
	}
}

-(void) draw {
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}
- (void) addScrollingBackgroundWithTileMap {
	tileMapNode = [CCTMXTiledMap tiledMapWithTMXFile:@"scroller.tmx"];
	tileMapNode.anchorPoint = ccp(0, 0);
    
	[self addChild:tileMapNode z:-1];
}

#pragma mark -

-(void)startGame{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Tema1_Intro.m4a" loop:NO];
    
    player.position = ccp(100.0f, 180.0f);
    
    [player createBox2dObject:world];
    [player setVel:0];
    
    gameOver = false;
    // Start main game loop
    [self scheduleUpdate];
    
}
-(void)gameOver{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playEffect:@"lose.wav"];
    gameOver = TRUE;
    [self unscheduleUpdate];
    [self.interfaceLayer showRestartMenu:FALSE];
    NSLog(@"game over");
}

// a method to move the enemy 10 pixels toward the player
- (void) animateEnemy:(Player*)enemy
{
    // speed of the enemy
    ccTime actualDuration = 0.3;
    
    // Create the actions
    id actionMove = [CCMoveBy actionWithDuration:actualDuration
                                        position:ccpMult(ccpNormalize(ccpSub(player.position,enemy.position)), 10)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(enemyMoveFinished:)];
    [enemy runAction:
     [CCSequence actions:actionMove, actionMoveDone, nil]];
}

// callback. starts another iteration of enemy movement.
- (void) enemyMoveFinished:(id)sender {
    Player *enemy = (Player *)sender;
    
    [self animateEnemy: enemy];
}

-(void)addEnemyAtX:(int)x y:(int)y {
    Player *enemy = [Player spriteWithFile:@"Vader1.gif"];
    enemy.position = ccp(x, y);
    [self addChild:enemy];
    [enemy createBox2dObject:world];
    [self animateEnemy:enemy];
    
}

#pragma mark - constructors
-(id) init
{
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
        
        //        [[GameConfig sharedGame] setCurrentGameLayer:self];
        
        
		screenSize = [CCDirector sharedDirector].winSize;
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];   
		
        //set up physics
        [self setupPhysicsWorld];
        
        //Creating Layout
		[self addScrollingBackgroundWithTileMap];
		[self drawCollisionTiles];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         @"AnimBear.plist"];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode 
                                          batchNodeWithFile:@"AnimBear.png"];
        [self addChild:spriteSheet];
        
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 8; ++i) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"bear%d.png", i]]];
        }
        
        CCAnimation *walkAnim = [CCAnimation 
                                 animationWithFrames:walkAnimFrames delay:0.1f];
        
        //        player = [Player spriteWithFile:@"Icon-Small.png"];     
        player = [Player spriteWithSpriteFrameName:@"bear1.png"]; 
        player.position = ccp(100.0f, 180.0f);
        player.walkAction = [CCRepeatForever actionWithAction:
                             [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
        
        //        [player runAction:_walkAction];
        //        [spriteSheet addChild:player];
        
        
		[self addChild:player];
        
        //        // Find spawn point x,y coordinates
        CCTMXObjectGroup *objects = [tileMapNode objectGroupNamed:@"Objects"];
        
		//after creating the player
		//iterate through objects, finding all enemy spawn points and creating enemies.
		NSMutableDictionary * spawnPoint;
		
		enemies = [[NSMutableArray alloc] init];
		int x,y;
		for (spawnPoint in [objects objects]) {
			if ([[spawnPoint valueForKey:@"Enemy"] intValue] == 1){
				x = [[spawnPoint valueForKey:@"x"] intValue];
				y = [[spawnPoint valueForKey:@"y"] intValue];
				[self addEnemyAtX:x y:y];
			}
		}
        
        
        //star the game
        [self startGame];
        
	}
	return self;
}


#pragma mark - updates

- (void)updateGameOver:(ccTime)dt {
    
    if (gameOver) return;
    
    if (player.position.y < 0) {
        [self gameOver];
    }
    
}
- (void) update:(ccTime)dt {
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
    if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Tema1_loop.m4a"];
        
    }
    [self updateGameOver:dt];
    [player updatePlayer:dt];
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()) {
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, 
										   b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}	
	
	b2Vec2 pos = [player body]->GetPosition();
	CGPoint newPos = ccp(-1 * pos.x * PTM_RATIO + 50, self.position.y * PTM_RATIO);	
	[self setPosition:newPos];
}

#pragma mark - touches
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    if (touch.tapCount < 3) {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        if (location.x > screenSize.width / 2) {
            [player jump];
            return TRUE;
        } 
    }
    return FALSE;
    
}

-(void)onEnter{
    [super onEnter];
    [interfaceLayer onEnter];
}

-(void)onExit{
    [interfaceLayer onExit];
    [super onExit];
}

-(void)pause{
    //    ccColor4B c ={0,0,0,150};
    //    PauseLayer * p = [PauseLayer layerWithColor:c delegate:self];
    //    [self.parent addChild:p z:10];
    //    [self onExit];
    
}
#pragma mark - Moving Player
-(void)movePlayerFoward{
    [player setVel:kVel];
}
-(void)movePlayerBackward{
    [player setVel:-kVel];
}
-(void)stopPlayer{
    [player setVel:0];
}
#pragma mark -
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
    self.walkAction = nil;
	
	delete m_debugDraw;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end