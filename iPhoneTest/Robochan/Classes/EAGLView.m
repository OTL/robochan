/*

  File: BoxRobot.m
  Abstract: This class wraps the CAEAGLLayer from CoreAnimation into a convenient
  UIView subclass. The view content is basically an EAGL surface you render your
  OpenGL scene into.  Note that setting the view non-opaque will only work if the
  EAGL surface has an alpha channel.

  Version: 1.7

  Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
  ("Apple") in consideration of your agreement to the following terms, and your
  use, installation, modification or redistribution of this Apple software
  constitutes acceptance of these terms.  If you do not agree with these terms,
  please do not use, install, modify or redistribute this Apple software.

  In consideration of your agreement to abide by the following terms, and subject
  to these terms, Apple grants you a personal, non-exclusive license, under
  Apple's copyrights in this original Apple software (the "Apple Software"), to
  use, reproduce, modify and redistribute the Apple Software, with or without
  modifications, in source and/or binary forms; provided that if you redistribute
  the Apple Software in its entirety and without modifications, you must retain
  this notice and the following text and disclaimers in all such redistributions
  of the Apple Software.
  Neither the name, trademarks, service marks or logos of Apple Inc. may be used
  to endorse or promote products derived from the Apple Software without specific
  prior written permission from Apple.  Except as expressly stated in this notice,
  no other rights or licenses, express or implied, are granted by Apple herein,
  including but not limited to any patent rights that may be infringed by your
  derivative works or by other works in which the Apple Software may be
  incorporated.

  The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
  WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
  WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
  COMBINATION WITH YOUR PRODUCTS.

  IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
  DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
  CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
  APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"
#import "math.h"

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

// You must implement this
+ (Class) layerClass
{
  return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
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

  glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
  [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (touch == 0){
    touch = 1;
  }else{
    touch = 0;
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (move == 0){
    move = 1;
  }else{
    move = 0;
  }
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
