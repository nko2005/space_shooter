class Zombie{
  
  float posX, posY;
  float angle;
  float health=100;
  float size =10;
  float speed =0.5;
  float spacing_distance =20;
  Zombie(float x,float y,float s){
    posX = x;
    posY = y;
    size =s;
    
    
  }
 
  
void updateZombie(Player player, ArrayList<Zombie> zombies){
 // Move towards the player
float deltaX = player.posX - posX;
float deltaY = player.posY - posY;

angle = atan2(deltaY, deltaX);  // Get angle towards player

// Move the zombie towards the player 
posX += cos(angle) * speed;
posY += sin(angle) * speed;

// Apply separation behavior
    for (Zombie z : zombies) {
      if (z != this) {
        float distance = dist(posX, posY, z.posX, z.posY);
        if (distance < spacing_distance) {
          float repulsionX = posX - z.posX;
          float repulsionY = posY - z.posY;
          float repulsionAngle = atan2(repulsionY, repulsionX);
          float repulsionStrength = (spacing_distance - distance) / spacing_distance;
          posX += cos(repulsionAngle) * repulsionStrength;
          posY += sin(repulsionAngle) * repulsionStrength;
        }
      }
   
 }
 
}

void drawZombie() {
    push();
    translate(posX, posY);
    rotate(angle);

    fill(255, 0, 0);
    stroke(0);
    
    // Draw an equilateral triangle
    float h = sqrt(3) / 2 * size; // height of an equilateral triangle
    beginShape();
    rotate(100);
    vertex(-size / 2, h / 2);
    vertex(size / 2, h / 2);
    vertex(0, -h / 2);
    endShape(CLOSE);

    pop();
  }
  
}
