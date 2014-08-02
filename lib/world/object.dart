part of gglworld;

class WorldObject {

  // reference to the world
  World myWorld;

  int objectType;

  // velocity
  num xVelocity = 0;
  num yVelocity = 0;
  num angleVelocity = 0;

  // position and orientation
  num x = 0;
  num y = 0;
  num radius;
  num orientation = 0; // orientation in radians, 0 points up, angle expressed clockwise

  // speed and turn rate (ideally constant for a specific instance of an object)
  num speed;
  num turnRate;

  // observable events;
  Subject movementEvent = new Subject();

  final _fullCircle = 2 * math.PI;

  WorldObject (this.radius,this.speed, this.turnRate);

  math.Point projectLocation(elapsedTime) {
    return new math.Point(
        x + xVelocity * elapsedTime,
        y + yVelocity * elapsedTime);
  }

  void doPhysics(num elapsedTime, Map objects) {

  }

  void update(num elapsedTime) {

    x = x + xVelocity * elapsedTime;
    y = y + yVelocity * elapsedTime;

    orientation = orientation + angleVelocity * elapsedTime;

    if (orientation > _fullCircle) {
      orientation = orientation - _fullCircle;
    }
    else if (orientation < 0) {
      orientation = _fullCircle + orientation;
    }
    //if (xVelocity !=0  || yVelocity !=0 || angleVelocity != 0) {
      movementEvent.notify(this, GglEvent.OBJECT_MOVED);
    //}
  }

  bool isInView(num topX, num topY, num bottomX, num bottomY) {
    return ( (x > topX - 100) &&
         (x < bottomX + 100) &&
         (y > topY - 100) &&
         (y < bottomY + 100));
  }

  bool willBump(WorldObject object, num elapsedTime) {
    math.Point p1 = this.projectLocation(elapsedTime);
    math.Point p2 = new math.Point(object.x, object.y);

    return (p1.distanceTo(p2) < (radius + object.radius));
  }
}

class Actor extends WorldObject {

  Queue<Weapon> weapons = new Queue();
  Weapon weapon;


  num _xVelocityHolder = 0;
  num _yVelocityHolder = 0;
  num _45degreeSpeed = 0;

  static const int MAX_LIFE = 100;
  int life = 100;
  num damageFrom = 0;

  Actor():
    super(ActorProps.RADIUS,
        ActorProps.SPEED,
        ActorProps.TURN_RATE)
  {
    weapon = new Pistol(this);
    weapons.addLast(new Rifle(this));
    weapons.addLast(new GrenadeLauncher(this));
    weapons.addLast(new RocketLauncher(this));

    _45degreeSpeed = speed * math.sin(math.PI/4);
  }

  void switchWeapon() {
    if (life == 0 || weapons.isEmpty) return;

    weapons.addLast(weapon);
    weapon = weapons.removeFirst();
  }

  void moveLeft() {
    if (yVelocity > 0) {
      xVelocity = -_45degreeSpeed;
      yVelocity = _45degreeSpeed;
    } else if (yVelocity < 0) {
      xVelocity = -_45degreeSpeed;
      yVelocity = - _45degreeSpeed;
    } else {
      xVelocity = -speed;
    }
  }

  void moveUp () {
    if (xVelocity > 0) {
      xVelocity = _45degreeSpeed;
      yVelocity = -_45degreeSpeed;
    } else if (xVelocity < 0) {
      xVelocity = -_45degreeSpeed;
      yVelocity = -_45degreeSpeed;
    } else {
      yVelocity = -speed;
    }
  }

  void moveRight() {
    if (yVelocity > 0) {
      xVelocity = _45degreeSpeed;
      yVelocity = _45degreeSpeed;
    } else if (yVelocity < 0) {
      xVelocity = _45degreeSpeed;
      yVelocity = - _45degreeSpeed;
    } else {
      xVelocity = speed;
    }
  }

  void moveDown () {
    if (xVelocity > 0) {
      xVelocity = _45degreeSpeed;
      yVelocity = _45degreeSpeed;
    } else if (xVelocity < 0) {
      xVelocity = -_45degreeSpeed;
      yVelocity = _45degreeSpeed;
    } else {
      yVelocity = speed;
    }
  }

  void stopLeftRightMove () {
    xVelocity = 0;
    if (yVelocity < 0)
      yVelocity = -speed;
    else if (yVelocity > 0)
      yVelocity = speed;
  }

  void stopTopDownMove () {
    yVelocity = 0;
    if (xVelocity < 0)
      xVelocity = -speed;
    else if (xVelocity > 0)
      xVelocity = speed;
  }

  bool isMoving() {
    return xVelocity != 0 || yVelocity != 0;
  }

  void turnClockwise() {
    angleVelocity = turnRate;
  }

  void turnCounterClockwise() {
    angleVelocity = -turnRate;
  }

  void turnIncrement(num increment) {
    if (life == 0) return;
    orientation += increment;
  }

  void turnToPoint(num xPt,num yPt) {
    if (life == 0) return;
    orientation = math.PI - math.atan2(xPt-x, yPt-y);
  }

  void stopTurn() {
    angleVelocity = 0;
  }

  void _pauseLeftRightMove() {
    _xVelocityHolder = xVelocity;
    xVelocity = 0;
  }

  void _resumeLeftRightMove() {
    if (_xVelocityHolder == 0) return;

    xVelocity = _xVelocityHolder;
    _xVelocityHolder = 0;
  }

  void _pauseTopDownMove() {
    _yVelocityHolder = yVelocity;
    yVelocity = 0;
  }

  void _resumeTopDownMove() {
    if (_yVelocityHolder == 0) return;

    yVelocity = _yVelocityHolder;
    _yVelocityHolder = 0;
  }

  void takeDamage(int damage, num dmgFrom) {
    life = life - damage;
    damageFrom = dmgFrom;
    if (life < 0) life = 0;
  }

  void doPhysics(num elapsedTime, Map objects) {

    if (life == 0) return;

    objects.forEach((key,object) {
      if (key != this.hashCode) {
        if (object is Actor && object.life == 0) {}
        else if (willBump(object, elapsedTime) ) {
          _pauseLeftRightMove();
          _pauseTopDownMove();
        }
      }
    });

    // wall collision
    var newLoc = projectLocation(elapsedTime);

    if(newLoc.x < x) {
      if (myWorld.grid.bumpLeft(newLoc.x, y, radius)) {
        _pauseLeftRightMove();
      }
    }
    else if (newLoc.x > x) {
      if (myWorld.grid.bumpRight(newLoc.x, y, radius)) {
        _pauseLeftRightMove();
      }
    }

    if(newLoc.y < y) {
      if (myWorld.grid.bumpTop(x, newLoc.y, radius)) {
        _pauseTopDownMove();
      }
    }
    else if(newLoc.y > y) {
      if (myWorld.grid.bumpBottom(x, newLoc.y, radius)) {
        _pauseTopDownMove();
      }
    }

    super.doPhysics(elapsedTime, objects);
  }

  void update(num elapsedTime) {
    if (life == 0) return;
    super.update(elapsedTime);

    _resumeTopDownMove();
    _resumeLeftRightMove();
  }

}

