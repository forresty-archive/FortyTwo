//
//  FFGameCenterManager.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FFGameCenterManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, readonly) BOOL gameCenterEnabled;

- (void)reportScore:(int64_t)score forLeaderBoardIdentifier:(NSString *)identifier;

@end
