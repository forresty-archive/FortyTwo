//
//  FTTKeyboardInputSource.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FTTSpeedVector;


@protocol FFTMKeyboardInputSourceDelegate <NSObject>

- (void)keyboardInputSourceDidDeployedBomb;

@end


@interface FTTMKeyboardInputSource : NSResponder

@property (nonatomic, weak) id<FFTMKeyboardInputSourceDelegate> delegate;

@property (nonatomic, readonly) FTTSpeedVector *userSpeedVector;

@end
