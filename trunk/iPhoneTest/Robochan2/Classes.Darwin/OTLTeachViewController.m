/**
 @file RobochanAppDelegate.m
 @brief アプリメインプログラムのファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import "OTLTeachViewController.h"

@implementation OTLTeachViewController

@synthesize glView;

- (id)init
{
  if (self = [super initWithNibName:nil bundle:nil])
  {
		self.view.backgroundColor = [UIColor lightGrayColor];		
		self.title = @"体操";
		self.tabBarItem.image = [UIImage imageNamed:@"teachTabIcon_32.png"]; 
		self.tabBarItem.badgeValue = @"3";
  }

  return self;
}

/**
 @brief OpenGL ESで描画する 
 
*/
- (void)addGLView
{
  //CGRect rect = [[UIScreen mainScreen] applicationFrame];
  //  glView = [[EAGLView alloc] initWithFrame:CGRectMake(rect.origin.x,
  glView = [[EAGLView alloc] initWithFrame:CGRectMake(0, 0, 480, 340)];
                               
// rect.origin.x,
// 						      rect.origin.y,
//                   rect.size.height,
// 						      rect.size.width
// 						      rect.size.width,
// 						      rect.size.height
//[glView autorelease];//?
//[glView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
  // アプリケーション本体を登録
  //glView.app = self;

  //オブジェクト(window)をウィンドウに追加
  glView.animationInterval = 1.0 / 60.0;

  [self.view addSubview:glView];

}

- (void)loadView
{
  ///UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,480,320)];
  [super loadView];
  self.view = [[EAGLView alloc] initWithFrame:CGRectMake(0, 0, 480, 340)];
  glView = self.view;

  //[view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

  //[view setBackgroundColor: ];
  
//  self.view = view;
//  [self addGLView];
//  [view release];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [glView startAnimation];
  
//   UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 30)];
//   label.font = [UIFont boldSystemFontOfSize:22];
//   label.backgroundColor = [UIColor lightGrayColor];
//   label.textColor = [UIColor blackColor];
//   label.text = @"Teach View";
//   label.textAlignment = UITextAlignmentCenter;		

  // GLViewを追加
  //[self addGLView];

  //[self.view addSubview:label];			
  //[label release];		
}

@end
