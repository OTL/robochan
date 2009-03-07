/** @file OTLObjObject.h
 @brief OTLObjObjectクラスのヘッダファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
 $Id:$
*/

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "OTLDrawableObject.h"
#import "glm.h"

/** @brief OTLObjObject
 *
 */
@interface OTLObjObject : OTLDrawableObject
{
@private
  GLMmodel *model; //< glm.mで作成した構造体
}

//デバッグ用
- (int)getData:(int*)a:(float*)b:(float*)c:(float*)d;

@end
