/** @file OTLBoxRobot.h
 * @brief OTLBoxRobotクラスのヘッダファイル
 * @author Takashi Ogura
 * @date 2009/03/01
 * @version 0.0.1
*/

/*  $Id:$ */

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "OTLDrawableObject.h"

/** @brief OTLBoxRobotクラス
 *
 * Boxで構成されるロボットを表示する
 * @todo テクスチャ・関節構造をKHR-2HVと同じにするなど
 */
@interface OTLBoxRobot : OTLDrawableObject
{
@private
  int frame;
  GLfloat neck;
  GLfloat dir;
}

- (void)drawArmLeg:(float) girth: (float) length: (float) r1: (float) r2;
- (void)drawBox:(float)x:(float) y:(float) z;
- (void)drawShape;

@end
