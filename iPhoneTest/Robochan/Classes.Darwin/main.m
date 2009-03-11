/**
 * @file main.m
 * @brief Robochanメインプログラム

 * @author Takashi Ogura
 * @date 2009/03/01
 * @version 0.0.1
*/

/* $Id:$ */

/** \mainpage
 *
 * RobochanとはiPod touchでKHR-2HVを動かすプロジェクト
 * このソフトはそのiPod touch用ソフトウェアです。
 * - world
 * - ground
 * - drawableObject
 *
 * @todo coordクラス
 * @todo glm:テクスチャの確認
 * @todo glmでdepthがおかしくなる修正
 * @todo 顔の作成
 * @todo アプリの選択
 * @todo アプリケーションのフレームワーク
 * @todo 動作教示アプリ
 * @todo リアクションアプリ
 * @todo ダンスアプリ
 * @todo 目覚ましアプリ
 */

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain(argc, argv, nil, @"RobochanAppDelegate");
  [pool release];
  return retVal;
}
