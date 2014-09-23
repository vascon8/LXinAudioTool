//
//  LXAudioTool.m
//
//  Created by xinliu on 14-9-20. 309122873@qq.com
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import "LXAudioTool.h"

static LXAudioTool *sharedInstance = Nil;

@interface LXAudioTool () <AVAudioPlayerDelegate>

@end

@implementation LXAudioTool
#pragma mark - Music
#pragma mark playMusic
- (LXAudioPlayer *)playMusic:(NSString *)musicFileName
{
    return [self playMusic:musicFileName repeatCount:0];
}
- (LXAudioPlayer *)playMusic:(NSString *)musicFileName repeatCount:(NSInteger)repeatCount
{
    LXAudioPlayer *player = [LXAudioPlayer playMusic:musicFileName repeatCount:repeatCount];
    if (!player) {
        return Nil;
    }
    player.delegate = self;
    [self.musicAudioPlayerDict setObject:player forKey:musicFileName];
    return player;
}
- (void)playMusic:(NSString *)musicFileName afterMusicFinished:(NSString *)finishedFileName
{
    LXAudioPlayer *player = [self validateDependence:musicFileName finished:finishedFileName];
    if (!player) {
        return;
    }
    player.dependenceFileName = musicFileName;
    player.dependence = kDependencePlay;
}
- (void)playMusicWithCountNameDict:(NSDictionary *)dict
{
    for (NSString *musicFileName in dict) {
        [self playMusic:musicFileName repeatCount:[dict[musicFileName] integerValue]];
    }
}
- (void)playMusic:(NSString *)musicFileName completionHandler:(playFinishedBlock)finishBlock
{
    LXAudioPlayer *player = [self playMusic:musicFileName];
    if (!player) {
        return;
    }
    player.finishBlock = finishBlock;
}
#pragma mark pauseMusic
- (void)pauseMusic:(NSString *)musicFileName
{
    LXAudioPlayer *player = self.musicAudioPlayerDict[musicFileName];
    if (player && player.isPlaying) {
        [player pause];
    }
}
#pragma mark stopMusic
- (void)stopMusic:(NSString *)musicFileName
{
    LXAudioPlayer *player = self.musicAudioPlayerDict[musicFileName];
    if (player && player.isPlaying) {
        [player stop];
        [self.musicAudioPlayerDict removeObjectForKey:musicFileName];
    }
}
- (void)stopMusic:(NSString *)musicFileName afterMusicFinished:(NSString *)finishedFileName
{
    LXAudioPlayer *player = [self validateDependence:musicFileName finished:finishedFileName];

    if (!player) {
        return;
    }
    player.dependenceFileName = musicFileName;
    player.dependence = kDependenceStop;
}
#pragma mark - AudioPlayer delegate
- (void)audioPlayerDidFinishPlaying:(LXAudioPlayer *)player successfully:(BOOL)flag
{
    if (player.finishBlock) {
        player.finishBlock();
    }
    
    if (player.dependenceFileName) {
        [self finishDependence:player];
    }

    [self.musicAudioPlayerDict removeObjectForKey:player.fileName];
}
- (void)finishDependence:(LXAudioPlayer *)player
{
    switch (player.dependence) {
        case kDependencePlay:
            [self playMusic:player.dependenceFileName];
            break;
            
        case kDependenceStop:
            [self stopMusic:player.dependenceFileName];
            break;
            
        default:
            break;
    }
}
#pragma mark - Sound
#pragma mark play Sound
- (void)playSound:(NSString *)soundFileName
{
    SystemSoundID soundID = [self.soundIDDict[soundFileName] unsignedLongValue];
    if (!soundID) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:soundFileName withExtension:Nil];
        if (!url)  return;
        
        soundID = [LXAudioPlayer playSound:soundFileName];
        if (soundID) {
            [self.soundIDDict setObject:@(soundID) forKey:soundFileName];
        }
    }
    else{
        AudioServicesPlaySystemSound(soundID);
    }
}
#pragma mark dispose Sound
- (void)disposeSound:(NSString *)soundFileName
{
    if (!soundFileName) {
        return;
    }
    
    SystemSoundID soundID = [self.soundIDDict[soundFileName] unsignedLongValue];
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        [self.soundIDDict removeObjectForKey:soundFileName];
   }
}
#pragma mark - sigleton method
+ (instancetype)sharedAudioToolManager
{
    if (sharedInstance == Nil) {
        sharedInstance = [[LXAudioTool alloc]init];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:Nil];
        [session setActive:YES error:Nil];
    }
    return sharedInstance;
}
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}
#pragma mark - private method
- (NSMutableDictionary *)musicAudioPlayerDict
{
    if (!_musicAudioPlayerDict) {
        _musicAudioPlayerDict = [NSMutableDictionary dictionary];
    }
    return _musicAudioPlayerDict;
}
- (NSMutableDictionary *)soundIDDict
{
    if (!_soundIDDict) {
        _soundIDDict = [NSMutableDictionary dictionary];
    }
    return _soundIDDict;
}
- (LXAudioPlayer *)validateDependence:(NSString *)musicFileName finished:(NSString *)finishedFileName
{
    if (!musicFileName || !finishedFileName) {
        return Nil;
    }
    
    LXAudioPlayer *player = self.musicAudioPlayerDict[finishedFileName];
    if (!player) {
        return Nil;
    }
    return player;
}
@end
