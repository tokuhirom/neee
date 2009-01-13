//
//  ScreenManager.m
//  tutorial
//
//  Created by Tokuhiro Matsuno on 09/01/13.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScreenManager.h"
#import <Carbon/Carbon.h>

@implementation ScreenManager

+(void)doFullScreen
{
	SetSystemUIMode(kUIModeAllHidden, 4);
}

+(void)doRestore
{
	SetSystemUIMode(kUIModeNormal, 0);
}

@end
