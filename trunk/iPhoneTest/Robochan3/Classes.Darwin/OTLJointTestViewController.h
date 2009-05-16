//
//  OTLJointTestViewController.h
//  Test1
//
//  Created by 小倉 崇 on 4/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTLUIViewController.h"

@interface OTLJointTestViewController : OTLUIViewController <UIPickerViewDelegate>
{
  @private
  UIPickerView *pickerView;
}

@end
