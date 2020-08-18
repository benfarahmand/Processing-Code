class Ant {
  float dx = random(-1, 1);
  float dy = random(-1, 1);
  float x;
  float y;
  int intX;
  int intY;
  int lastX;
  int lastY;
  int homeX;
  int homeY;
  int id;
  int SpeedLimit = 5;

  boolean hasFood = false;

  float homePher = 100;
  float foodPher = 100;
  private float USE_RATE = .995;
  private float WANDER_CHANCE = .92;

  float bored = 0.0;

  Map homeMap;
  Map foodMap;

  Ant(int _x, int _y, Map _homePher, Map _foodMap, int _id) {
    intX = homeX = _x;
    intY = homeY = _y;
    x = float(_x);
    y = float(_y);
    homeMap = _homePher;
    foodMap = _foodMap;
    id = _id;
  }

  void step() {
    // Wander chance .1 
    if (random(1) > WANDER_CHANCE) dx += random(-1*SpeedLimit, 1*SpeedLimit);
    if (random(1) > WANDER_CHANCE) dy += random(-1*SpeedLimit, 1*SpeedLimit);
    if (random(1) > .99) bored += random(15);
    
    if (bored>0) {
      // Ignore pheromones
      bored--;
    } else {
      // Sniff trails
      if (hasFood) {
        // Look for home 
        int[] direction = homeMap.getStrongest(intX, intY, SpeedLimit);
        dx += direction[0] * random(1.5);
        dy += direction[1] * random(1.5);
      }
      else
      {
        // Look for food 
        int[] direction = foodMap.getStrongest(intX, intY, SpeedLimit);
        dx += direction[0] * random(1.5);
        dy += direction[1] * random(1.5);
      }
    }
    // Bounding limits, bounce off of edge
    if (x<2) dx = 1*SpeedLimit;
    if (x>width-2) dx = -1*SpeedLimit;
    if (y<2) dy = 1*SpeedLimit;
    if (y>height-2) dy = -1*SpeedLimit;
    // Speed limit
    dx = Math.min(dx, 1*SpeedLimit);
    dx = Math.max(dx, -1*SpeedLimit);
    dy = Math.min(dy, 1*SpeedLimit);
    dy = Math.max(dy, -1*SpeedLimit);
    // Move
    x += dx;
    y += dy;
    intX = floor(x);
    intY = floor(y);

    // Only if ant has moved enough (to another pixel)
    if (lastX!=intX || lastY!=intY) {
      // Leave trails
      if (hasFood) {
        // Leave food pheromone trail
        foodPher = foodPher * USE_RATE;
        //if(foodPher<1) foodPher=0;
        foodMap.setValue(intX, intY, dx, dy, foodPher);
      }
      else
      {
        // Leave home pheromone trail
        homePher = homePher * USE_RATE;
        //if(homePher<1) homePher=0;
        homeMap.setValue(intX, intY, homePher);
      }
    }

    lastX = intX;
    lastY = intY;
  }
}
