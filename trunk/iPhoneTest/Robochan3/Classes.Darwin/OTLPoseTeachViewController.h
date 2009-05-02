//
//  OTLPoseTeachViewController.h
//  Robochan
//
//  Created by 小倉 崇 on 5/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTLKHRInterface;

@interface OTLPoseTeachViewController : UITableViewController <UIAlertViewDelegate> {
  NSMutableArray *fileList;
  OTLKHRInterface *ri;
}

- (id)initWithRobotInterface:(OTLKHRInterface *)ari;

@end
