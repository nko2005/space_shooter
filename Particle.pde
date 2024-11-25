class Particle {
  float posX, posY;
  float velX, velY;
  float lifespan;
  color col;
  
  Particle(float x, float y) {
    
    posX = x;
    posY = y;
    float angle = random(TWO_PI);
    float speed = random(1, 3);
    velX = cos(angle) * speed;
    velY = sin(angle) * speed;
    lifespan = 255;
    col = color(255, 0, 0, lifespan);
    
  }
  
  void updateParticle() {
    posX += velX;
    posY += velY;
    lifespan -= 4;
    col = color(255, 0, 0, lifespan);
  }
  
  void displayParticle() {
    noStroke();
    fill(col);
    ellipse(posX, posY, 5, 5);
  }
  
  boolean isDead() {
    return lifespan <= 0;
  }
}
