import 'package:giggl/gglworld.dart';
import 'package:giggl/gglcommon.dart';
import 'package:giggl/gglserver.dart';
import 'dart:convert';

NetServer net;

void main() {
  // STEP 1: Wait for connection
  net = new NetServer("127.0.0.1", 1024);

  // create world
  num width = 20, height = 20;
  var surfaceList = MapGenerator.createSimpleRandomSurface(width, height);
  var grid = new Grid.surface(width, height, 100, surfaceList);
  var world = new World(grid);

  print("waiting for players");
  net.cbWorldId = () { return world.hashCode; };
  net.cbAddPlayer = () { return world.addPlayer(); };
  net.cbPlayerInput = (e) {
    if (e == null) return;
    String s = e.toString();
    if (!s.startsWith(Comm.INPUT)) return;
    s = s.replaceAll(Comm.INPUT, "");
    CommandFrame cf = new CommandFrame.fromString(s);
    for (Actor a in world.actors) {
      if (cf.id == a.hashCode) {
        if (cf.moveX == -1) a.moveLeft();
        else if (cf.moveX == 1) a.moveRight();
        else if (cf.moveX == 0) a.stopLeftRightMove();

        if (cf.moveY == -1) a.moveUp();
        else if (cf.moveY == 1) a.moveDown();
        else a.stopTopDownMove();

        num increment = 0.05;
        if (cf.orientation == -1) a.turnCounterClockwise();
        else if (cf.orientation == 1) a.turnClockwise();
        else a.stopTurn();

        if (cf.fire) a.weapon.fire();
        else a.weapon.stop();

        if (cf.weaponCycle) a.switchWeapon();
      }
    }
  };
  bool started = false;
  world.onReady = () {
    if (started) return;
    List<int> actorCodes = new List();
    List<int> bulletCodes = new List();
    for (Actor a in world.actors)
      actorCodes.add(a.hashCode);
    world.bullets.getBulletIter().forEach((id) {
      bulletCodes.add(id);
    });

    // STEP 2: Publish initializing data to client
    for (Actor a in world.actors) {
      // send player id
      net.send(a.hashCode, Comm.PLAYER_ID + JSON.encode(a.hashCode));
      // 1. publish map detail to client
      net.send(a.hashCode, Comm.SURFACE + JSON.encode(surfaceList));
      // 2. publish all object ids to client (players/bullets/etc)
      net.send(a.hashCode, Comm.ACTORS + JSON.encode(actorCodes));
      net.send(a.hashCode, Comm.BULLETS + JSON.encode(bulletCodes));
      // 3. register the frame listener for each player
      world.addPlayerFrameListener(a.hashCode, framePublisher);
    }
    // at this point everyone is connected;
    started = true;
    // STEP 3: Start game
    world.start();
  };
}

// this is a reference function for the frame publishing call back
void framePublisher (Frame p) {
  num id = p.playerId;
  // compress p and send to client;
  net.send(id, Comm.FRAME + JSON.encode(p.toString()));
}