import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() =>
    runApp(MaterialApp(title: '神山発・旅行ガチャ', home: const HamsterGacha()));

class HamsterGacha extends StatefulWidget {
  const HamsterGacha({super.key});

  @override
  State<HamsterGacha> createState() => _HamsterGachaState();
}

class _HamsterGachaState extends State<HamsterGacha> {
  int n = 0, e = 0;
  bool loading = false;

  final emojis = ['🚶', '🚌', '🚄', '✈️', '🌏'];
  final images = [
    'photos/travel/naruto.jpg',
    'photos/travel/kyoto.jpg',
    'photos/travel/osaka.jpg',
    'photos/travel/tokyo.jpg',
    'photos/travel/miyajima.jpg',
    'photos/travel/okinawa.jpg',
    'photos/travel/taipei.jpg',
    'photos/travel/angkor_wat.jpg',
    'photos/travel/sydney.jpg',
    'photos/travel/colosseum.jpg',
    'photos/travel/grand_canyon.jpg',
    'photos/travel/machu_picchu.jpg',
  ];

  // 神山町役場付近発の参考概算。実際の経路・運賃を調べた値ではない。
  static const destinations = [
    (
      name: '鳴門の渦潮',
      region: '徳島・日本',
      route: '車',
      time: '約1〜2時間',
      cost: '約2,000〜5,000円',
    ),
    (
      name: '金閣寺',
      region: '京都・日本',
      route: 'バス＋電車',
      time: '約5〜7時間',
      cost: '約15,000〜25,000円',
    ),
    (
      name: '大阪城',
      region: '大阪・日本',
      route: 'バス＋電車',
      time: '約4〜6時間',
      cost: '約12,000〜20,000円',
    ),
    (
      name: '浅草寺',
      region: '東京・日本',
      route: '飛行機＋電車',
      time: '約5〜7時間',
      cost: '約30,000〜70,000円',
    ),
    (
      name: '宮島・厳島神社',
      region: '広島・日本',
      route: '車＋フェリー',
      time: '約5〜7時間',
      cost: '約15,000〜30,000円',
    ),
    (
      name: '首里城',
      region: '沖縄・日本',
      route: '飛行機＋公共交通',
      time: '約7〜10時間',
      cost: '約35,000〜90,000円',
    ),
    (
      name: '台北',
      region: '台湾',
      route: '関西空港経由・飛行機',
      time: '約9〜13時間',
      cost: '約50,000〜120,000円',
    ),
    (
      name: 'アンコール・ワット',
      region: 'カンボジア',
      route: '飛行機・乗り継ぎ＋車',
      time: '約15〜24時間',
      cost: '約100,000〜200,000円',
    ),
    (
      name: 'シドニー',
      region: 'オーストラリア',
      route: '飛行機・乗り継ぎ',
      time: '約18〜28時間',
      cost: '約150,000〜300,000円',
    ),
    (
      name: 'ローマ・コロッセオ',
      region: 'イタリア',
      route: '飛行機・乗り継ぎ',
      time: '約22〜32時間',
      cost: '約180,000〜350,000円',
    ),
    (
      name: 'グランドキャニオン',
      region: 'アメリカ',
      route: '飛行機・乗り継ぎ＋車',
      time: '約25〜38時間',
      cost: '約220,000〜450,000円',
    ),
    (
      name: 'マチュ・ピチュ',
      region: 'ペルー',
      route: '飛行機・乗り継ぎ＋鉄道＋バス',
      time: '約40〜60時間以上',
      cost: '約300,000〜600,000円',
    ),
  ];

  Future<void> gacha() async {
    if (loading) return;
    setState(() {
      loading = true;
      e = 0;
    });
    for (int i = 0; i < 15; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() => e = (e + 1) % emojis.length);
    }
    setState(() {
      // 現在の旅行先以外を等確率で選び、必ず写真が変わるようにする。
      n = (n + 1 + Random().nextInt(images.length - 1)) % images.length;
      loading = false;
    });
  }

  Future<void> showCredits() async {
    final credits = await rootBundle.loadString('photos/travel/CREDITS.md');
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('写真の出典・ライセンス'),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(child: SelectableText(credits)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final destination = destinations[n];
    final imageSize = min(
      500.0,
      max(0.0, MediaQuery.sizeOf(context).width - 32),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('神山発・旅行ガチャ')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: imageSize,
                height: imageSize,
                child: loading
                    ? Center(
                        child: Text(
                          emojis[e],
                          style: const TextStyle(fontSize: 100),
                        ),
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(images[n], fit: BoxFit.cover),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: ColoredBox(
                              color: Colors.black54,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  '${destination.name}（${destination.region}）',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 20),
              const Text('神山町役場付近からの参考概算'),
              const SizedBox(height: 8),
              Text('移動手段：${destination.route}', textAlign: TextAlign.center),
              Text('片道の移動時間：${destination.time}', textAlign: TextAlign.center),
              Text('往復交通費：${destination.cost}', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : gacha,
                child: const Text('行き先を引く'),
              ),
              const SizedBox(height: 16),
              const SizedBox(
                width: 500,
                child: Text(
                  '時間・金額は未検証の参考概算で、予約時の運賃ではありません。公共交通は大人1人、車は1台分の目安です。宿泊・食事・入場料・レンタカー代は含みません。便・乗り継ぎ・季節によって大きく変わります。写真は撮影当時のものです。',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
              TextButton(
                onPressed: showCredits,
                child: const Text('写真の出典・ライセンス'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
