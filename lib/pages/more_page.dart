import 'dart:async';
import 'dart:convert';

import 'package:bechan/services/filetransfer_service.dart';
import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/custom_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bechan/config.dart' as config;
import 'package:flutter_client_sse/flutter_client_sse.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  PlatformFile? file;
  String? size;
  String? pathFromServer;
  bool isFileOK = true;
  bool uploadSuccess = false;
  bool connecting = false;
  dynamic errorRes;

  Future<void> picksinglefile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result != null) {
      file = result.files.first;
      file == null ? false : OpenAppFile.open(file!.path.toString());
      final kb = file!.size / 1024;
      final mb = kb / 1024;
      final size = (mb >= 1)
          ? '${mb.toStringAsFixed(2)} MB'
          : '${kb.toStringAsFixed(2)} KB';
      this.size = size;
      setState(() {});
    }
  }

  void onChooseFile () async {
    setState(() {
      file = null;
      progress = 0;
    });
    await picksinglefile();
    if (file != null){
      dynamic res = await FiletransferService().importFile(file!);
      print(res);
      print('PATH ===> ${res.path}');
      if (res != null && res.path != null && res.status == 'ok') {
        setState(() {
          uploadSuccess = false;
          pathFromServer = res.path;
        });
      }
    }
  }

  late StreamSubscription<SSEModel> _sseSubscription;
  String statusMessage = '';
  int progress = 0;

  void connectToServer() {
    setState(() {
      connecting = true;
    });
    String url = '${config.BASE_URL}/status';
    Map<String, String> headers = {};

    _sseSubscription = SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: url,
      header: headers,
      ).listen((SSEModel event) {
        var data = event.data;
        if (data != null) {
          var json = jsonDecode(data);
          if (mounted) {
            setState(() {
              if (json['status'] == 'start') {
                progress = 0;
              } else if (json['status'] == 'processing') {
                progress = json['progress'] ?? 100;
              } else if (json['status'] == 'error' || json['status'] == 'completed') {
                connecting = false;
                _sseSubscription.cancel();
              }
            });
          }
        }
      }, onError: (error) {
        print('Error connecting to SSE: $error');
        _sseSubscription.cancel();
        setState(() {
          connecting = false;
        });
      }
    );
  }

  @override
  void dispose() {
    if (connecting) {
      _sseSubscription.cancel();
    }
    super.dispose();
  }

  void onSubmit () async {
    connectToServer();
    dynamic res = await FiletransferService().submit({'filepath' : pathFromServer});
    String message = '';
    if (res != null)
    {
      message = res.message;
      setState(() {
        if (res.status == 'ok') {
          isFileOK = true;
          uploadSuccess = true;
        }
        else {
          errorRes = res.error;
          isFileOK = false;
        }
        ScaffoldMessenger.of(context).showSnackBar(getSnackBar(message,55,100,isFileOK));
      });
    }
  }

  void onConfirm () async {
    dynamic res = await FiletransferService().confirm({'filepath' : pathFromServer});
    String message = '';
    if (res != null)
    {
      message = res.message;
      setState(() {
        if (res.status == 'ok') {
          isFileOK = true;
          uploadSuccess = true;
        }
        else {
          isFileOK = false;
        }
        ScaffoldMessenger.of(context).showSnackBar(getSnackBar(message,55,100,isFileOK));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: () =>  {Navigator.pop(context, false)}, icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    Text(
                      'Import Transaction',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ),
                  ],
                ),
                Container(
                  decoration: cardDecoration(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                SizedBox(width: 40, child: Center(child: FaIcon(FontAwesomeIcons.fileArrowDown, size: 20, color: Colors.deepPurple,))),
                                Text('Download template file',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
                              ]
                            ),
                            IconButton(
                              onPressed: () async {
                                dynamic res = await TransactionService().getTemplate();
                                print(res.url);
                                final Uri url = Uri.parse(res.url);
                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              icon: const FaIcon(FontAwesomeIcons.arrowDown, size: 15,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),

                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: cardDecoration(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Import Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),),
                              Text('Import Your Transactions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.secondary),),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                file == null
                                ? const Text('No File found yet')
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(file!.name),
                                            const SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: (){setState(() {file = null;isFileOK = true;progress = 0;});},
                                              child: const Icon(Icons.cancel, size: 18)
                                            )
                                          ],
                                        ),
                                        Text(
                                          uploadSuccess ? 'Upload success!' : '',
                                          style: const TextStyle(fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                    Text(size!, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary),),
                                  ],
                                ),
                                progress != 0
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    LinearProgressIndicator(
                                      value : progress.toDouble(),
                                      color: uploadSuccess
                                      ? Colors.green
                                      : Colors.black,
                                    ),
                                    Text('$progress%')
                                  ],
                                )
                                : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: file == null || uploadSuccess ? [
                                OutlinedButton(
                                  onPressed: () async {onChooseFile();},
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Choose file'),
                                      SizedBox(width: 12,),
                                      FaIcon(FontAwesomeIcons.fileImport, size: 15,),
                                    ],
                                  ),
                                ),
                                uploadSuccess ? Row(
                                  children: [
                                    const SizedBox(width: 90,),
                                    FilledButton(
                                      onPressed: () => {Navigator.pop(context, false)},
                                      child: const Text('Done'),
                                    ),
                                  ],
                                ) : const SizedBox(),
                              ]
                              : isFileOK
                              ? [
                                OutlinedButton(
                                  onPressed: () {onSubmit();},
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Submit'),
                                    ],
                                  ),
                                )
                              ] 
                              : [
                                OutlinedButton(
                                  onPressed: () {onConfirm();},
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Confirm'),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                !isFileOK && file != null && errorRes != null
                ? Column(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: cardDecoration(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('error', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),),
                            Text('Some data might be invalid. \nConfirm adding valid parts?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.secondary),),
                            // Text('Confirm adding valid parts?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.secondary),),
                            Expanded(
                              child: ListView.separated(
                                  itemCount: errorRes.length,
                                  itemBuilder: (context, index) {
                                    final item = errorRes[index];
                                    return Center(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ListTile(
                                          visualDensity: const VisualDensity(vertical: -3),
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width:280, child: Text(item.message, style: const TextStyle(fontSize: 15,),)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Divider(
                                        color: Theme.of(context).colorScheme.shadow,
                                        height: 0,
                                      ),
                                    );
                                  }
                                ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40,)
                  ],
                )
                : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}