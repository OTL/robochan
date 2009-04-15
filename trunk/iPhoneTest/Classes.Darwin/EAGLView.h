/** @file EAGLView.h
 @brief EAGLViewクラスを定義するファイル
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/*  $Id:$ */

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

//#import "RobochanAppDelegate.h"
#import "OTLWorld.h"


/** @brief EAGLViewクラス
 *
 * iPhone SDKのサンプルについてくるものをもとにしている
 */
@interface EAGLView : UIView
{
@private
	
  /// The pixel dimensions of the backbuffer
  GLint backingWidth;
  GLint backingHeight;
  /// コンテキスト
  EAGLContext *context;
  
  /// OpenGL names for the renderbuffer and framebuffers used to render to this view
  GLuint viewRenderbuffer, viewFramebuffer;
  
  //// OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist)
  GLuint depthRenderbuffer;
  
  /* OpenGL name for the sprite texture */
  //  GLuint spriteTexture;
  /// worldクラスへのポインタ
  OTLWorld *wrld;
  
  NSTimer *animationTimer;
  NSTimeInterval animationInterval;
  //int touch;
  //int move;
//  RobochanAppDelegate *app;
  //
  Boolean firstTouch;

}

/// アニメーションの開始
- (void)startAnimation;
/// アニメーションの停止
- (void)stopAnimation;
/// 描画
- (void)drawView;

///サイズを指定して初期化
- (id)initWithFrame:(CGRect)rect; //add
///2点の距離を測る
- (float)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

///アニメーションの間隔
@property NSTimeInterval animationInterval;
///親オブジェクトであるRobochanAppDelegateへのポインタ
//@property (readwrite, retain) RobochanAppDelegate *app;
///描画物体を管理するworldクラスへのポインタ
@property (readwrite, retain) OTLWorld *wrld;

@end
