class Bullet {
  float posX, posY;
  float speed = 10;
  float angle;
  float damage =100;
  
  Bullet(float x, float y, float angle) {
    this.posX = x;
    this.posY = y;
    this.angle = angle;
  }
  
  void updateBullet() {
    // Move the bullet in the direction of the angle
    posX += cos(angle) * speed;
    posY += sin(angle) * speed;
  }

  void displayBullet() {
    ellipse(posX, posY, 10, 10); // Draw bullet
  }
   boolean isOffScreen() {
    // Check if the bullet is off the screen
    return (posX < 0 || posX > width || posY < 0 || posY > height);
  }
}
