/**
 @file RobochanAppDelegate.m
 @brief アプリメインプログラムのファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import "OTLNullViewController.h"

@implementation OTLNullViewController

- (id)init
{
  if (self = [super initWithNibName:nil bundle:nil])
  {
		self.view.backgroundColor = [UIColor lightGrayColor];		
		self.title = @"開発中";
		self.tabBarItem.image = [UIImage imageNamed:@"teachTabIcon_32.png"]; 
		self.tabBarItem.badgeValue = @"3";
  }

  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 30)];
  label.font = [UIFont boldSystemFontOfSize:22];
  label.backgroundColor = [UIColor lightGrayColor];
  label.textColor = [UIColor blackColor];
  label.text = @"開発中！";
  label.textAlignment = UITextAlignmentCenter;		
  [self.view addSubview:label];			
  [label release];		
}

@end
