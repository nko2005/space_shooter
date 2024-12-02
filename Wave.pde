class Wave {
  int waveNumber;
  int enemyCount;
  float enemySpeed;
  float spawnInterval;
  
  Wave(int number, int count, float speed, float interval) {
    waveNumber = number;
    enemyCount = count;
    enemySpeed = speed;
    spawnInterval = interval;
  }
}

ArrayList<Wave> waves = new ArrayList<Wave>();
int currentWaveIndex = 0;
Wave currentWave;

void initializeWaves() {
  waves.clear();
  waves.add(new Wave(1, 10, 1.0, 2.0));
  waves.add(new Wave(2, 15, 1.2, 1.8));
  waves.add(new Wave(3, 20, 1.4, 1.6));
  // Add more waves as needed
}

void updateWave() {
  if (zombies.isEmpty() && currentWaveIndex < waves.size()) {
    currentWave = waves.get(currentWaveIndex);
    spawnWaveEnemies();
    currentWaveIndex++;
  }
}

void spawnWaveEnemies() {
  for (int i = 0; i < currentWave.enemyCount; i++) {
    zombies.add(new Zombie(random(width), random(height), 20, currentWave.enemySpeed));
  }
}

