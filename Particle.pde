class Particle {
  float posX, posY;
  float velX, velY;
  float lifespan;
  color clr;
  
  Particle(float x, float y,color clr) {
    
    posX = x;
    posY = y;
    float angle = random(TWO_PI);
    float speed = random(1, 3);
    velX = cos(angle) * speed;
    velY = sin(angle) * speed;
    lifespan = 255;
    this.clr=  color(red(clr), green(clr), blue(clr), lifespan);
    
  }
  
  void updateParticle() {
    posX += velX;
    posY += velY;
    lifespan -= 8;
    clr = color(red(clr), green(clr), blue(clr), lifespan);
  }
  
  void displayParticle() {
    //noStroke();
    fill(clr);
    ellipse(posX, posY, 5, 5);
  }
  
  boolean isDead() {
    return lifespan <= 0;
  }
}
