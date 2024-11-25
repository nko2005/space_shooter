class Powerup{
  PImage power_up;
  float modifier;
  float posX;
  float posY;
  float timer;
  color powerup_color;
  boolean consumed = false;
  float lifespan;
  
 // Constructor
  Powerup(float x, float y, float mod,color powerclr) {
    posX = x;
    posY = y;
    modifier = mod;
    timer = 10; // Default timer duration (e.g., 10 seconds)
    powerup_color = powerclr;
    
   
  }
 
  
 void drawPowerup() {
    if (!consumed) { // Don't draw if consumed
      push();
      ellipse(x,y,5,5);
      pop();
    }
  }
  // Check if the power-up is consumed by the player
  void isConsumed(Player player) {
    float distance = dist(player.posX, player.posY, posX, posY); // Check distance to player
    if (distance < 20) {  // If player is close enough to power-up
      consumed = true;
      applyEffect(player); // Apply the power-up effect
    }
  }

  // Apply the effect to the player 
  void applyEffect(Player player) {
    if (powerup_color ==color(255, 0, 0)){
      
      for (int i = player.bullets.size() - 1; i >= 0; i--) {
        Bullet b = player.bullets.get(i);
        b.damage+= b.damage*modifier;
        
      }
    }
    else if(powerup_color ==color(0, 255, 0)){
      player.speed += player.speed*modifier;
       
     }
      
   
  }

}
