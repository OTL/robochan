/** @file objObject.h
 @brief objObjectクラス
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
 $Id:$
*/

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "drawableObject.h"
#import "glm.h"

/** @brief objObjectクラス
 *
 * @todo デバッグ用メソッドgetDataの削除
 */
@interface objObject : drawableObject
{
@private
  GLMmodel *model;
}

// デバッグ用
- (int)getData:(int*)a:(float*)b:(float*)c:(float*)d;

@end
