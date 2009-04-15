/** 
 @file OTLRobochanViewController.h
 @brief 初期状態で表示するView
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import <UIKit/UIKit.h>
#import "EAGLView.h"

/** @brief 初期状態で表示するViewControllerクラス
 *
 */
@interface OTLTeachViewController : UIViewController{
  /// OpenGL ESで描画する部分
  EAGLView *glView;
}

@property(readonly, retain) EAGLView *glView;

@end

