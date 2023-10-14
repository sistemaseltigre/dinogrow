import 'package:dinogrow/pages/mini-games/up/buttons.dart';
import 'package:dinogrow/pages/mini-games/up/objects/dino.dart';
import 'package:flame/palette.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'objects/floor.dart';
import 'objects/box.dart';
import 'package:flame/timer.dart' as timer_flame;
import 'package:url_launcher/url_launcher.dart';

import '../../../anchor_types/score_parameters.dart' as anchor_types_parameters;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solana/solana.dart';
import 'package:solana/solana.dart' as solana;
import 'package:solana/anchor.dart' as solana_anchor;
import 'package:solana/encoder.dart' as solana_encoder;
import 'package:solana_common/utils/buffer.dart' as solana_buffer;

final screenSize = Vector2(720, 1280);

// Scaled viewport size
final worldSize = Vector2(7.2, 12.8);

class DownGame extends Forge2DGame with TapDetector {
  final void Function(String) endGameCallback;
  // setup the game camera to match the device size
  DownGame(this.endGameCallback) : super(zoom: 100, gravity: Vector2(0, 15));

  //get the dino object and sprite animation
  final dino = Dino();

  //set initial state of the game buttons
  bool isJumpPressed = false;
  bool isLeftPressed = false;
  bool isRightPressed = false;
  bool isAttackPressed = false;

  //Timer callbacks
  timer_flame.Timer timer = timer_flame.Timer(0);

  //set initial score
  int score = 0;
  late TextComponent scoreText;

  // get the buttons
  final btnLeft = VirtualPadButtons().vpadbuttons()[0];
  final btnRight = VirtualPadButtons().vpadbuttons()[1];
  final btnJump = VirtualPadButtons().vpadbuttons()[2];
  final btnAttack = VirtualPadButtons().vpadbuttons()[3];
  final btnJumpText = VirtualPadButtons().vpadbuttons()[4];
  final btnAttackText = VirtualPadButtons().vpadbuttons()[5];

  // check and verify if the button is pressed
  bool isInsideButton(Vector2 tapPosition, RectangleComponent button) {
    final buttonRect = button.toRect();
    return buttonRect.contains(tapPosition.toOffset());
  }

  @override
  bool onTapDown(TapDownInfo info) {
    final tapPosition = info.eventPosition.game;

    if (isInsideButton(tapPosition, btnLeft)) {
      isLeftPressed = true;
    }
    if (isInsideButton(tapPosition, btnRight)) {
      isRightPressed = true;
    }
    if (isInsideButton(tapPosition, btnJump)) {
      isJumpPressed = true;
    }
    if (isInsideButton(tapPosition, btnAttack)) {
      isAttackPressed = true;
    }

    if (isLeftPressed) {
      btnLeft.paint.color = const Color.fromARGB(255, 91, 92, 91);
      isRightPressed = false;
      btnRight.paint.color = BasicPalette.yellow.color;

      dino.walkLeft();

      timer =
          timer_flame.Timer(0.25, onTick: () => dino.walkLeft(), repeat: true);
    }
    if (isRightPressed) {
      btnRight.paint.color = const Color.fromARGB(255, 91, 92, 91);
      isLeftPressed = false;
      btnLeft.paint.color = BasicPalette.yellow.color;

      dino.walkRight();

      timer =
          timer_flame.Timer(0.25, onTick: () => dino.walkRight(), repeat: true);
    }
    // if (isJumpPressed) {
    //   dino.jump();
    //   score += 10;
    //   scoreText.text = 'Score: ${score.toString().padLeft(3, '0')}';
    //   btnJump.paint.color = const Color.fromARGB(255, 91, 92, 91);
    // }
    // if (isAttackPressed) {
    //   dino.run();
    //   btnAttack.paint.color = const Color.fromARGB(255, 91, 92, 91);
    // }

    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    if (isLeftPressed) {
      isLeftPressed = false;
      btnLeft.paint.color = BasicPalette.yellow.color;
    }
    if (isRightPressed) {
      isRightPressed = false;
      btnRight.paint.color = BasicPalette.yellow.color;
    }
    // if (isJumpPressed) {
    //   isJumpPressed = false;
    //   btnJump.paint.color = BasicPalette.gray.color;
    // }
    // if (isAttackPressed) {
    //   isAttackPressed = false;
    //   btnAttack.paint.color = BasicPalette.gray.color;
    // }
    timer.stop();

    return true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final camera =
        CameraComponent.withFixedResolution(width: 720, height: 1280);
    final background = _Background(size: screenSize);
    camera.viewport.add(background);
    if (dino.isLoaded) {
      camera.follow(dino.currentComponent, verticalOnly: true);
    }
    // camera.follow(dino.c,verticalOnly: true);

    // add(FpsTextComponent(
    //     position: Vector2(0, 7.8),
    //     scale: Vector2(0.01, 0.01),
    //     anchor: Anchor.topLeft,
    //     windowSize: 60,
    //     textRenderer: TextPaint(style: const TextStyle(color: Colors.white))));

    add(Floor());
    add(LeftWall());
    add(RightWall());

    //Testing
    // Add instance of Box

    finishGame() {
      endGameCallback('$score');
    }

    newBoxAndScore() {
      score += 1;
      scoreText.text = 'Score: ${score.toString().padLeft(3, '0')}';
      add(Box(newBoxAndScore, finishGame));
    }

    add(Box(newBoxAndScore, finishGame));

    // add the player to the game
    add(dino);

    // add the buttons to the game
    add(btnLeft);
    add(btnRight);
    // add(btnJump);
    // add(btnAttack);
    add(btnJumpText);
    add(btnAttackText);

    // Score text
    final btnStyleLetters = TextPaint(
        style: const TextStyle(
      fontSize: 0.2,
      color: Colors.white,
      fontFamily: 'ComicNeue Bold',
    ));

    scoreText = TextComponent(
      text: 'Score: 000',
      anchor: Anchor.topRight,
      position: Vector2(3.7, 0.65),
      textRenderer: btnStyleLetters,
    );

    add(scoreText);
  }

  @override
  Color backgroundColor() => const Color(0x00077777);

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }
}

class _Background extends PositionComponent {
  _Background({super.size});
  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()..color = const Color.fromARGB(255, 56, 53, 53));
  }
}

class GameWidgetDown extends StatefulWidget {
  const GameWidgetDown({super.key});

  @override
  State<GameWidgetDown> createState() => _GameWidgetDownState();
}

class _GameWidgetDownState extends State<GameWidgetDown> {
  DownGame game = DownGame((String data) {});
  bool loading = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      game = DownGame(showEndMessage);
    });

    Future.delayed(const Duration(milliseconds: 500), showWelcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/up/maps/01/up_map_1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : GameWidget(game: game),
      ),
    );
  }

  showWelcome() {
    setState(() {
      loading = true;
    });
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Welcome to Down'),
        content: const Text(
            "The aim of this minigame is avoid all boxes that come from up, while you avoid more boxes you will have great score, good luck and ... \n\n¡Watch out with the boxes! \n\nREMEMBER: you could save your score on the blockchain but you'll need at least 0.5 SOL in your wallet balance"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Go back'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                loading = false;
              });
            },
            child: const Text("Let's go!"),
          ),
        ],
      ),
    );
  }

  showEndMessage(String score) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Ups ... game ended :('),
        content: Text(
            "Thanks for play! Congrats you score was: $score \n\nDo you want to save and share it in Ranking? Remember this has a cost so you must have at least 0.5 SOL in your wallet balance."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showWelcome();
            },
            child: const Text('Try again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              saveScore(int.parse(score));
            },
            child: const Text("Send my score"),
          ),
        ],
      ),
    );
  }

  showrResultMessage(String transaction) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Score saved'),
        content: Text(
            "Perfect! You score is now in Ranking, good luck! \n\nIf you want you can review information on blockchain with this transaction reference: \n\n $transaction"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _launchUrl();
            },
            child: const Text('View transaction'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Go to minigames"),
          ),
        ],
      ),
    );
  }

  saveScore(int score) async {
    try {
      setState(() {
        loading = true;
      });

      await dotenv.load(fileName: ".env");

      SolanaClient? client;
      client = SolanaClient(
        rpcUrl: Uri.parse(dotenv.env['QUICKNODE_RPC_URL'].toString()),
        websocketUrl: Uri.parse(dotenv.env['QUICKNODE_RPC_WSS'].toString()),
      );
      const storage = FlutterSecureStorage();

      final mainWalletKey = await storage.read(key: 'mnemonic');

      final mainWalletSolana = await solana.Ed25519HDKeyPair.fromMnemonic(
        mainWalletKey!,
      );

      const programId = '9V9ttZw7WTYW78Dx3hi2hV7V76PxAs5ZwbCkGi7qq8FW';
      final systemProgramId =
          solana.Ed25519HDPublicKey.fromBase58(solana.SystemProgram.programId);

      //direccion mint del DINO
      String? dinoSelected = await storage.read(key: 'dinoSelected');

      if (dinoSelected == null) {
        throw "You don't have dino selected";
      }

      final dinoTest = solana.Ed25519HDPublicKey.fromBase58(dinoSelected);

      final programIdPublicKey =
          solana.Ed25519HDPublicKey.fromBase58(programId);

      final gscorePda = await solana.Ed25519HDPublicKey.findProgramAddress(
          programId: programIdPublicKey,
          seeds: [
            solana_buffer.Buffer.fromString("score"),
            mainWalletSolana.publicKey.bytes,
            dinoTest.bytes,
            solana_buffer.Buffer.fromInt32(1),
          ]);
      // print(gscorePda.toBase58());

      final instructions = [
        await solana_anchor.AnchorInstruction.forMethod(
          programId: programIdPublicKey,
          method: 'savescore',
          arguments:
              solana_encoder.ByteArray(anchor_types_parameters.ScoreArguments(
            game: 1,
            score: score,
          ).toBorsh().toList()),
          accounts: <solana_encoder.AccountMeta>[
            solana_encoder.AccountMeta.writeable(
                pubKey: gscorePda, isSigner: false),
            solana_encoder.AccountMeta.writeable(
                pubKey: mainWalletSolana.publicKey, isSigner: true),
            solana_encoder.AccountMeta.writeable(
                pubKey: dinoTest, isSigner: false),
            solana_encoder.AccountMeta.readonly(
                pubKey: systemProgramId, isSigner: false),
          ],
          namespace: 'global',
        ),
      ];
      final message = solana.Message(instructions: instructions);
      final signature = await client.sendAndConfirmTransaction(
        message: message,
        signers: [mainWalletSolana],
        commitment: solana.Commitment.confirmed,
      );

      print('Tx successful with hash: $signature');
      showrResultMessage(signature);
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(
          'Error: $e',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}

Future<void> _launchUrl() async {
  Uri url = Uri(scheme: 'https', host: 'x.com', path: '/din0gr0w');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
