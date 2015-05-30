part of gglcommon;

class Surface {
  static const int PASSABLE = 0;
  static const int NON_PASSABLE = 1;
  static const int OBSCURING = 2;
}

class GglEvent {
  static const int OBJECT_MOVED = 1;
  static const int GRENADE_EXPIRES = 2;
}

class ActorProps {
  static const num SPEED = 300;
  static const num TURN_RATE = 2;
  static const num RADIUS = 20;
}

class WeaponType {
  static const int PISTOL = 0;
  static const int RIFLE = 1;
  static const int GRENADE_LAUNCHER = 2;
  static const int ROCKET_LAUNCHER = 3;
}

class WeaponReloadTime {
  static const int PISTOL = 200;
  static const int RIFLE = 100;
  static const int GRENADE_LAUNCHER = 500;
  static const int ROCKET_LAUNCHER = 600;
}

class WeaponAmmo {
  static const int GRENADE_AMMO = 5;
  static const int ROCKET_AMMO = 5;
  static const int RIFLE_AMMO = 200;
}

class WorldConst {
  static const int GRID_WIDTH = 20;
  static const int GRID_HEIGHT = 20;
  static const num TILE_SIZE = 100;
  static const num VIEWPORT_WIDTH = 640;
  static const num VIEWPORT_HEIGHT = 480;
}

class BulletProps {
  static const num RADIUS = 2;
  static const num SPEED = 600;
  static const num DISTANCE = 1000;
  static const num DAMAGE = 10;
}

class GrenadeProps {
  static const num AOE = 150;
  static const num RADIUS = 2;
  static const num SPEED = 300;
  static const num DAMAGE = 10;
  static const num EXPIRE_SEC = 2;
}

class RocketProps {
  static const num AOE = 150;
  static const num RADIUS = 2;
  static const num SPEED = 500;
  static const num DAMAGE = 15;
  static const num DISTANCE = 1000;
}

class BulletType {
  static const int BULLET = 0;
  static const int GRENADE = 1;
  static const int ROCKET = 2;
}

class Bots {
  static List<String> names =
      ['Retroel bot',
       'Happyslurpy bot',
       'Vilatra bot',
       'Bournick bot',
       'Castor Troy bot',
       'Raist bot',
       'Dendi bot',
       'Puppey bot',
       'Iceiceice bot',
       'Singsing bot'];
}

class Comm {
  static const String JOIN_RANDOM = "ggl_game_random:";
  static const String JOIN_GAME = "ggl_game_join:";
  static const String CREATE_GAME = "ggl_game_create:";
  static const String PLAYER_ID = "ggl_id_player:";
  static const String PLAYER_NAME = "ggl_name_player:";
  static const String SURFACE = "ggl_surface:";
  static const String ACTORS = "ggl_actors:";
  static const String BULLETS = "ggl_bullets:";
  static const String FRAME = "ggl_frame:";
  static const String INPUT = "ggl_input:";
  static const String FILL_BOTS = "ggl_fill_bots:";

  static List<String> commandList =
      [JOIN_RANDOM, JOIN_GAME, CREATE_GAME,
      PLAYER_ID, PLAYER_NAME,
      SURFACE, ACTORS, BULLETS, FRAME,
      FILL_BOTS];
}