/** @file boxRobot.h
 @brief boxRobotクラス
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/*  $Id:$ */

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "drawableObject.h"

/** @brief boxRobotクラス
 *
 * Boxで構成されるロボットを表示する
 * @todo テクスチャ・関節構造をKHR-2HVと同じにするなど
 */
@interface boxRobot : drawableObject
{
@private
  int frame;
  GLfloat neck;
  GLfloat dir;

}

/// 腕や脚を描画するため
- (void) drawArmLeg:(float) girth: (float) length: (float) r1: (float) r2;
/// ■を表示。本来はこれを一つのクラスにしたほうがいいかも
- (void)drawBox:(float)x:(float) y:(float) z;
/// ロボット形状の描画
- (void) drawShape;
@end
