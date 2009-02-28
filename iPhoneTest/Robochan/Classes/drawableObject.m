#import "drawableObject.h"

@implementation drawableObject

- (id)init
{
//   pos = (float *)malloc(sizeof(float)*3);
//   rot = (float *)malloc(sizeof(float)*4);

  for (int i = 0; i < 3; i++){
    pos[i] = 0;
  }
  rot[0]=0;
  rot[1]=0;
  rot[2]=1;
  rot[3]=0;

  return([super init]);
}

- (void)setPos:(float)x:(float)y:(float)z
{
  pos[0] = x;
  pos[1] = y;
  pos[2] = z;
}

- (void)setRot:(float)t:(float)x:(float)y:(float)z
{
  rot[0] = t;
  rot[1] = x;
  rot[2] = y;
  rot[3] = z;
}

- (void)draw
{
  glPushMatrix();
  glTranslatef(pos[0], pos[1], pos[2]);
  glRotatef(rot[0], rot[1], rot[2], rot[3]);

  [self drawShape];

  glPopMatrix();
}

- (void)drawShape
{
  //このメソッドをオーバーライドしてください
}

// - (void)dealloc
// {
//   [super dealloc];
//   free(pos);
//   free(rot);
// }

@end
