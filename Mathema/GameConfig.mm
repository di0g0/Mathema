//
//  GameConfig.m
//  SimpleBox2dScroller
//
//  Created by Diogo Henrique da Silva Costa on 26/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

@interface  GameConfig()
-(void)setDefaults;

@end

@implementation GameConfig
@synthesize musicEnabled, soundsEnabled;
@synthesize paused;
//@synthesize currentGameLayer;

#pragma mark - Singleton Stuff

+ (id)sharedGame
{
    static dispatch_once_t pred;
    static GameConfig *sharedGame = nil;
    
    dispatch_once(&pred, ^{
        sharedGame = [[self alloc] init]; 
        
    });
    return sharedGame;
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
    
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}

#pragma mark -

- (id)init
{
    
    if ((self = [super init])) {
        
    }
    
    return self;
}

- (void)setMusicEnabled:(BOOL)music{
    
    if (musicEnabled != music) {
        musicEnabled = music;
        [[NSUserDefaults standardUserDefaults] setBool:music forKey:kGameConfigMusicEnabled];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
       
    
}

-(void)setSoundsEnabled:(BOOL)sound{
    
    if (soundsEnabled != sound) {
        soundsEnabled = sound;
        [[NSUserDefaults standardUserDefaults] setBool:sound forKey:kGameConfigMusicSoundsEnabled];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
}

-(void)getUserPreferences{
    //checa se é o primeiro acesso, se sim atribui os valores default para todas as propriedades
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kGameConfigHasDefaults]) {
        [self setDefaults];
    }
    self.musicEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kGameConfigMusicEnabled];
    self.soundsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kGameConfigMusicSoundsEnabled];
}

-(void)setDefaults{
    [[NSUserDefaults standardUserDefaults] setBool:TRUE  forKey:kGameConfigMusicEnabled];
    [[NSUserDefaults standardUserDefaults] setBool:TRUE  forKey:kGameConfigMusicSoundsEnabled];

    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:kGameConfigHasDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
