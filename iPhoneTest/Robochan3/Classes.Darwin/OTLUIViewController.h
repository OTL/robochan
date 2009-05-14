//
//  OTLUIViewController.h
//  Test1
//
//  Created by 小倉 崇 on 4/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTLKHRInterface;

@interface OTLUIViewController : UIViewController {
  OTLKHRInterface *ri;
}

- (id)initWithRobotInterface:(OTLKHRInterface *)ari;

@end
