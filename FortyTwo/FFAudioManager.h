//
//  FFAudioManager.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/6/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FFAudioManager : NSObject

+ (instancetype)defaultManager;

- (void)vibrate;

@end
