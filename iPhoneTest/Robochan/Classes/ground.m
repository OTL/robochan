#import "ground.h"

@implementation ground

- (id) init
{
  [super init];
  return [self initWithHeight:-1.8];
}

- (void) setColor:(float)r1:(float)g1:(float)b1:(float)a1:
	(float)r2:(float)g2:(float)b2:(float)a2
{
  gcolor[0][0]=r1;
  gcolor[0][1]=g1;
  gcolor[0][2]=b1;
  gcolor[0][3]=a1;
  //
  gcolor[1][0]=r2;
  gcolor[1][1]=g2;
  gcolor[1][2]=b2;
  gcolor[1][3]=a2;
}

- (id) initWithHeight:(float)h
{
  height = h;

  [self setColor:0.6: 0.6: 0.6: 1.0:
	  0.3: 0.3: 0.3: 1.0];

  return (self);
}

/*
 * ’n–Ê‚ð•`‚­
 */
- (void) drawShape
{

  int i, j;

  glNormal3f(0.0, 1.0, 0.0);

  for (j = -5; j <= 5; ++j) {
    for (i = -5; i < 5; ++i) {
      glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, gcolor[(i + j) & 1]);

      glEnableClientState(GL_VERTEX_ARRAY);
      //glEnableClientState(GL_NORMAL_ARRAY);

      gvertex[0] = (GLfloat)i;
      gvertex[1] = height;
      gvertex[2] = (GLfloat)j;
      //
      gvertex[3] = (GLfloat)i;
      gvertex[4] = height;
      gvertex[5] = (GLfloat)(j + 1);
      //
      gvertex[6] = (GLfloat)(i + 1);
      gvertex[7] = height;
      gvertex[8] = (GLfloat)(j + 1);
      //
      gvertex[9] = (GLfloat)(i + 1);
      gvertex[10] = height;
      gvertex[11] = (GLfloat)j;
      
      glVertexPointer(3, GL_FLOAT, 0, gvertex);
      glDrawArrays(GL_TRIANGLE_FAN, 0, 4);

      glDisableClientState(GL_VERTEX_ARRAY);
      //glDisableClientState(GL_NORMAL_ARRAY);
    }
  }
}

@end
