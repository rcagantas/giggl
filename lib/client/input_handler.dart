part of gglclient;

class InputHandler {
  Map<num, bool> keyState = new Map<num, bool>();
  num mouseX = 0, mouseY = 0;
  bool mouseL = false, mouseR = false;
  TextField dbg;

  InputHandler() {
    stage.focus = stage;
    stage.onKeyDown.listen(_keyHandler);
    stage.onKeyUp.listen(_keyHandler);
    stage.onMouseMove.listen((e) {mouseX = e.stageX; mouseY = e.stageY;});
    stage.onMouseDown.listen((e) => mouseL = true);
    stage.onMouseUp.listen((e) => mouseL = false);

    for(num i = 0; i < 255; i++) keyState[i] = false;

    var fps = null;
    stage.onEnterFrame.listen((EnterFrameEvent e) {
      String keyPressed = "keypressed: ";
      for (num i = 0; i < 255; i++)
        if (keyState[i]) keyPressed += "$i ";

      fps = fps == null
          ? 1.00 / e.passedTime
          : 0.05 / e.passedTime + 0.95 * fps;

      dbg.text = "fps: ${fps.round()}\n" +
          keyPressed;
    });

    TextFormat tf = new TextFormat('Open Sans', 14, Color.Black);
    dbg = new TextField()
      ..defaultTextFormat = tf
      ..x = 30
      ..y = 30
      ..width = 200
      ..height = 200
      ..wordWrap = true
      ..addTo(stage);
  }

  void _keyHandler(KeyboardEvent e) {
    keyState[e.keyCode] = e.type == KeyboardEvent.KEY_DOWN? true: false;
  }
}

