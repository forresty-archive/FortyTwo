//
//  FTTFrameManager.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FTTFrameManagerDelegate <NSObject>

- (void)frameManagerDidUpdateFrame;

@end


@interface FTTFrameManager : NSObject

@property (nonatomic, weak) id<FTTFrameManagerDelegate> delegate;

- (instancetype)initWithFrameRate:(NSUInteger)frameRate;

- (void)start;

- (void)pause;

@end
