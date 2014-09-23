//
//  LXAudioTool.h
//
//  Created by xinliu on 14-9-20. 309122873@qq.com
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXAudioPlayer.h"

@interface LXAudioTool : NSObject

#pragma mark - singleTon method
#pragma mark singleTon
+ (instancetype)sharedAudioToolManager;
#pragma mark musicPlayer
/* key:music filename value:AVAudioPlayer */
@property (strong,nonatomic) NSMutableDictionary *musicAudioPlayerDict;
/* key:sound filename value:soundID */
@property (strong,nonatomic) NSMutableDictionary *soundIDDict;

#pragma mark playMusic
- (LXAudioPlayer *)playMusic:(NSString *)musicFileName;
- (LXAudioPlayer *)playMusic:(NSString *)musicFileName repeatCount:(NSInteger)repeatCount;
/* key:filename value:repeateCount */
- (void)playMusicWithCountNameDict:(NSDictionary *)dict;
- (void)playMusic:(NSString *)musicFileName afterMusicFinished:(NSString *)finishedFileName;
- (void)playMusic:(NSString *)musicFileName completionHandler:(playFinishedBlock)finishBlock;

#pragma mark pauseMusic
- (void)pauseMusic:(NSString *)musicFileName;

#pragma mark stopMusic
- (void)stopMusic:(NSString *)musicFileName;
- (void)stopMusic:(NSString *)musicFileName afterMusicFinished:(NSString *)finishedFileName;

#pragma mark playSound
- (void)playSound:(NSString *)soundFileName;

#pragma mark disposeAudio
- (void)disposeSound:(NSString *)soundFileName;

@end
