//class Asteroid {
//  float posX, posY;
//  float size;
//  color clr;
//  float speedX, speedY;
//  float health;

//  Asteroid(float posX, float posY, float size, color clr, float speedX, float speedY, float health) {
//    this.posX = posX;
//    //this.posY = posY;
//    this.size = size;
//    this.clr = clr;
//    this.speedX = speedX;
//    this.speedY = speedY;
//    this.health = health;
//  }

//  void displayAsteroid() {
//    pushMatrix();
//    fill(clr);
//    ellipse(posX, posY, size, size);
//    popMatrix();
//  }

//  void updateAsteroid() {
//    posX += speedX;
//    posY += speedY;
//  }

//  boolean isOffScreen() {
//    return (posX < 0 || posX > width || posY < 0 || posY > height);
//  }

//  void takeDamage(float damage) {
//    health -= damage;
//    if (health <= 0) {
//      // Handle asteroid destruction, e.g., remove from game
//    }
//  }
//}
