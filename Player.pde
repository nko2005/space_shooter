class Player {

  float health;
  float posX, posY;
  float angle;
  boolean moveUp, moveDown, moveLeft, moveRight;
  float speed;
  //PImage photo; // To store the player's image
  ArrayList<Bullet> bullets = new ArrayList<Bullet>(); // Store bullets
  float player_score=0.0;
  float moveX,moveY;
  float lookX,lookY;
  float deadzone = 0.1;
  float size =30;
  // Constructor to initialize position and health
  Player(float x, float y, float hp) {
    posX = x;
    posY = y;
    health = hp;
    angle = 0;
    speed =4;
  }

  // Update player position and angle
  
  void updatePlayerAnalog(){
     // Map the analog stick values to a useful range with a dead zone
  float moveX = map(arduino_values[1] - 512, -512, 512, -1, 1);  
  float moveY = map(arduino_values[2] - 512, -512, 512, 1, -1);  
  float lookX = map(arduino_values[3] - 512, -512, 512, -1, 1); 
  float lookY = map(arduino_values[4] - 512, -512, 512, 1, -1); 
     // Apply dead zone to movement inputs
    if (abs(moveX) < deadzone) moveX = 0;
    if (abs(moveY) < deadzone) moveY = 0;
  
    if (abs(lookX) < deadzone) lookX = 0;
    if (abs(lookY) < deadzone) lookY = 0;
    // Update player position
    posX += moveX * speed;
    posY += moveY * speed;
  
  // Update player look direction
   angle = atan2(lookY, lookX);
   
   if(arduino_values[0]==1){
     shoot();
     
     
   }
   
   
    // Move the player based on the movement flags
   
      if (posY<=0) {
        posY -= 0;
      } else {
        posY -= speed;
      }
    

    
      if (posY>=height) {

        posY += 0;
      } else {
        posY += speed;
      }
    
    
      if (posX<=0) {
        posX -= 0;
      } else {
        posX -=speed;
      }
    

    
      if (posX>=width) {
        posX += 0;
      } else {
        posX +=speed;
      }
    
   
   
    
  }
  void updatePlayerMouse() {
    
    // Update the angle to look towards the mouse cursor
    angle = atan2(mouseY - posY, mouseX - posX);

    // Move the player based on the movement flags
    if (moveUp) {
      if (posY<=0) {
        posY -= 0;
      } else {
        posY -= speed;
      }
    }

    if (moveDown) {
      if (posY>=height) {

        posY += 0;
      } else {
        posY += speed;
      }
    }
    if (moveLeft) {
      if (posX<=0) {
        posX -= 0;
      } else {
        posX -=speed;
      }
    }

    if (moveRight) {
      if (posX>=width) {
        posX += 0;
      } else {
        posX +=speed;
      }
    }
  }
  // Create a new bullet in the direction of the mouse
  void shoot() {
    
    Bullet b = new Bullet(posX, posY, angle);
    bullets.add(b); // Add to the list of bullets
  }
  // Update and draw bullets
  void drawPlayerBullets(){
    for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.updateBullet();
    b.displayBullet();
    
    // Check for bullet collision with zombies
    for (int j = zombies.size() - 1; j >= 0; j--) {
      Zombie z = zombies.get(j);
      if (dist(b.posX, b.posY, z.posX, z.posY) < z.size / 2) {
        z.health -= b.damage;
        bullets.remove(i);
        //createParticles(z.posX, z.posY);
        if (z.health <= 0) {
          zombies.remove(j);
          push();
          createParticles(z.posX, z.posY);
          pop();
          player_score+=100;

        }
        break;
      }
    
    
     }
    }
  }
  
  void cleanPlayerBullets(){
    for(int i =bullets.size()-1;i>=0;i--){
    
     Bullet b = bullets.get(i);
     if(b.isOffScreen()){
       bullets.remove(i);
       
     }
    
    
  }
    
  }
  // Display the player on the screen
  void displayPlayer() {
    //pushMatrix();
    push();
     // Draw an equilateral triangle
    translate(posX, posY);
    rotate(angle);

    fill(0, 255, 0);
    stroke(0);
    float h = sqrt(3) / 2 * size; // height of an equilateral triangle
    beginShape();
    rotate(100);
    vertex(-size / 2, h / 2);
    vertex(size / 2, h / 2);
    vertex(0, -h / 2);
    endShape(CLOSE);
    pop();
  }
  
  void resetPlayer(){
    moveUp = player_1.moveDown = moveLeft = moveRight = false;
    speed =4;
    bullets.clear();
    player_score =0;
    health=100;
  }
  
  void displayPlayerHUD() {
  fill(0);
  textSize(24);
  textAlign(LEFT, TOP);
  text("Health: " + health, 10, 10);
  text("Score: " + player_score, 10, 40);
}
  
  
}
