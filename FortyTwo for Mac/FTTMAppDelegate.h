//
//  FTTMAppDelegate.h
//  FortyTwo for Mac
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class FTTMGameViewController;


@interface FTTMAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic) FTTMGameViewController *gameViewController;

@end
