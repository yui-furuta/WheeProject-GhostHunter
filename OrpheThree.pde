import oscP5.*;
import netP5.*;

class OrpheThree
{  
  OscP5 oscP5Orphe;

  int port;

  //quaternion from orphe
  float x_left, y_left, z_left, w_left;

  //euler angle from orphe
  float eulerX_left, eulerY_left, eulerZ_left;

  //accel sensor value from orphe - default range 2g
  float accelX_left, accelY_left, accelZ_left;

  //gyro sensor value from orphe - default range 2000°/s
  float gyroX_left, gyroY_left, gyroZ_left;

  void setup(int portin)
  {
    port = portin;
    oscP5Orphe = new OscP5(this, port);
  }

  void oscEvent(OscMessage oscMessage)
  {
    // /LEFT/sensorValues
    if (oscMessage.checkAddrPattern("/LEFT/sensorValues")) {

      //quaternion from orphe
      w_left = oscMessage.get(0).floatValue(); //quaternion_w
      x_left = oscMessage.get(1).floatValue(); //quaternion_x
      y_left = oscMessage.get(2).floatValue(); //quaternion_y
      z_left = oscMessage.get(3).floatValue(); //quaternion_z

      eulerZ_left =  -oscMessage.get(6).floatValue();

      //accel sensor value from orphe - default range 2g
      accelX_left = oscMessage.get(7).floatValue(); //accel_x
      accelY_left = oscMessage.get(8).floatValue(); //accel_y
      accelZ_left = oscMessage.get(9).floatValue(); //accel_z

      //gyro sensor value from orphe - default range 250°/s
      gyroX_left = oscMessage.get(10).floatValue(); //gyro_x
      gyroY_left = oscMessage.get(11).floatValue(); //gyro_y
      gyroZ_left = oscMessage.get(12).floatValue(); //gyro_z
    }
  }

  public void OrpheSensorView(float widthDisplay, float heightDisplay) {
    //LEFT Orpheの値を利用したcube
    pushMatrix();
    translate(widthDisplay, heightDisplay, 100);
    float[] euler_LEFT =  quaternion_to_euler_angle(y_left, z_left, x_left, -w_left);

    rotateX(-euler_LEFT[0]);
    rotateY(-euler_LEFT[1]);
    rotateZ(-euler_LEFT[2]);
    fill(255);
    box(100, 20, 150);
    popMatrix();
  }


  //四元数からオイラ角に変換する
  float[] quaternion_to_euler_angle(float x, float y, float z, float w) {

    float t0 = 2.0 * (w * x + y * z);
    float t1 = 1.0 - 2.0 * (x * x + y * y);
    float X = atan2(t0, t1);

    float t2 = 2.0 * (w * y - z * x);
    t2 = (t2 > 1.0)? 1.0:t2;
    t2 = (t2 < -1.0)? -1.0:t2;
    float Y = asin(t2);

    float t3 = 2.0 * (w * z + x * y);
    float t4 = 1.0 - 2.0 * (y * y + z * z);

    float Z = atan2(t3, t4);

    float[] forReturn = new float[3];
    forReturn[0] = X;
    forReturn[1] = Y;
    forReturn[2] = Z;
    return forReturn;
  }
}
