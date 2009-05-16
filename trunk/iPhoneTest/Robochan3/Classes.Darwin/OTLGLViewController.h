/** 
 @file
 @brief 
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import <UIKit/UIKit.h>
#import "EAGLView.h"

/** @brief 
 *
 */
@interface OTLGLViewController : UIViewController
{
@private
  /// OpenGL ES
  EAGLView *glView;
}

@property(readonly, retain) EAGLView *glView;

@end

