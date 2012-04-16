//
//  GameConfig.h
//  Mathema
//
//  Created by Diogo Costa on 3/31/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//

// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationUIViewController

// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone


// Ignore this value on Mac
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

#endif // __GAME_CONFIG_H

//User Defaults keys
#define kGameConfigHasDefaults @"hasDefauls" //check if the game was played before
#define kGameConfigMusicEnabled @"musicEnabled"
#define kGameConfigMusicSoundsEnabled @"soundsEnabled"


#import <Foundation/Foundation.h>
//#import "GameLayer.h"
@interface GameConfig : NSObject

+ (GameConfig*)sharedGame;

- (void)setMusicEnabled:(BOOL)music;
- (void)setSoundsEnabled:(BOOL)sound;
-(void)getUserPreferences;


@property (nonatomic,assign) BOOL musicEnabled;
@property (nonatomic,assign) BOOL soundsEnabled;
@property (nonatomic,assign) BOOL paused;
//@property (nonatomic,retain) GameLayer *currentGameLayer;

@end
