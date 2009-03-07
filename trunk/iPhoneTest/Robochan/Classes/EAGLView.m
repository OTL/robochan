/** @file EAGLView.m
 @brief EAGLViewクラス
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/*  $Id:$ */

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"
#import "world.h"

@interface EAGLView (EAGLViewPrivate)

- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;

@end

@interface EAGLView (EAGLViewSprite)

- (void)setupView;

@end

@implementation EAGLView

@synthesize animationInterval;
@synthesize app;
@synthesize wrld;

/// You must implement this
+ (Class) layerClass
{
  return [CAEAGLLayer class];
}


/** The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
 */
- (id)initWithCoder:(NSCoder*)coder
{
  if((self = [super initWithCoder:coder])) {
    // Get the layer
    CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
		
    eaglLayer.opaque = YES;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
    if(!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffer]) {
      [self release];
      return nil;
    }
		
    animationInterval = 1.0 / 60.0;
		
    [self setupView];
    [self drawView];
  }
	
  return self;
}

/**
 * フレームを受けとり初期化
 *
 * @param rect Viewのサイズ
 *
 * @retval self 初期化後のオブジェクト
 */
- (id)initWithFrame:(CGRect) rect
{

  self.wrld = [world new];

  if((self = [super initWithFrame:rect])) {
    // Get the layer
    CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
		
    eaglLayer.opaque = YES;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
    if(!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffer]) {
      [self release];
      return nil;
    }
		
    animationInterval = 1.0 / 60.0;
		
    [self setupView];
    [self drawView];

    // マルチタッチを有効にする
    [self setMultipleTouchEnabled:YES];
  }
	
  return self;
}


- (void)layoutSubviews
{
  [EAGLContext setCurrentContext:context];
  [self destroyFramebuffer];
  [self createFramebuffer];
  [self drawView];
}


- (BOOL)createFramebuffer
{
  glGenFramebuffersOES(1, &viewFramebuffer);
  glGenRenderbuffersOES(1, &viewRenderbuffer);
	
  glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
  glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
  [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
  glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
  glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
  glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
  if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
    NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
    return NO;
  }
	
  return YES;
}


- (void)destroyFramebuffer
{
  glDeleteFramebuffersOES(1, &viewFramebuffer);
  viewFramebuffer = 0;
  glDeleteRenderbuffersOES(1, &viewRenderbuffer);
  viewRenderbuffer = 0;
	
  if(depthRenderbuffer) {
    glDeleteRenderbuffersOES(1, &depthRenderbuffer);
    depthRenderbuffer = 0;
  }
}


- (void)startAnimation
{
  animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation
{
  [animationTimer invalidate];
  animationTimer = nil;
}


- (void)setAnimationInterval:(NSTimeInterval)interval
{
  animationInterval = interval;
	
  if(animationTimer) {
    [self stopAnimation];
    [self startAnimation];
  }
}

- (void)setupView
{
	
  /* ウィンドウ全体をビューポートにする */
  glViewport(0, 0, backingWidth, backingHeight);
  /* 透視変換行列の指定 */
  glMatrixMode(GL_PROJECTION);

  /* 透視変換行列の初期化 */
  glLoadIdentity();
  //glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f);
  // 透視変換っぽい感じ
  //float v = 0.03;
  float v = 0.5;
  float aspect = (float)backingWidth/(float)backingHeight;
  glFrustumf(-v, v, -v*aspect, v*aspect, 1.0, 100.0);
  /* モデルビュー変換行列の指定 */
  glMatrixMode(GL_MODELVIEW);
	
  // Clears the view with white
  glClearColor(1.0, 1.0, 1.0, 0.0);

  glEnable(GL_DEPTH_TEST);
  glEnable(GL_CULL_FACE);
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
}

// Updates the OpenGL view when the timer fires
- (void)drawView
{
  // Make sure that you are drawing to the current context
  [EAGLContext setCurrentContext:context];
	
  glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
  //glRotatef(3.0f, 0.0f, 0.0f, 1.0f);
  //glRotatef(3.0f, 0.0f, 1.0f, 0.0f);
//   if (touch == 0){
//     [self.app setLabelText:@"右へ動くよ"];
//     glTranslatef(0.01f, 0.0f, 0.0f);
//   }else{
//     [self.app setLabelText:@"左へ動くよ"];
//     glTranslatef(-0.01f, 0.0f, 0.0f);
//   }
//   if (move == 0){
//     //[self.app setLabelText:@"ぐるぐる回転"];
//     glRotatef(3.0f, 0.0f, 1.0f, 0.0f);
//   }else{
//     //[self.app setLabelText:@"くるくる〜"];
//     glRotatef(3.0f, 0.0f, 0.0f, 1.0f);
//   }

  glClear(GL_COLOR_BUFFER_BIT);
  //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

  if (wrld){
    [wrld draw];
  }
//   [self.app setLabelText:[NSString stringWithFormat:@"%d %.3f %.3f %.3f",
// 				   wrld.a, wrld.b, wrld.c,wrld.d]];

  glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
  [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  firstTouch = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  //マルチタッチ対応
  if ([touches count] > 1){
    float previousDistance;
    float multiDistance;
    
    UITouch *t1 = [[touches allObjects] objectAtIndex:0];
    UITouch *t2 = [[touches allObjects] objectAtIndex:1];
    CGPoint pp1 = [t1 previousLocationInView:self];
    CGPoint pp2 = [t2 previousLocationInView:self];
    previousDistance = [self distanceBetweenTwoPoints:pp1 toPoint:pp2];
    
    if (firstTouch){
      firstTouch = NO;
    }else{
      CGPoint p1 = [t1 locationInView:self];
      CGPoint p2 = [t2 locationInView:self];
      multiDistance = [self distanceBetweenTwoPoints:p1 toPoint:p2];
      wrld.viewPos[2] += 0.05 * (multiDistance - previousDistance);
    }
  }
  // シングルタッチ
  else{
    UITouch* touch = [[event touchesForView:self] anyObject];
    CGPoint location;
    CGPoint previousLocation;

    previousLocation = [touch previousLocationInView:self];
    if (firstTouch) {
      firstTouch = NO;
    } else {
      location = [touch locationInView:self];
      // Render the stroke
      wrld.viewPos[0] += 0.01 * (location.x - previousLocation.x);
      wrld.viewPos[1] += -0.01 * (location.y - previousLocation.y);
      //previousLocation = [touch previousLocationInView:self];
    }
  }
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  // ポインティング時
  if (firstTouch) {
    // ロボットを増やす（テスト）
    [wrld addRandomRobot];
  }
  firstTouch = NO;
}

- (float)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    float x = toPoint.x - fromPoint.x;
    float y = toPoint.y - fromPoint.y;
    
    return sqrt(x * x + y * y);
}

// Stop animating and release resources when they are no longer needed.
- (void)dealloc
{
  [self stopAnimation];
	
  if([EAGLContext currentContext] == context) {
    [EAGLContext setCurrentContext:nil];
  }
	
  [context release];
  context = nil;
	
  [super dealloc];
}

@end
