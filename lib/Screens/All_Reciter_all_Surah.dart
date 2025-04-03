import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';

class Reciter {
  final int id;
  final String arabicName;
  final String baseUrl;
  final String audioPath;
  Reciter({
    required this.id,
    required this.arabicName,
    required this.baseUrl,
    required this.audioPath,
  });
}
List<Reciter> reciters = [
  Reciter(
    id: 1,
    arabicName: "المنشاوى",
    baseUrl: "https://server10.mp3quran.net",
    audioPath: "/minsh",
  ),
  Reciter(
    id: 2,
    arabicName: "محمود خليل الحصري",
    baseUrl: "https://server13.mp3quran.net",
    audioPath: "/husr",
  ),
  Reciter(
    id: 3,
    arabicName: "مشارى العفاسى",
    baseUrl: "https://server8.mp3quran.net",
    audioPath: "/afs",
  ),
  Reciter(
    id: 4,
    arabicName: "ماهر المعقلى",
    baseUrl: "https://server12.mp3quran.net",
    audioPath: "/maher",
  ),
  Reciter(
    id: 5,
    arabicName: "عبد الباسط عبد الصمد",
    baseUrl: "https://server7.mp3quran.net",
    audioPath: "/basit/Almusshaf-Al-Mojawwad",
  ),
  Reciter(
    id: 6,
    arabicName: "محمود على البنا",
    baseUrl: "https://server8.mp3quran.net",
    audioPath: "/bna",
  ),
  Reciter(
    id: 7,
    arabicName: "الطبلاوى",
    baseUrl: "https://server12.mp3quran.net",
    audioPath: "/tblawi",
  ),
  Reciter(
    id: 8,
    arabicName: "اسلام صبحى",
    baseUrl: "https://server14.mp3quran.net",
    audioPath: "/islam/Rewayat-Hafs-A-n-Assem",
  ),
  Reciter(
    id: 9,
    arabicName: "احمد نعينع",
    baseUrl: "https://server11.mp3quran.net",
    audioPath: "/ahmad_nu",
  ),
  Reciter(
    id: 10,
    arabicName: "سعد الغامدى",
    baseUrl: "https://server7.mp3quran.net",
    audioPath: "/s_gmd",
  ),
  Reciter(
    id: 11,
    arabicName: " ناصر القطامى",
    baseUrl: "https://server6.mp3quran.net",
    audioPath: "/qtm",
  ),
  Reciter(
    id: 12,
    arabicName: "شعبان الصياد",
    baseUrl: "https://server11.mp3quran.net",
    audioPath: "/shaban",
  ),
  Reciter(
    id: 13,
    arabicName: "على جابر",
    baseUrl: "https://server11.mp3quran.net",
    audioPath: "/a_jbr",
  ),
  Reciter(
    id: 14,
    arabicName: "ياسر الدوسرى",
    baseUrl: "https://server11.mp3quran.net",
    audioPath: "/yasser",
  ),
  Reciter(
    id: 15,
    arabicName: " محمد رفعت",
    baseUrl: "https://server14.mp3quran.net",
    audioPath: "/refat",
  ),
];
int defaultReciterId = 1;

Future<List<Surah>> loadSurahs() async {
  try {
    Dio dio = Dio();
    Response response = await dio.get("https://api.alquran.cloud/v1/surah");

    if (response.statusCode == 200) {
      List<dynamic> jsonList = response.data['data'];
      return jsonList.map((json) => Surah.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load surahs");
    }
  } catch (e) {
    throw Exception("Error: $e");
  }
}

class Surah {
  final int surahNumber;
  final String surahName;
  final int numberOfAyahs;

  Surah({
    required this.surahNumber,
    required this.surahName,
    required this.numberOfAyahs,
  });

  String getAudioUrl(Reciter reciter) {
    String formattedSurah = surahNumber.toString().padLeft(3, '0');
    return "${reciter.baseUrl}${reciter.audioPath}/${formattedSurah}.mp3";
  }

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      surahNumber: json['number'],
      surahName: json['englishName'],
      numberOfAyahs: json['numberOfAyahs'],
    );
  }
}


class SurahListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('قائمة سور القرآن الكريم', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Surah>>(
        future: loadSurahs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد سور', style: TextStyle(fontSize: 18, color: Colors.grey)));
          } else {
            List<Surah> surahs = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                Surah surah = surahs[index];
                List<String> arabicNames = [
                  'الفاتحة', 'البقرة', 'آل عمران', 'النساء', 'المائدة', 'الأنعام',
                  'الأعراف', 'الأنفال', 'التوبة', 'يونس', 'هود', 'يوسف', 'الرعد', 'إبراهيم',
                  'الحجر', 'النحل', 'الإسراء', 'الكهف', 'مريم', 'طه', 'الأنبياء', 'الحج',
                  'المؤمنون', 'النور', 'الفرقان', 'الشعراء', 'النمل', 'القصص', 'العنكبوت',
                  'الروم', 'لقمان', 'السجدة', 'الأحزاب', 'سبأ', 'فاطر', 'يس', 'الصافات', 'ص',
                  'الزمر', 'غافر', 'فصلت', 'الشورى', 'الزخرف', 'الدخان', 'الجاثية', 'الأحقاف',
                  'محمد', 'الفتح', 'الحجرات', 'ق', 'الذاريات', 'الطور', 'النجم', 'القمر',
                  'الرحمن', 'الواقعة', 'الحديد', 'المجادلة', 'الحشر', 'الممتحنة', 'الصف',
                  'الجمعة', 'المنافقون', 'التغابن', 'الطلاق', 'التحريم', 'الملك', 'القلم',
                  'الحاقة', 'المعارج', 'نوح', 'الجن', 'المزمل', 'المدثر', 'القيامة', 'الإنسان',
                  'المرسلات', 'النبأ', 'النازعات', 'عبس', 'التكوير', 'الانفطار', 'المطففين',
                  'الانشقاق', 'البروج', 'الطارق', 'الأعلى', 'الغاشية', 'الفجر', 'البلد',
                  'الشمس', 'الليل', 'الضحى', 'الشرح', 'التين', 'العلق', 'القدر', 'البينة',
                  'الزلزلة', 'العاديات', 'القارعة', 'التكاثر', 'العصر', 'الهمزة', 'الفيل',
                  'قريش', 'الماعون', 'الكوثر', 'الكافرون', 'النصر', 'المسد', 'الإخلاص', 'الفلق',
                  'الناس'
                ];


                String arabicSurahName = arabicNames[surah.surahNumber - 1];

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade200,
                      child: Text('${surah.surahNumber}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(
                      arabicSurahName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal),
                    ),
                    subtitle: Text('${surah.surahName}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    trailing: Icon(Icons.play_arrow, color: Colors.teal, size: 30),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurahPlayerScreen(surah: surah),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Reciter',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // List of reciters
          ...reciters.map((reciter) => RadioListTile<int>(
            title: Text(reciter.arabicName),
            value: reciter.id,
            groupValue: defaultReciterId,
            onChanged: (value) {
              setState(() {
                defaultReciterId = value!;
              });
            },
          )).toList(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaybackRangeSettings {
  bool enabled;
  Duration startTime;
  Duration endTime;
  int repeatCount;

  PlaybackRangeSettings({
    this.enabled = false,
    this.startTime = Duration.zero,
    this.endTime = Duration.zero,
    this.repeatCount = 1,
  });
}

class SurahPlayerScreen extends StatefulWidget {
  final Surah surah;

  SurahPlayerScreen({required this.surah});

  @override
  _SurahPlayerScreenState createState() => _SurahPlayerScreenState();
}

class _SurahPlayerScreenState extends State<SurahPlayerScreen> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  bool isLoading = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String? errorMessage;

  PlaybackRangeSettings rangeSettings = PlaybackRangeSettings();
  int currentRepeatCount = 0;

  Reciter get currentReciter {
    return reciters.firstWhere((r) => r.id == defaultReciterId,
        orElse: () => reciters[0]);
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    setupAudioPlayerListeners();
    loadAudio();
  }

  void setupAudioPlayerListeners() {
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        setState(() {
          isPlaying = true;
          isLoading = false;
          errorMessage = null;
        });
      } else if (state == PlayerState.paused || state == PlayerState.stopped) {
        setState(() {
          isPlaying = false;
          isLoading = false;
        });
      } else if (state == PlayerState.completed) {
        handlePlaybackCompleted();
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
        if (rangeSettings.endTime == Duration.zero) {
          rangeSettings.endTime = newDuration;
        }
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });

      if (rangeSettings.enabled && isPlaying) {
        if (position >= rangeSettings.endTime) {
          handleRangeEnd();
        }
      }
    });
  }

  void handleRangeEnd() async {
    if (currentRepeatCount < rangeSettings.repeatCount - 1) {
      currentRepeatCount++;
      await seekAudio(rangeSettings.startTime);
    } else {
      currentRepeatCount = 0;
      await audioPlayer.pause();
      await seekAudio(rangeSettings.endTime);
    }
  }

  void handlePlaybackCompleted() {
    setState(() {
      isPlaying = false;
      position = Duration.zero;
    });
    currentRepeatCount = 0;
  }

  Future<void> loadAudio() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      String audioUrl = widget.surah.getAudioUrl(currentReciter);

      await audioPlayer.stop();
      await audioPlayer.setSource(UrlSource(audioUrl));

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        if (e.toString().contains("MEDIA_ELEMENT_ERROR") ||
            e.toString().contains("no supported sources")) {
          errorMessage = "جرب مقرئ آخر لا يوجد تسجيل لهذه السوره مع هذا المقرئ ";
        } else {
          errorMessage = "حدث خطأ أثناء التحميل";
        }
      });
      print("Error loading audio: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? "حدث خطأ أثناء التحميل"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> playPauseAudio() async {
    try {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        setState(() {
          errorMessage = null;
        });

        if (rangeSettings.enabled && position >= rangeSettings.endTime) {
          await seekAudio(rangeSettings.startTime);
        }
        if (rangeSettings.enabled && position < rangeSettings.startTime) {
          await seekAudio(rangeSettings.startTime);
        }
        await audioPlayer.resume();
      }
    } catch (e) {
      print("Error with playback: $e");

      if (e.toString().contains("NotSupportedError") ||
          e.toString().contains("no supported sources")) {
        setState(() {
          errorMessage = "جرب مقرئ آخر لا يوجد لها تسجيل مع هذا المقرئ";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    setState(() {
      position = Duration.zero;
      currentRepeatCount = 0;
    });
  }

  Future<void> seekAudio(Duration newPosition) async {
    await audioPlayer.seek(newPosition);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours == "00" ? "$minutes:$seconds" : "$hours:$minutes:$seconds";
  }

  void showRangeSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Playback Range Settings'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: Text('Enable Range Playback'),
                    value: rangeSettings.enabled,
                    onChanged: (value) {
                      setState(() {
                        rangeSettings.enabled = value;
                        if (value) {
                          this.setState(() {
                          });
                        }
                      });
                    },
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Start Time: ${formatDuration(rangeSettings.startTime)}'),
                  ),
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: rangeSettings.startTime.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
                    onChanged: rangeSettings.enabled ? (value) {
                      setState(() {
                        rangeSettings.startTime = Duration(seconds: value.toInt());
                        if (rangeSettings.startTime > rangeSettings.endTime) {
                          rangeSettings.startTime = rangeSettings.endTime;
                        }
                      });
                    } : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('End Time: ${formatDuration(rangeSettings.endTime)}'),
                  ),
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: rangeSettings.endTime.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
                    onChanged: rangeSettings.enabled ? (value) {
                      setState(() {
                        rangeSettings.endTime = Duration(seconds: value.toInt());
                        // Ensure end is after start
                        if (rangeSettings.endTime < rangeSettings.startTime) {
                          rangeSettings.endTime = rangeSettings.startTime;
                        }
                      });
                    } : null,
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Repeat Count'),
                    subtitle: Text('How many times to repeat this range'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: rangeSettings.enabled && rangeSettings.repeatCount > 1 ? () {
                            setState(() {
                              rangeSettings.repeatCount--;
                            });
                          } : null,
                        ),
                        Text('${rangeSettings.repeatCount}', style: TextStyle(fontSize: 18)),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: rangeSettings.enabled ? () {
                            setState(() {
                              rangeSettings.repeatCount++;
                            });
                          } : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: Text('Apply'),
                onPressed: () {
                  this.setState(() {
                    if (rangeSettings.enabled) {
                      if (isPlaying) {
                        seekAudio(rangeSettings.startTime);
                      }
                      currentRepeatCount = 0;
                    }
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sliderValue = position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble());
    double startPercent = rangeSettings.enabled ?
    (rangeSettings.startTime.inSeconds / duration.inSeconds.clamp(1, double.infinity)) : 0;
    double endPercent = rangeSettings.enabled ?
    (rangeSettings.endTime.inSeconds / duration.inSeconds.clamp(1, double.infinity)) : 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.surahName),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        widget.surah.surahName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.surah.surahName,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Surah ${widget.surah.surahNumber} • ${widget.surah.numberOfAyahs} verses',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'القارئ : ${currentReciter.arabicName}',
                        style: TextStyle(fontSize: 14, color: Colors.teal),
                      ),
                      if (rangeSettings.enabled)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Range: ${formatDuration(rangeSettings.startTime)} - ${formatDuration(rangeSettings.endTime)} (Repeat: ${rangeSettings.repeatCount})',
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                          ),
                        ),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(fontSize: 14, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Stack(
                children: [
                  if (rangeSettings.enabled)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: LinearProgressIndicator(
                        value: 1.0,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.withOpacity(0.2)),
                        minHeight: 6,
                      ),
                    ),
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: sliderValue,
                    onChanged: (value) {
                      seekAudio(Duration(seconds: value.toInt()));
                    },
                  ),
                  if (rangeSettings.enabled)
                    Positioned(
                      left: 16 + (MediaQuery.of(context).size.width - 32) * startPercent,
                      child: Container(
                        width: 2,
                        height: 20,
                        color: Colors.blue,
                      ),
                    ),
                  if (rangeSettings.enabled)
                    Positioned(
                      left: 16 + (MediaQuery.of(context).size.width - 32) * endPercent,
                      child: Container(
                        width: 2,
                        height: 20,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDuration(position)),
                    Text(formatDuration(duration)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.tune),
                label: Text(rangeSettings.enabled ? "Modify Range" : "Set Range"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: rangeSettings.enabled ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  showRangeSettingsDialog();
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.replay_10),
                    iconSize: 40,
                    onPressed: () {
                      seekAudio(Duration(seconds: position.inSeconds - 10));
                    },
                  ),
                  SizedBox(width: 20),
                  isLoading
                      ? CircularProgressIndicator()
                      : IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 60,
                    color: Colors.teal,
                    onPressed: playPauseAudio,
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.forward_10),
                    iconSize: 40,
                    onPressed: () {
                      seekAudio(Duration(seconds: position.inSeconds + 10));
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.stop),
                    label: Text("Stop"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: stopAudio,
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    icon: Icon(Icons.person),
                    label: Text("Change Reciter"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      ).then((_) {
                        loadAudio();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}