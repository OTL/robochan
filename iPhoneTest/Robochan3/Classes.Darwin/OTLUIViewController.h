//
//  OTLUIViewController.h
//  Test1
//
//  Created by 小倉 崇 on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OTLKHRInterface.h"

@interface OTLUIViewController : UIViewController {
@protected
  OTLKHRInterface *ri;
}

- (id)initWithRobotInterface:(OTLKHRInterface *)ari;

@property (readwrite, retain) OTLKHRInterface *ri;

@end
