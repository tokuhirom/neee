//
//  ScreenManager.h
//  tutorial
//
//  Created by Tokuhiro Matsuno on 09/01/13.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Carbon/Carbon.h>


@interface ScreenManager : NSObject {

}

// XXX bad naming
- (void)doFullScreen;
- (void)doRestore;

@end
