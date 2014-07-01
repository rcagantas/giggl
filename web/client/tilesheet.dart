part of giggl;

/**
 * 0: concrete
 * 1: wall
 * 2: shrubbery
 */
class TileSheet extends DisplayObjectContainer {
  num type = 0;
  static final num SIZE = 100;
  Shape shape;
  TextField dbg;
  num _index;

  TileSheet(num type) {
    num color = Color.LightGray;
    switch(type) {
      case 1: color = Color.DarkGray; break;
      case 2: color = Color.LightGreen; break;
    }

    shape = new Shape()
      ..graphics.rect(x, y, SIZE, SIZE)
      ..graphics.strokeColor(color, 1)
      ..graphics.fillColor(color)
      ..addTo(this);

    TextFormat tf = new TextFormat('Helvetica', 10, Color.White);
    dbg = new TextField()
      ..x = 5
      ..y = 5
      ..defaultTextFormat = tf
      ..wordWrap = true
      ..addTo(this);
  }

  num get index { return _index; }
  void set index(num i) {
    _index = i;
    dbg.text = "$i";
  }
}