//
//  FTTUniverseView.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <UIKit/UIKit.h>


static const NSUInteger FTTBombCooldownTime = 42;


@class FTTUserObject;


@interface FTTUniverseView : UIView

@property (nonatomic) NSArray *enemies;
@property (nonatomic) FTTUserObject *userObject;
@property (nonatomic) NSTimeInterval bombCooldownTime;
@property (nonatomic, readonly) BOOL bombAvailable;

- (void)deployBomb;

@end
