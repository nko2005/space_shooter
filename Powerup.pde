class Powerup { //<>//
  PImage power_up;
  float modifier;
  float posX;
  float posY;
  float timer=15;
  color powerup_color;
  boolean consumed = false;
  float lifespan=15000;
  float spawnTime = millis();
  boolean active =true;
  int type;
  float alpha = 200;
  // Constructor
  Powerup(float x, float y, float mod, color powerclr,int type) {
    posX = x;
    posY = y;
    modifier = mod;
 
    powerup_color = powerclr;
    this.type =type;
  }
  boolean isActive() {
    return active;
  }
  void update() {
    // Check if the power-up's lifespan has expired
    if (millis() - spawnTime > lifespan) {
      active = false;
    }
  }

  void drawPowerup() {
    if (!consumed || lifespan!=0) { // Don't draw if consumed
      push();
      stroke (0, 255, 255);
      fill(powerup_color);
      ellipse(posX, posY, 15, 15);
      pop();
    }
  }
  // Check if the power-up is consumed by the player
  boolean isConsumed() {

    return consumed;
  }

  void checkCollision(Player player) {
    float distance = dist(player.posX, player.posY, posX, posY); // Check distance to player
    if (distance < 20) {  // If player is close enough to power-up
      consumed = true;
      //print("player collided");
      
      activatePowerup(player,type); // Apply the power-up effect
    }
  }
// Method to activate powerups 
void activatePowerup(Player player,int type) {
    if (type == 1) {

        player.hasSpeedPowerup = true;
        player.powerUpTimeSpeed = millis();
    } else if (type == 2) {
        player.hasDamagePowerup = true;
        player.powerUpTimeDamage = millis();
       
       // player.baseSpeed = 100; // store the original speed
    } else if (type == 3) {
        player.hasDoublePowerup = true;
        player.powerUpTimeDouble = millis();
    }
    else{
      push();
      
      fill(255, 255, 255, alpha); 
    noStroke();
     rect(0, 0, width, height); 
     alpha-=1;
      pop();
      
      if (!zombies.isEmpty()) {  // Check if there are zombies to remove
        for (int j = zombies.size() - 1; j >= 0; j--) {
          Zombie z = zombies.get(j); // Get the zombie object
          zombies.remove(j);

          push();
          createParticles(z.posX, z.posY,color(255,0,0));  // Create particles at the zombie's position
          pop();
          player.player_score += 400;  // Increase player score
         
        }
        if(alpha==0){
         alpha =200;
        }
        }
      
    }
}


  // Apply the effect to the player or game
  // all effects are color coded to differentiate what to apply
  //void applyEffect(Player player) {
  //  if (powerup_color == color(255, 0, 0)) {
  //    print("entered dmg powerup");
      
  //    player.hasDamagePowerup = true;
  //    print("applied damage power up");
  //  } else if (powerup_color == color(0, 255, 0)) {
  //    player.speed += player.speed * modifier;
  //    print("applied speed power up");
  //    player.hasSpeedPowerup = true;
  //  } else if (powerup_color == color(255, 165, 0)) {
  //    print("here");

  //    if (!zombies.isEmpty()) {  // Check if there are zombies to remove
  //      for (int j = zombies.size() - 1; j >= 0; j--) {
  //        Zombie z = zombies.get(j); // Get the zombie object
  //        zombies.remove(j);

  //        push();
  //        createParticles(z.posX, z.posY,color(255,0,0));  // Create particles at the zombie's position
  //        pop();
  //        player.player_score += 400;  // Increase player score
  //      }
  //      }
  //  }
  //  else if (powerup_color == color(160, 32, 240)) {
  //    player.hasDoublePowerup = true;
  //    print("applied double points");
  //  }
  //}
}
