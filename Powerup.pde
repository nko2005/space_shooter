class Powerup { //<>//
  PImage power_up;
  float modifier;
  float posX;
  float posY;
  float timer;
  color powerup_color;
  boolean consumed = false;
  float lifespan=15000;
  float spawnTime = millis();
  boolean active =true;
  // Constructor
  Powerup(float x, float y, float mod, color powerclr) {
    posX = x;
    posY = y;
    modifier = mod;
    timer = 10; // Default timer duration (e.g., 10 seconds)
    powerup_color = powerclr;
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
      print("player collided");
      applyEffect(player); // Apply the power-up effect
    }
  }



  // Apply the effect to the player or game
  // all effects are color coded to differentiate what to apply
  void applyEffect(Player player) {
    if (powerup_color == color(255, 0, 0)) {
      print("entered dmg powerup");
      for (int i = player.bullets.size() - 1; i >= 0; i--) {
        Bullet b = player.bullets.get(i);
        b.damage += b.damage * modifier;
      }
      player.hasDamagePowerup = true;
      print("applied damage power up");
    } else if (powerup_color == color(0, 255, 0)) {
      player.speed += player.speed * modifier;
      print("applied speed power up");
      player.hasSpeedPowerup = true;
    } else if (powerup_color == color(255, 165, 0)) {
      print("here");

      if (!zombies.isEmpty()) {  // Check if there are zombies to remove
        for (int j = zombies.size() - 1; j >= 0; j--) {
          Zombie z = zombies.get(j); // Get the zombie object
          zombies.remove(j);

          push();
          createParticles(z.posX, z.posY);  // Create particles at the zombie's position
          pop();
          player.player_score += 400;  // Increase player score
        }
        }
    }
    else if (powerup_color == color(160, 32, 240)) {
      player.hasDoublePowerup = true;
      print("applied double points");
    }
  }
}
