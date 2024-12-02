//class ShootingEnemy extends Zombie {
//  ArrayList<Bullet> bullets;
//  float shootCooldown;
//  float lastShootTime;

//  ShootingEnemy(float x, float y, float health, PImage spriteSheet, float speed) {
//    super(x, y, health, spriteSheet, speed);
//    bullets = new ArrayList<Bullet>();
//    shootCooldown = 2000; // Shoot every 2 seconds
//    lastShootTime = millis();
//  }

//  void updateShootingEnemy(Player player, ArrayList<Zombie> zombies) {
//    super.updateZombie(player, zombies);
//    if (millis() - lastShootTime > shootCooldown) {
//      shoot(player);
//      lastShootTime = millis();
//    }
//    updateBullets();
//  }

//  void shoot(Player player) {
//    float angle = atan2(player.y - y, player.x - x);
//    bullets.add(new Bullet(x, y, angle, 5, color(255, 0, 0)));
//  }

//  void updateBullets() {
//    for (int i = bullets.size() - 1; i >= 0; i--) {
//      Bullet b = bullets.get(i);
//      b.update();
//      b.display();
//      if (b.isOffScreen()) {
//        bullets.remove(i);
//      } else if (b.checkCollision(player_1)) {
//        player_1.takeDamage(10);
//        bullets.remove(i);
//      }
//    }
//  }

//  void drawShootingEnemy() {
//    super.drawZombie();
//    updateBullets();
//  }
//}
