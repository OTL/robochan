/** 
 @file OTLRobochanViewController.h
 @brief ������Ԃŕ\������View
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import <UIKit/UIKit.h>
#import "EAGLView.h"

/** @brief ������Ԃŕ\������ViewController�N���X
 *
 */
@interface OTLTeachViewController : UIViewController{
  /// OpenGL ES�ŕ`�悷�镔��
  EAGLView *glView;
}

@property(readonly, retain) EAGLView *glView;

@end

