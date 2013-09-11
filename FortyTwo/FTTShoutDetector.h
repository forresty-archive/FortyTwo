//
//  FTTShoutDetector.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FTTShoutDetectorDelegate <NSObject>

- (void)shoutDetectorDidDetectShout;

- (void)shoutDetectorShoutDidEnd;

@end


@interface FTTShoutDetector : NSObject

- (instancetype)initWithDelegate:(id<FTTShoutDetectorDelegate>)delegate;

@property (nonatomic, weak) id<FTTShoutDetectorDelegate> delegate;

@end
