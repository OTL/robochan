/**
 @file RobochanAppDelegate.m
 @brief アプリメインプログラムのファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import "OTLTestViewController.h"
#import "OTLKHRInterface.h"

@implementation OTLTestViewController

/** 
 * セグメントコントローラのボタンのハンドラ
 * 
 * @param sender 呼び出し元（セグメントコントローラ）
 */
- (void)sendCommand:(id)sender
{
  if ([ri getFd] >= 0){
    switch([sender selectedSegmentIndex]){
    case 0:
      break;
    case 1:
      [ri getSettings];
      break;
    case 2:
      [ri playMotion:0];
    case 3:
      [ri playMotion:1];
    case 4:
      [ri getAngles];
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
  CGRect frame = CGRectMake(10,50,300,50);
  segmentedControl.frame = frame;
  // When the user chooses a color, the method changeBrushColor: is called.
  [segmentedControl addTarget:self action:@selector(sendCommand:)
		    forControlEvents:UIControlEventValueChanged];
  segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
  // Make sure the color of the color complements the black background
  segmentedControl.tintColor = [UIColor darkGrayColor];
  // Set the third color (index values start at 0)
  segmentedControl.selectedSegmentIndex = 0;
	
  // Add the control to the window
  [self.view addSubview:segmentedControl];
  // Now that the control is added, you can release it
  [segmentedControl release];
}

- (id)init
{
  if (self = [super initWithNibName:nil bundle:nil])
  {
		self.view.backgroundColor = [UIColor lightGrayColor];		
		self.title = @"シリアルテスト";
		self.tabBarItem.image = [UIImage imageNamed:@"teachTabIcon_32.png"]; 
		self.tabBarItem.badgeValue = @"開発用";
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
  label.text = @"シリアルテスト";
  label.textAlignment = UITextAlignmentCenter;		
  [self.view addSubview:label];
   // セグメントコントロールを追加
  [label release];		
  [self addSegment];
}

@end
