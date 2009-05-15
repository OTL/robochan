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
}

- (void)pickerView:(UIPickerView *)aPickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}

- (void)setJoint:(id)sender
{
  switch([sender selectedSegmentIndex])
  {
    case 0:
      [ri setJointAngle:(double)(([pickerView selectedRowInComponent:1] - 9) * 10)
                     at:(int)[pickerView selectedRowInComponent:0]
                   time: (double)(1 + [pickerView selectedRowInComponent:2]) * 100];
      break;
    case 1:
      [ri setJointServo:0 at:(int)[pickerView selectedRowInComponent:0]];
      break;
  }
//  [ri setJointAngle:(int)[pickerView selectedRowInComponent:0]];
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
					     @"setJoint",
               @"servo off",
   					   nil]];
  segmentedControl.momentary = YES;
    
  // Compute a rectangle that is positioned correctly for the segmented control you'll use as a brush color palette
  CGRect frame = CGRectMake(340,50,120,50);
  segmentedControl.frame = frame;
  // When the user chooses a color, the method changeBrushColor: is called.
  [segmentedControl addTarget:self action:@selector(setJoint:)
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

//   UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 30)];
//   label.font = [UIFont boldSystemFontOfSize:22];
//   label.backgroundColor = [UIColor lightGrayColor];
//   label.textColor = [UIColor blackColor];
//   label.text = @"開発中！";
//   label.textAlignment = UITextAlignmentCenter;
//   [self.view addSubview:label];	
//   [label release];		

  
  float height = 20;
  //pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, height, 320.0f, 216 + height)];
  pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, height, 320.0f, 216 + height)];
  pickerView.delegate = self;
  pickerView.showsSelectionIndicator = YES;
  [self.view addSubview:pickerView];
  [pickerView release];

  [self addSegment];
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
		self.title = @"ジョイントテスト";
		self.tabBarItem.image = [UIImage imageNamed:@"teachTabIcon_32.png"]; 
		self.tabBarItem.badgeValue = @"3";
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
