//
//  OTLJointTestViewController.m
//  Test1
//
//  Created by 小倉 崇 on 4/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OTLJointTestViewController.h"


@implementation OTLJointTestViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pView
numberOfRowsInComponent:(NSInteger)component
{
  int ret = 0;
  switch(component){
  case 0:
    ret = 18;
    break;
  case 1:
    ret = 19;
    break;
  default:
    ret = 10;
    break;
  }
  return(ret);
}

- (NSString *)pickerView:(UIPickerView *)pickerView
	     titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  NSString *str;
  switch(component){
  case 0:
    str = [NSString stringWithFormat:@"Joint %d",row];
    break;
  case 1:
    str = [NSString stringWithFormat:@"Ang %d", ((row - 9) * 10)];
    break;
  default:
    str = [NSString stringWithFormat:@"%d [ms]", (1 + row) * 100];
    break;
  }
  return str;
}

- (void)pickerView:(UIPickerView *)aPickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}

- (void)setJoint:(id)sender
{
  double ang  = (double) (([pickerView selectedRowInComponent:1] - 9) * 10);
  int jointId = (int)[pickerView selectedRowInComponent:0];
  double tm = (double)((1 + [pickerView selectedRowInComponent:2]) * 100);
  
  NSLog(@"setting joint %d angle %f time %f\n", jointId, ang, tm);
  [ri setJointAngle:ang at:jointId time:tm];
}

/**
 *  @brief セグメントコントロールを追加する
 *
 */
- (void)addSegment
{
  UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                          [NSArray arrayWithObjects:
                                           @"connect", @"motion1", @"motion2", @"servo all off", nil]];
  segmentedControl.momentary = YES;
    
  // Compute a rectangle that is positioned correctly for the segmented control you'll use as a brush color palette
  segmentedControl.frame = CGRectMake(0,1,480,54);
  // When the user chooses a color, the method changeBrushColor: is called.
  [segmentedControl addTarget:self action:@selector(sendCommand:)
		    forControlEvents:UIControlEventValueChanged];
  segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
  // Make sure the color of the color complements the black background
  segmentedControl.tintColor = [UIColor darkGrayColor];
  // Set the third color (index values start at 0)
//  segmentedControl.selectedSegmentIndex = 0;
	
  // Add the control to the window
  [self.view addSubview:segmentedControl];
  // Now that the control is added, you can release it
  [segmentedControl release];
}

- (void)sendCommand:(id)sender
{
  switch([sender selectedSegmentIndex]){
  case 0:
      [self.ri serialInit];
      break;
  case 1:
      [self.ri playPresetMotionId:1];
      break;
  case 2:
      [self.ri playPresetMotionId:2];
      break;
  case 3:
      [self.ri setJointServoOffAll];
      break;
  default:
    break;
  }
}

/** 関節角度を送信するボタンを追加する
 *
 */
- (void)addButton
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setFrame:CGRectMake(320.0f, 55.0f, 160.0f, 215.0f)];
  [button setTitle:@"動け！" forState:UIControlStateNormal];
  [button addTarget:self action:@selector(setJoint:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];
}

/** pickverを追加する
 *
 */
- (void)addPicker
{
  float height = 55.0f; // 表示高さ
  pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, height, 320.0f, 216.0f + height)];
  pickerView.delegate = self;
  pickerView.showsSelectionIndicator = YES;
  [pickerView selectRow:9 inComponent:1 animated:NO];
  [pickerView selectRow:4 inComponent:2 animated:NO];
  [self.view addSubview:pickerView];  
  [pickerView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [self addPicker];
  [self addSegment];
  [self addButton];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (id)init
{
  if (self = [super initWithNibName:nil bundle:nil])
  {
		self.view.backgroundColor = [UIColor lightGrayColor];		
		self.title = @"動作テスト";
		self.tabBarItem.image = [UIImage imageNamed:@"teachTabIcon_32.png"]; 
		self.tabBarItem.badgeValue = @"開発";
  }

  return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
  [pickerView release];
  [super dealloc];
}


@end
