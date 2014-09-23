//
//  LXAudioPlayer.m
//
//  Created by xinliu on 14-9-20. 309122873@qq.com
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import "LXAudioPlayer.h"

@implementation LXAudioPlayer

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError *__autoreleasing *)outError
{
    self = [super initWithContentsOfURL:url error:outError];
    
    if (self) {
        self.fileName = [url lastPathComponent];
    }
    
    return self;
}
#pragma mark playMusic
+ (LXAudioPlayer *)playMusic:(NSString *)musicFileName
{
    return [self playMusic:musicFileName repeatCount:0];
}
+ (LXAudioPlayer *)playMusic:(NSString *)musicFileName repeatCount:(NSInteger)repeatCount
{
    if (!musicFileName) {
        return Nil;
    }
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:musicFileName withExtension:Nil];
    if (!url) {
        return Nil;
    }
    
    LXAudioPlayer *audioPlayer = [[LXAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    [audioPlayer prepareToPlay];
    audioPlayer.numberOfLoops = repeatCount;
    [audioPlayer play];
    
    return audioPlayer;
}
#pragma mark playSound
+ (SystemSoundID)playSound:(NSString *)soundFileName
{
    if (!soundFileName)   return 0;
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:soundFileName withExtension:Nil];
    if (!url)  return 0;
    
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    
    AudioServicesPlaySystemSound(soundID);
    return soundID;
}
@end
