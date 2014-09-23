//
//  LXAudioPlayer.h
//
//  Created by xinliu on 14-9-20. 309122873@qq.com
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef enum {
    kDependenceStop = 0,
    kDependencePlay
}kDependenceType;

typedef void(^playFinishedBlock)();

@interface LXAudioPlayer : AVAudioPlayer

@property (strong,nonatomic) NSString *fileName;

/* stop/play music(dependenceFileName) after music(fileName) finished */
/* dependence: stop/play */
@property (strong,nonatomic) NSString *dependenceFileName;
@property (assign,nonatomic) kDependenceType dependence;

@property (copy,nonatomic) playFinishedBlock finishBlock;

#pragma mark playMusic
+ (LXAudioPlayer *)playMusic:(NSString *)musicFileName;
+ (LXAudioPlayer *)playMusic:(NSString *)musicFileName repeatCount:(NSInteger)repeatCount;

#pragma mark playSound
+ (SystemSoundID)playSound:(NSString *)soundFileName;

@end
