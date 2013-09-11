//
//  FTTAlertViewManager.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/6/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTTAlertViewManager : NSObject

@property (nonatomic, weak) id<UIAlertViewDelegate> alertViewDelegate;

- (instancetype)initWithAlertViewDelegate:(id<UIAlertViewDelegate>)alertViewDelegate;

- (void)showGameOverAlertWithTimeLasted:(NSTimeInterval)timeLasted;

- (void)showGamePausedAlert;

// proxy setter
- (void)setAlertViewDelegate:(id<UIAlertViewDelegate>)alertViewDelegate;

@end
