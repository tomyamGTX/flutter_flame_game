import 'dart:async';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flame_game/flame_game/player.dart';

import 'galaxy.dart';

class SpaceShooterGame extends FlameGame with TapDetector, PanDetector {
  late Player player;
  late Galaxy galaxy;
  late AudioPool pool;
  bool play = true;
  final icon1 = Icons.volume_up;
  final icon2 = Icons.volume_off;
  TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);

  static Paint black = BasicPalette.black.paint();
  static Paint red = const PaletteEntry(Colors.redAccent).paint();
  static Paint bg = const PaletteEntry(Colors.transparent).paint();
  static TextPaint text = TextPaint(
    style: TextStyle(color: BasicPalette.white.color),
  );
  ui.Image? myImageInfo;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await init();
    pool = await FlameAudio.createPool(
      'sfx/fire_2.mp3',
      minPlayers: 3,
      maxPlayers: 4,
    );
    startBgmMusic();
    player = Player();
    galaxy = Galaxy();
    add(galaxy);
    add(player);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.game);
  }

  Rect get volumeIcon => Rect.fromLTWH(size.x - 60, size.y - 760, 50, 50);
  Rect get button1 => Rect.fromLTWH(size.x - 120, size.y - 150, 100, 50);
  Rect get button2 => Rect.fromLTWH(size.x - 120, size.y - 80, 100, 50);
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    //load image
    // paintImage(
    //     canvas: canvas,
    //     rect: Rect.fromLTWH(0, 0, size.x, size.y),
    //     image: myImageInfo!,
    //     repeat: ImageRepeat.repeat,
    //     fit: BoxFit.contain);

    var volumePosition = Offset(size.x - 60, 50.0);
    text.render(
      canvas,
      '(Hold and Drag Ship to move)',
      Vector2(size.x / 2, 200),
      anchor: Anchor.topCenter,
    );

    //load music on icon
    if (play) {
      textPainter.text = TextSpan(
          text: String.fromCharCode(icon1.codePoint),
          style: TextStyle(fontSize: 40.0, fontFamily: icon2.fontFamily));
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.x - 60, 50.0));
      canvas.drawRect(volumeIcon, bg);
    }

    if (!play) {
      //load music off icon
      textPainter.text = TextSpan(
          text: String.fromCharCode(icon2.codePoint),
          style: TextStyle(fontSize: 40.0, fontFamily: icon2.fontFamily));
      textPainter.layout();
      textPainter.paint(canvas, volumePosition);
      canvas.drawRect(volumeIcon, bg);
    }

    //load button fire sound 1
    canvas.drawRect(button1, red);
    text.render(
      canvas,
      'Fire Sound 1',
      Vector2(size.x - 30, size.y - 120),
      anchor: Anchor.bottomRight,
    );

    //load button fire sound 2
    canvas.drawRect(button2, red);
    text.render(
      canvas,
      'Fire Sound 2',
      Vector2(size.x - 30, size.y - 50),
      anchor: Anchor.bottomRight,
    );
  }

  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    if (play) {
      FlameAudio.bgm.play('music/bg_music.ogg');
    } else {
      FlameAudio.bgm.stop();
    }
  }
  //
  // void pauseOrPlayBgmMusic() {
  //   play ? FlameAudio.bgm.pause() : FlameAudio.bgm.resume();
  // }

  void fireOne() {
    FlameAudio.play('sfx/fire_1.mp3');
  }

  void fireTwo() {
    pool.start();
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (button1.containsPoint(info.eventPosition.game)) {
      fireTwo();
    } else if (button2.containsPoint(info.eventPosition.game)) {
      fireOne();
    } else if (volumeIcon.containsPoint(info.eventPosition.game)) {
      play = !play;
      startBgmMusic();
    }
  }

  Future<ui.Image> loadImage(var img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<Null> init() async {
    final ByteData data = await rootBundle.load('assets/images/bg.gif');
    myImageInfo = await loadImage(Uint8List.view(data.buffer));
  }
}
