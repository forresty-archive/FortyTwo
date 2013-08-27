//
//  FTTDefines.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#ifndef FortyTwo_FTTDefines_h
#define FortyTwo_FTTDefines_h

static NSUInteger DeviceWidth() {
  return [UIScreen mainScreen].bounds.size.width;
}


static NSUInteger DeviceHeight() {
  return [UIScreen mainScreen].bounds.size.height;
}

static inline CGFloat FTTObjectWidth() {
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    return 12;
  }

  return 5;
}


#endif
