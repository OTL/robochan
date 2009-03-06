/**
 @file RobochanAppDelegate.m
 @brief アプリメインプログラムのファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import "RobochanAppDelegate.h"
#import "EAGLView.h"
#import "world.h"
#import "KHRInterface.h"

//#import "set_text.h"

@implementation RobochanAppDelegate

@synthesize window;

/** 
 * セグメントコントローラのボタンのハンドラ
 * 
 * @param sender 呼び出し元（セグメントコントローラ）
 */
- (void)sendCommand:(id)sender
{
  if (ki.fd >= 0){
    switch([sender selectedSegmentIndex]){
    case 0:
      break;
    case 1:
      [ki getSettings];
      break;
    case 2:
      [ki playMotion:0];
    case 3:
      [ki playMotion:1];
    case 4:
      [ki getAngles];
    default:
      break;
    }
  }
}

/**
 *  @brief セグメントコントロールを追加する
 *
 */
- (void)addSegment
{
  UISegmentedControl *segmentedControl = 
    [[UISegmentedControl alloc] initWithItems:
				  [NSArray arrayWithObjects:
					   @"connect",
					   @"gs",
					   @"p 0",
					   @"p 1 ",
					   @"a ",
					   nil]];
  // Compute a rectangle that is positioned correctly for the segmented control you'll use as a brush color palette
  CGRect rect = [[UIScreen mainScreen] bounds];
  CGRect frame = CGRectMake(rect.origin.x + 10,
			    rect.size.height - 50 - 10,
			    rect.size.width - 20,
			    30);
  segmentedControl.frame = frame;
  // When the user chooses a color, the method changeBrushColor: is called.
  [segmentedControl addTarget:self action:@selector(sendCommand:) forControlEvents:UIControlEventValueChanged];
  segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
  // Make sure the color of the color complements the black background
  segmentedControl.tintColor = [UIColor darkGrayColor];
  // Set the third color (index values start at 0)
  segmentedControl.selectedSegmentIndex = 0;
	
  // Add the control to the window
  [window addSubview:segmentedControl];
  // Now that the control is added, you can release it
  [segmentedControl release];
}

/**
 @brief OpenGL ESで描画する 
 
*/
- (void)addGLView
{
  CGRect rect = [[UIScreen mainScreen] applicationFrame];
  //  glView = [[EAGLView alloc] initWithFrame:CGRectMake(rect.origin.x,
  glView = [[EAGLView alloc] initWithFrame:CGRectMake(rect.origin.x,
						      rect.origin.y,
						      rect.size.width,
						      rect.size.height - 50
						      )];
  
  // アプリケーション本体を登録
  glView.app = self;

  //オブジェクト(window)をウィンドウに追加
  glView.animationInterval = 1.0 / 60.0;
  [glView startAnimation];

  [window addSubview:glView];

}

- (void)addLabel
{
  CGRect rect = [[UIScreen mainScreen] applicationFrame];  
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
}

// Sets up the frame rate and starts animating the sprite.
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//application = application;
	// Look in the Info.plist file and you'll see the status bar is hidden
	// Set the style to black so it matches the background of the application
  CGRect rect = [[UIScreen mainScreen] bounds];
  window = [[UIWindow alloc] initWithFrame:rect];

  [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];

  // GLViewを追加
  [self addGLView];

  // セグメントコントロールを追加
  [self addSegment];

  // ラベル（デバッグ用？）追加
  [self addLabel];

  // Now show the status bar, but animate to the style.
  [application setStatusBarHidden:NO animated:YES];

  //ウィンドウの表示
  [window makeKeyAndVisible];
  //[glView drawView];
  ki = [[KHRInterface alloc] init];
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
	[ki release];
	[super dealloc];
}

- (void)setLabelText:(NSString *)str
{
  label.text = str;
}

@end
