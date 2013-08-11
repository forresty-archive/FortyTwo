//
//  FTTUniverseView.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FTTUserObject;


@interface FTTUniverseView : UIView

@property (nonatomic) NSArray *enemies;
@property (nonatomic) FTTUserObject *userObject;
@property (nonatomic) NSTimeInterval timePlayed;

@end
