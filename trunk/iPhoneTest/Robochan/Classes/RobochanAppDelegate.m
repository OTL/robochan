/*

File: RobochanAppDelegate.m
Abstract: The UIApplication  delegate class which is  the central controller of
the application.

Version: 1.7

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import "RobochanAppDelegate.h"
#import "EAGLView.h"
								   //#import "set_text.h"

@implementation RobochanAppDelegate

@synthesize window;

// Sets up the frame rate and starts animating the sprite.
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//application = application;
	// Look in the Info.plist file and you'll see the status bar is hidden
	// Set the style to black so it matches the background of the application
  CGRect rect = [[UIScreen mainScreen] bounds];
  window = [[UIWindow alloc] initWithFrame:rect];

  [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];

  rect = [[UIScreen mainScreen] applicationFrame];
  glView = [[EAGLView alloc] initWithFrame:CGRectMake(rect.origin.x,
						      rect.origin.y,
						      rect.size.width,
						      rect.size.height - 50
						      )];
  glView.app = self;

  [window addSubview:glView];

  //オブジェクト(window)をウィンドウに追加
  glView.animationInterval = 1.0 / 60.0;
  [glView startAnimation];
  CGRect textRect =  CGRectMake(rect.origin.x,
				rect.size.height - 50,
				rect.size.width,
				50);
  //set_text *output_text = [[set_text alloc] initWithFrame:textRect];
  label = [[UILabel alloc] initWithFrame:textRect];
  label.textAlignment = UITextAlignmentLeft;
  label.text = @"ロボチャン";
  label.font = [UIFont boldSystemFontOfSize:17.0];
  label.textColor = [UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0];
  label.backgroundColor = [UIColor clearColor];
  [window addSubview:label];  

//   output_text.text= @"robochan";
//   output_text.location = CGPointMake(10,450);
//   output_text.color = [UIColor whiteColor];
//   [window addSubview:output_text];
//   [output_text release];

  // Now show the status bar, but animate to the style.
  [application setStatusBarHidden:NO animated:YES];

  //ウィンドウの表示
  [window makeKeyAndVisible];
  [glView drawView];
}


// Changes the frame rate when the application is about to be inactive.
- (void)applicationWillResignActive:(UIApplication *)application {
	NSLog(@"applicationWillResignActive:");
	glView.animationInterval = 1.0 / 5.0;
}

// Resumes the initial frame rate when the application becomes active.
- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"applicationDidBecomeActive:");
	glView.animationInterval = 1.0 / 60.0;
}

// Stops the animation and then releases the window resource.
- (void)dealloc {
	[glView stopAnimation];
	[window release];
	[label release];
	[super dealloc];
}

- (void)setLabelText:(NSString *)str
{
  label.text = str;
}

@end
