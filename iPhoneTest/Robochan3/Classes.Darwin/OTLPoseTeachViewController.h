//
//  OTLPoseTeachViewController.h
//  Robochan
//
//  Created by 小倉 崇 on 5/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTLKHRInterface.h"

@interface OTLPoseTeachViewController : UITableViewController <UIAlertViewDelegate> {
@private
  NSMutableArray *fileList;
  OTLKHRInterface *ri;
}

@property (readwrite,retain) OTLKHRInterface *ri;
@end
