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

//#import "set_text.h"

@implementation RobochanAppDelegate

@synthesize window;
@synthesize tabController;
@synthesize ri;

- (void)setControllersRi:(OTLKHRInterface *)ari
{
  for (OTLUIViewController *vc in controllers)
  {
    if ( [vc respondsToSelector:@selector(setRi:)] )
    {
      vc.ri = ari;
    }
  }
}

- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  switch(buttonIndex)
  {

    case 0:      // キャンセル →　デバッグモードへ
      break;
    case 1:      // 再接続
      [ri serialInit];
      if (![ri checkConnection])
      {
        [self showConnectionCheckAlert];
      }
      else // 接続成功
      {
        [self setControllersRi:ri];
      }
  
      break;
  }
}

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


- (void)showConnectionCheckAlert
{
  UIAlertView *checkAlert = [[UIAlertView alloc] initWithTitle:@"ロボットとの接続エラー"
                                                       message:@"ロボットの電源・接続を確認してください"
                                                      delegate:self
                                               cancelButtonTitle:@"接続しない"
                                             otherButtonTitles:@"リトライ", nil];
  [checkAlert show];
  [checkAlert release];
}

// Sets up the frame rate and starts animating the sprite.
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//application = application;
	// Look in the Info.plist file and you'll see the status bar is hidden
	// Set the style to black so it matches the background of the application
  CGRect rect = [[UIScreen mainScreen] bounds];
  window = [[OTLWindow alloc] initWithFrame:rect];

  [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
  
 
  tabController =  [[OTLTabBarController alloc] initWithNibName:nil bundle:nil];
  glController = [[[OTLGLViewController alloc] init] autorelease];
  OTLUINavigationController *nav = [[OTLUINavigationController alloc] initWithRootViewController:
								  [[[OTLPoseTeachViewController alloc] init] autorelease]];

  // OTLUIViewControllerを"必ず"継承すること
  controllers = [NSArray arrayWithObjects:
                           [[[OTLRobochanViewController alloc] init] autorelease],
                         nav,
                         [[[OTLTestViewController alloc] init] autorelease],
                         [[[OTLJointTestViewController alloc] init] autorelease],
                         glController,
                         [[[OTLNullViewController alloc] init] autorelease],
                         nil];
	[nav release];

  // TEST
//  init();
//  RCB3J_play_motion(RCB3J_OPT_ACK_ON, (((int)2) & 0xff));
//  close(fd);

  [tabController setViewControllers:controllers animated:NO];
  [tabController setCustomizableViewControllers:controllers];
  //  [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];

  // ラベル（デバッグ用？）追加
  //[self addLabel];

  // Now show the status bar, but animate to the style.  
  [window addSubview: tabController.view];
  //[application setStatusBarHidden:NO animated:YES];

  // ロボットへ接続
  ri = [[OTLKHRInterface alloc] init];
  if ( ![ri checkConnection] ) // ケーブル接続エラー
  {
    [self showConnectionCheckAlert];
  }
  
  // 接続されていなければデバッグモードで動作する
  // 接続されていればインタフェースへのポインタを渡す
  if ( ri.isConnected ){
    [self setControllersRi:ri];
  }
 
  //ウィンドウの表示  
  [window makeKeyAndVisible];
  //[glView drawView];

}


// Changes the frame rate when the application is about to be inactive.
- (void)applicationWillResignActive:(UIApplication *)application {
 	NSLog(@"applicationWillResignActive:");
 	glController.glView.animationInterval = 1.0 / 5.0;
}

// Resumes the initial frame rate when the application becomes active.
- (void)applicationDidBecomeActive:(UIApplication *)application {
 	NSLog(@"applicationDidBecomeActive:");
 	glController.glView.animationInterval = 1.0 / 60.0;
}

// Stops the animation and then releases the window resource.
- (void)dealloc
{
  [tabController release];
// 	[glView stopAnimation];
	[window release];
  [controllers release];
  [ri release];
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
