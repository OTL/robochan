#import <stdlib.h>
#import <GL/glut.h>

#import "OTLWorld.h"

OTLWorld *wrld;

void display(void)
{
  glClear(GL_COLOR_BUFFER_BIT);

  if (wrld){
    [wrld draw];
  }

  //  glFlush();
  glutSwapBuffers();
}

void init (void)
{
  /* ウィンドウ全体をビューポートにする */
  //glViewport(0, 0, backingWidth, backingHeight);
  //glViewport(0, 0, backingWidth, backingHeight);
  /* 透視変換行列の指定 */
  //  glMatrixMode(GL_PROJECTION);

  /* 透視変換行列の初期化 */
//   glLoadIdentity();
//   //glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f);
//   // 透視変換っぽい感じ
//   //float v = 0.03;
//   float v = 0.5;
//   float aspect = (float)backingWidth/(float)backingHeight;
//   glFrustumf(-v, v, -v*aspect, v*aspect, 1.0, 100.0);
//   /* モデルビュー変換行列の指定 */
//   glMatrixMode(GL_MODELVIEW);
	
  // Clears the view with white
  glClearColor(1.0, 1.0, 1.0, 0.0);

  glEnable(GL_DEPTH_TEST);
  glEnable(GL_CULL_FACE);
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
}

void resize(int w, int h)
{
  /* ウィンドウ全体をビューポートにする */
  glViewport(0, 0, w, h);

  /* 透視変換行列の指定 */
  glMatrixMode(GL_PROJECTION);

  /* 透視変換行列の初期化 */
  glLoadIdentity();
  double a = 0.8;
  glFrustum(-a, a, -a*((double)w/(double)h), a*((double)w/(double)h), 1.0, 100.0);

  //gluPerspective(30.0, (double)w / (double)h, 1.0, 100.0);

  /* モデルビュー変換行列の指定 */
  glMatrixMode(GL_MODELVIEW);
}

void keyboard(unsigned char key, int x, int y)
{
  /* ESC か q をタイプしたら終了 */
  if (key == '\033' || key == 'q') {
    exit(0);
  }
  [wrld addRandomRobot];
}

static int pbutton;
static int px=-1;
static int py=-1;

void mouse(int button, int state, int x, int y)
{
  if ( button == GLUT_LEFT_BUTTON && state == GLUT_DOWN )
  {
    pbutton = GLUT_LEFT_BUTTON;
  }
  else if ( button == GLUT_RIGHT_BUTTON && state == GLUT_DOWN )
  {
    pbutton = GLUT_RIGHT_BUTTON;
  }
  if ( state == GLUT_UP )
  {
    px = -1;
    py = -1;
  }
}


void motion(int x, int y)
{
  
  if (px == -1 && py == -1)
  {
    px = x;
    py = y;
  }
  if (pbutton == GLUT_LEFT_BUTTON)
  {
    float p[3];
    [wrld getViewPos:p];
    p[0] += 0.01 * (x - px);
    p[1] += -0.01 * (y - py);
    [wrld setViewPos:p];
  }
  else if (pbutton == GLUT_RIGHT_BUTTON)
  {
    float p[3];
    [wrld getViewPos:p];
    p[2] += 0.05 * (y - py);
    [wrld setViewPos:p];
  }
  px = x;
  py = y;

  glutPostRedisplay();
}

int main(int argc, char *argv[])
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_RGBA | GLUT_DEPTH |GLUT_DOUBLE);
  glutInitWindowSize(480, 640);
  wrld = [OTLWorld new];

  glutCreateWindow(argv[0]);
  glutDisplayFunc(display);
  glutIdleFunc(display);
  glutReshapeFunc(resize);
  glutMouseFunc(mouse);
  glutMotionFunc(motion);
  glutKeyboardFunc(keyboard);
  init();
  glutMainLoop();
  return 0;
}

