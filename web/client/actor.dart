part of giggl;

class Actor extends DisplayObjectContainer {
  Bitmap torso;
  List<Bitmap> weaponBmps = [];
  List<String> weaponNames = ['pistol','rifle','grenade','rocket'];
  FlipBook hip;
  static const num CENTER = 48.5; //center of player tile
  TextField dbg;

  Actor() {
    hip = new FlipBook(ResourceHandler.ac_stride, 10)
      ..addTo(this)
      ..x = -7
      ..y = 8
      ..pivotX = CENTER -7
      ..pivotY = CENTER + 8
      ..play();
    stage.juggler.add(hip);

    torso = new Bitmap(resMgr.getBitmapData("ac_torso"))
      ..pivotX = CENTER
      ..pivotY = CENTER
      ..addTo(this);

    for (String weaponName in weaponNames) {
      Bitmap bmp = new Bitmap(resMgr.getBitmapData("ac_${weaponName}"))
        ..visible = weaponName == "pistol"? true: false
        ..pivotX = CENTER
        ..pivotY = CENTER
        ..addTo(this);
      weaponBmps.add(bmp);
    }

    x = stage.stageWidth/2;
    y = stage.stageHeight/2;

    TextFormat tf = new TextFormat('Helvetica', 10, Color.Red);
    dbg = new TextField()
      ..defaultTextFormat = tf
      ..x = 30
      ..y = 30
      ..width = 200
      ..height = 200
      ..wordWrap = true
      ..addTo(this);
  }


  void move(num x, num y) {
    if (this.x == x && this.y == y) {
      hip.gotoAndStop(0);
      return;
    }
    if (!hip.playing) hip.play();
    fixHipRotation(x, y);
    this.x = x;
    this.y = y;
  }

  void fixHipRotation(num x, num y) {
    num dx = x - this.x;
    num dy = y - this.y;
    num hrad = math.atan2(dy, dx) + math.PI/2;
    num trad = this.rotation;

    num val = peg180(hrad - trad);
    val = val.abs() > math.PI/2? val - math.PI: val;
    hip.rotation = peg180(val);
    displayAngles();
  }

  void turn(num r) {
    if (this.rotation == r) return;
    this.rotation = peg180(r);
    fixHipRotation(this.x, this.y);
  }

  void torsoRotate(num r) { turn(this.rotation + r); }

  /** there's probably easier ways to do this. */
  num peg180(num val) {
    num max = math.PI;
    num min = -math.PI;
    val -= min;
    max -= min;
    if (max == 0) return min;
    val = val % max;
    val += min;
    while (val < min) val += max;
    return val;
  }

  void displayAngles() {
    dbg.rotation = -this.rotation;
    dbg.text = "all: ${(this.rotation * 180/math.PI).toStringAsFixed(2)}\n"
      + "hip: ${(hip.rotation * 180/math.PI).toStringAsFixed(2)}";
  }

  String cycleWeapon() {
    num index = 0;
    for (Bitmap weapon in weaponBmps) {
      if (weapon.visible == true) {
        index = weaponBmps.indexOf(weapon);
        weapon.visible = false;
        index = index + 1 >= weaponBmps.length? 0: index + 1;
        weaponBmps[index].visible = true;
        break;
      }
    }
    return weaponNames[index];
  }
}