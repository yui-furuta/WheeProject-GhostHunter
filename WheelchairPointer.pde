// - 2022 ORPHE PM workshop -

//Orphe
OrpheOne orpheOne; //左車輪に取り付けた Orphe Core -> 車輪の回転速度
OrpheTwo orpheTwo; //右車輪に取り付けた Orphe Core -> 車輪の回転速度
OrpheThree orpheThree; //筐体に取り付けた Orphe Core -> 向き

import ddf.minim.*;  //minimライブラリのインポート

Minim minim;  //Minim型変数であるminimの宣言
AudioPlayer player1;  //サウンドデータ格納用の変数
AudioPlayer player2;  //サウンドデータ格納用の変数
AudioPlayer player3;  //サウンドデータ格納用の変数

//軌跡の制御
//mouseX -> myWheel.x
//mouseY -> myWheel.y
boolean forwardKeyPressed = false;
boolean backwardKeyPressed = false;

Wheel myWheel;

PImage obake, haikei;

int r = 50;
int radius = 30;

int positionX=0;
int positionY=0;

int diameter = 40;

int hant=0;
int gameOver = 0;

float lightX = 0;
float lightY = 0;

float getLightX = 0;
float getLightY = 0;

int timeLimit = 100;//ゲームオーバーまでの時間

int time =0;
int gameoverFill=0;

int moveMax = 2;
int moveMin = -2;

int MAX_COUNTER = 200;    //どれだけ同じ方向に動くかの調整用カウンタ
int counter =0;    //どれだけ同じ方向に動くかの調整用カウンタ
int moveX =1;
int moveY =1;

int obakeSize=0;
int obakeArpha=0;

int dieCount=0;

int stopTime=0;

int count=0;

int clearHeight1=0;
int clearHeight2=0;
int clearHeight3=0;

int clearHeight4=0;
int clearHeight5=0;
int clearHeight6=0;

int lightFill=255;

int lightCount=0;
int i=10;


void setup()
{
  size(450,840);
  //センサのサンプリングレートは50Hz
  frameRate(50);
  //orpheの初期化
  orpheOne = new OrpheOne(); 
  orpheOne.setup(1111);

  orpheTwo = new OrpheTwo();
  orpheTwo.setup(1112);

  orpheThree = new OrpheThree();
  orpheThree.setup(1113);

  //軌跡の制御
  //動きの制御
  myWheel = new Wheel();

  // Set the spawn position. 
  myWheel.x = width/2;
  myWheel.y = height/2;

  // Set the initial direction to be down. Directions should always be of 1 length.
  // Here it is 1 length because we are just pointing down 1 in the y.
  myWheel.directionX = 0;
  myWheel.directionY = 1;

  // Speed of forward and back movement (how many pixels to move each frame)
  myWheel.speed = 0;


  //Blue Growth
  smooth();
  colorMode(RGB);
  rectMode(CENTER);
  
  obake = loadImage("obake.png");
  haikei = loadImage("halloween5.png");
  
  minim = new Minim(this);  //初期化
  player1 = minim.loadFile("Maze.mp3");  //sample.mp3をロードする
  player2 = minim.loadFile("ゴースト01.mp3");  //sample.mp3をロードする
  player3 = minim.loadFile("get.mp3");  //sample.mp3をロードする
  player1.play();  //再生
}

void draw()
{
  getOrpheData();
  GetWheelTrace();
  
  background(82,48,90);
  noStroke();
  
  time=timeLimit-millis()/1000;
  
//背景
  //for(int i =0; i<10; i++){
  //  fill(255,0,0);
  //  rect(0,i*40,400,20);

  beginShape();
  fill(118,118,179);
   vertex(-100, height/2);
   for (int i=0; i<width/2; i++) {
   float y = 100 + sin((i-count)*0.05)*10 +clearHeight1;
   vertex(i*2, y);
    }
  vertex(width+100,height/2);
  vertex(width+100, height);
  vertex(-100, height);
  endShape(CLOSE);
  
  beginShape();
  fill(172,123,204);
   vertex(-100, height/2);
   count ++;
   for (int i=0; i<width/2; i++) {
   float y = 300 + sin((i+count)*0.05)*10+clearHeight2;
   vertex(i*2, y);
    }
  vertex(width+100,height/2);
  vertex(width+100, height);
  vertex(-100, height);
  endShape(CLOSE);
  
  
  beginShape();
   fill(216,113,199);
   vertex(-100, height/2);
   for (int i=0; i<width/2; i++) {
   float y = 500 + sin((i-count)*0.05)*10+clearHeight3;
   vertex(i*2, y);
    }
  vertex(width+100,height/2);
  vertex(width+100, height);
  vertex(-100, height);
  endShape(CLOSE);
  
  imageMode(CENTER);
  image(haikei,400,650,900,900*762/1800);
  
//動くおばけ
  if(counter < MAX_COUNTER){    //MAXになっていないときは何もしない
        counter++;
    }else{            //MAXのときは移動方向・距離変更
  counter =0;
  moveX=int(random(moveMin,moveMax));
  moveY=int(random(moveMin,moveMax));
    }
  positionX = positionX + moveX;
    if(positionX < 0){    //左に突き抜けたら移動方向を反転
        positionX = 0;
        moveX = moveX * -1;
    }
    if(positionX > width){    //右に突き抜けたら移動方向を反転
        positionX = width;
        moveX = moveX * -1;
    }
  positionY = positionY + moveY;
   if(positionY < 0){    //上に突き抜けたら移動方向を反転
        positionY = 0;
        moveY = moveY * -1;
    }
    if(positionY > height){    //下に突き抜けたら移動方向を反転
        positionY = height;
        moveY = moveY * -1;
    }
  //fill(255,0,0);
  //ellipse(positionX,positionY,diameter,diameter);
  imageMode(CENTER);
  if(hant<1){
   obakeSize = diameter*2;
   obakeArpha = 225;
  }else{
   dieCount++;
   if(dieCount>60){
   obakeSize = obakeSize-1;
   obakeArpha = obakeArpha-5;
   clearHeight3-=(dieCount-60)/2;
   }
   if(dieCount>70){
     clearHeight2-=(dieCount-70)/2;
   }
   if(dieCount>80){
     clearHeight1-=(dieCount-80)/2;
     clearHeight6-=(dieCount-80)/2;
   }
   if(dieCount>90){
     clearHeight1-=(dieCount-80)/2;
     clearHeight5-=(dieCount-80)/2;
   }
   if(dieCount>100){
     clearHeight1-=(dieCount-80)/2;
     clearHeight4-=(dieCount-80)/2;
   }
  }
  tint(255, obakeArpha);
  image(obake,positionX,positionY,obakeSize,obakeSize);
  tint(255, 255);
  
//クリア演出
  beginShape();
  fill(118,118,179);
   vertex(-100, height/2);
   for (int i=0; i<width/2; i++) {
   float y = 900 + sin((i-count)*0.05)*10 +clearHeight4;
   vertex(i*2, y);
    }
  vertex(width+100,height/2);
  vertex(width+100, height);
  vertex(-100, height);
  endShape(CLOSE);
  
  beginShape();
  fill(172,123,204);
   vertex(-100, height/2);
   count ++;
   for (int i=0; i<width/2; i++) {
   float y = 1200 + sin((i+count)*0.05)*10+clearHeight5;
   vertex(i*2, y);
    }
  vertex(width+100,height/2);
  vertex(width+100, height);
  vertex(-100, height);
  endShape(CLOSE);
  
  
  beginShape();
   fill(216,113,199);
   vertex(-100, height/2);
   for (int i=0; i<width/2; i++) {
   float y = 1500 + sin((i-count)*0.05)*10+clearHeight6;
   vertex(i*2, y);
    }
  vertex(width+100,height/2);
  vertex(width+100, height);
  vertex(-100, height);
  endShape(CLOSE);
  
//ライト
  //黒を被せる
  lightCount++;
  push();
  if(lightCount>300){
    lightFill=lightFill-i;
    if(lightFill<=0){
      i=i*(-1);
    }
    if(lightCount>350){
        lightFill=255;
        lightCount=0;
        i=i*(-1);
      }
  }
  //println(lightCount);
  fill(0,lightFill);
  beginShape();
  vertex(0,0);
  vertex(0,height);
  vertex(width,height);
  vertex(width,0);
  vertex(0,0);
  //円のくりぬき
  beginContour();
  for(float a = 0; a < TAU; a += TAU / 90){
    float x = lightX + radius * cos(a);
    float y = lightY + radius * sin(a);
    vertex(x, y);
  }
  endContour();
  endShape(CLOSE);
  pop();
  
//ゲームクリアの時
  if(dist(positionX, positionY, myWheel.x, myWheel.y)<=diameter && hant==0 && gameOver<1){
    getLightX = myWheel.x;
    getLightY = myWheel.y;
    hant=1;
    stopTime = time;
    player1.play();  //再生
  }
  //円が大きくなる
  if(hant>0){
    //fill(255,0,0);
    //ellipse(positionX,positionY,diameter,diameter);
    lightX = getLightX;
    lightY = getLightY;
    radius+=10;
    //クリアの文字
    if(gameoverFill<255&&dieCount>130){
      gameoverFill+=1;
    }
    fill(255,255,0,gameoverFill);
    textSize(50);
    textAlign(CENTER,CENTER);
    text("CREAR",width/2,height/2);
    
    
  }
  
//ゲームオーバーの時
  if(timeLimit-millis()/1000<=0 && gameOver<1){
    getLightX = myWheel.x;
    getLightY = myWheel.y;
    gameOver =1;
    player2.play();  //再生
  }
  
  //円が小さくなる
  if(gameOver>0){
    time=0;
    lightX = getLightX;
    lightY = getLightY;
    if(radius<=0){
      radius=0;
    //ゲームオーバーの文字
    if(gameoverFill<255){
      gameoverFill+=1;
    }
    fill(gameoverFill);
    textSize(50);
    textAlign(CENTER,CENTER);
    text("GAME OVER",width/2,height/2);
    }else{
    radius -=1;
    }
  }
  
//ゲーム中
  if(hant==0 && gameOver==0){
    lightX = myWheel.x;
    lightY = myWheel.y;
  }
  
//時間表示
  fill(255);
  textSize(20);
  textAlign(LEFT,TOP);
  text("TIME:",20,20);
  //時間を止める
  if(hant==1){
  text(stopTime,70,20);
  }else{
  text(time,70,20);
  }
  //println(lightX+":"+lightY+":"+getLightX+":"+getLightY+":"+hant+":"+gameOver);



  if (isStraight)
  {
    
  }

  if (isTurn)
  {
    
  }

  if (isStop)
  {
    
  }
}


//軌跡の制御
void GetWheelTrace() {
  myWheel.lookAt(orpheThree.eulerZ_left + 90);//プロジェクションマッピングの前にテスト
  myWheel.draw();
  myWheel.speed = (abs(rotateSpeed_OrpheOne) + abs(rotateSpeed_OrpheTwo)) / 2;
}

float rotateSpeed_OrpheOne;
float rotateSpeed_OrpheTwo;
float rotateSpeed_OrpheThree;
float offset_OrpheOne = 0;
float offset_OrpheTwo = -15.625;
float offset_OrpheThree = -15.625;
float speed_threashold = 0.5;
boolean isStraight = false;

float angleTruned;
int turnNum = 0;
boolean isTurn = false;
boolean isStop = false;

boolean isClockWise = false;



void getOrpheData() {
  //orpheOne.OrpheSensorView(width/ 2 - 200, height/2 + 100);
  //orpheTwo.OrpheSensorView(width/ 2 + 200, height/2 + 100);
  //orpheThree.OrpheSensorView(width/ 2, height/2);

  //回転速度
  rotateSpeed_OrpheOne = -(orpheOne.gyroZ_left - offset_OrpheOne)* (1/frameRate);
  rotateSpeed_OrpheTwo = (orpheTwo.gyroZ_left - offset_OrpheTwo)* (1/frameRate);
  rotateSpeed_OrpheThree = (orpheThree.gyroZ_left - offset_OrpheThree)* (1/frameRate);

  //println (offset_OrpheOne+"," + offset_OrpheTwo+","+offset_OrpheThree);

  //直進
  if (rotateSpeed_OrpheOne * rotateSpeed_OrpheTwo > 0)
  {
    if (abs(rotateSpeed_OrpheOne)>speed_threashold || abs(rotateSpeed_OrpheTwo)>speed_threashold) {
      text("Straight", 100, 100);
      isStraight = true;
      isTurn = false;
      isStop = false;

      if (rotateSpeed_OrpheOne<-0.5 & rotateSpeed_OrpheTwo<-0.5) {
        //前進
        forwardKeyPressed = true;
        backwardKeyPressed = false;
        myWheel.sprite.setAnimation(true);
      } else if (rotateSpeed_OrpheOne>0.5 & rotateSpeed_OrpheTwo>0.5) {
        //後退
        forwardKeyPressed = false;
        backwardKeyPressed = true;
        myWheel.sprite.setAnimation(true);
      }
    }
  } 

  //回転
  if (abs(rotateSpeed_OrpheThree) > 0.5) {
    isStraight = false;
    isTurn = true;
    isStop = false;

    angleTruned = angleTruned + rotateSpeed_OrpheThree;
    //println(angleTruned);
    text("turn", 100, 100);
    if (abs(angleTruned) > 340 )
    {
      turnNum++;
      angleTruned = 0;
    }    
  }

  //停止
  if (rotateSpeed_OrpheOne * rotateSpeed_OrpheTwo == 0 && rotateSpeed_OrpheThree == 0)
  {
    isStraight = false;
    isTurn = false;  
    isStop = true;
    isClockWise = false;

    myWheel.sprite.setAnimation(true);
    forwardKeyPressed = false;
    backwardKeyPressed = false;
  }
}
