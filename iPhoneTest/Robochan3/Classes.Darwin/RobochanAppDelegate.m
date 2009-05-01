/**
 @file RobochanAppDelegate.m
 @brief アプリメインプログラムのファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import "RobochanAppDelegate.h"
//#import "EAGLView.h"
//#import "OTLWorld.h"
#import "OTLKHRInterface.h"
#import "OTLTabBarController.h"
#import "OTLRobochanViewController.h"
#import "OTLTeachViewController.h"
#import "OTLNullViewController.h"
#import "OTLTestViewController.h"
#import "OTLJointTestViewController.h"
#import "OTLWindow.h"

//#import "set_text.h"

@implementation RobochanAppDelegate

@synthesize window;
@synthesize tabController;


// - (void)addLabel
// {
//   CGRect rect = [[UIScreen mainScreen] applicationFrame];  
//   CGRect textRect =  CGRectMake(rect.origin.x,
// 				rect.size.height - 50,
// 				rect.size.width,
// 				50);
//   //set_text *output_text = [[set_text alloc] initWithFrame:textRect];
//   label = [[UILabel alloc] initWithFrame:textRect];
//   label.textAlignment = UITextAlignmentLeft;
//   label.text = @"ロボチャン";
//   label.font = [UIFont boldSystemFontOfSize:17.0];
//   label.textColor = [UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0];
//   label.backgroundColor = [UIColor clearColor];
//   [window addSubview:label];  
// }

// Sets up the frame rate and starts animating the sprite.
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//application = application;
	// Look in the Info.plist file and you'll see the status bar is hidden
	// Set the style to black so it matches the background of the application
  CGRect rect = [[UIScreen mainScreen] bounds];
  window = [[OTLWindow alloc] initWithFrame:rect];

  ri = [[OTLKHRInterface alloc] init];
  tabController =  [[OTLTabBarController alloc] initWithNibName:nil bundle:nil];
  tvController = [[[OTLTeachViewController alloc] init] autorelease];
  controllers = [NSArray arrayWithObjects:
                           [[[OTLRobochanViewController alloc] init] autorelease],
                         tvController,
                         [[[OTLNullViewController alloc] init] autorelease],
                         [[[OTLTestViewController alloc] initWithRobotInterface:ri] autorelease],
                         [[[OTLJointTestViewController alloc] initWithRobotInterface:ri] autorelease],
                         nil];
  
  [tabController setViewControllers:controllers animated:NO];
  [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];

  // ラベル（デバッグ用？）追加
  //[self addLabel];

  // Now show the status bar, but animate to the style.

  [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
  [window addSubview: tabController.view];
  [application setStatusBarHidden:NO animated:YES];
  //ウィンドウの表示
  [window makeKeyAndVisible];
  //[glView drawView];

}


// Changes the frame rate when the application is about to be inactive.
- (void)applicationWillResignActive:(UIApplication *)application {
 	NSLog(@"applicationWillResignActive:");
 	tvController.glView.animationInterval = 1.0 / 5.0;
}

// Resumes the initial frame rate when the application becomes active.
- (void)applicationDidBecomeActive:(UIApplication *)application {
 	NSLog(@"applicationDidBecomeActive:");
 	tvController.glView.animationInterval = 1.0 / 60.0;
}

// Stops the animation and then releases the window resource.
- (void)dealloc
{
  [tabController release];
// 	[glView stopAnimation];
	[window release];
  [controllers release];
// 	[label release];
	[super dealloc];
}

// - (void)viewDidLoad
// {
//   [super viewDidLoad];
//   // Rotate to landscape
//   self.window.frame = CGRectMake(0, 0, 480.0, 320.0);
//   if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
//     CGAffineTransform transform = self.window.transform;

//     // Set the center point of the view to the center point of the window's content area.      
//     self.window.center = CGPointMake(160.0, 240.0);

//     // Rotate the view 90 degrees around its new center point.
//     transform = CGAffineTransformRotate(transform, (M_PI / 2.0));
//     self.window.transform = transform;
//   }
// }

// - (void)setLabelText:(NSString *)str
// {
//   label.text = str;
// }

@end
