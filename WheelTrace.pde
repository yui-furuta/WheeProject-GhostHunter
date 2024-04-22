class AnimatedSprite
{

  int frameWidth;
  int frameHeight;


  boolean loop = true;
  float frameSpeed = 60.0;


  AnimatedSprite(int widthOfOneFrame, int heightOfOneFrame)
  {
    this.frameWidth = widthOfOneFrame;
    this.frameHeight = heightOfOneFrame;
  }

  void setAnimation(boolean looping)
  {
    this.loop = looping;
  }


  void draw(float sizein)
  {
    noFill();
    //stroke(255);
    //ellipse(0, 0, 10, 10);
  }
}

class Wheel 
{
  float x = 0.0;
  float y = 0.0;
  float rotation = 0.0;
  float speed;
  float directionX;
  float directionY;
  float s = 2.0;

  AnimatedSprite sprite;

  Wheel()
  {
    this.sprite = new AnimatedSprite(10, 10);
  }


  void lookAt(float degreesin)
  {
    this.rotation = degreesin;
    this.directionX = cos(radians(this.rotation));
    this.directionY = sin(radians(this.rotation));
  }

  void draw()
  {
    println(this.directionX+":"+this.directionY);
    if (forwardKeyPressed)
    {
      this.x += this.directionX * this.speed;
      this.y += this.directionY * this.speed;

      this.x  = (this.x + width) % width;
      this.y  = (this.y + height) % height;
    }
    // subtract to go backward
    if (backwardKeyPressed)
    {
      this.x -= this.directionX * this.speed;
      this.y -= this.directionY * this.speed;

      this.x  = (this.x + width) % width;
      this.y  = (this.y + height) % height;
    }

    // apply transformations
    imageMode(CENTER);
    pushMatrix();
    translate(this.x, this.y);
    rotate(radians(this.rotation));
    scale(this.s);

    // draw and animate the animated sprite
    this.sprite.draw(this.speed);


    popMatrix();

    imageMode(CORNER);
  }
}
