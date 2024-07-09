import 'package:bechan/services/filetransfer_service.dart';
import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/custom_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:url_launcher/url_launcher.dart';

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
    await picksinglefile();
    dynamic res = await FiletransferService().importFile(file!);
    print('PATH ===> ${res.path}');
    if (res != null && res.status == 'ok') {
      setState(() {
        pathFromServer = res.path;
      });
    }
  }

  void onSubmit () async {
    dynamic res = await FiletransferService().submit({'filepath' : pathFromServer});
    String message = '';
    if (res != null)
    {
      message = res.message;
      setState(() {
        if (res.status == 'ok') {
          file = null;
          isFileOK = true;
        }
        else {
          errorRes = res.error;
          isFileOK = false;
        }
        ScaffoldMessenger.of(context).showSnackBar(getSnackBar(message,55,60,isFileOK));
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
          file = null;
          isFileOK = true;
        }
        else {
          isFileOK = false;
        }
        ScaffoldMessenger.of(context).showSnackBar(getSnackBar(message,55,60,isFileOK));
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
                                dynamic res = await TransactionService().getTemplate(context);
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
                                : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(file!.name),
                                          Text(size!),
                                          // Text('Extension -  ${file!.extension}')
                                        ],
                                      ),
                                    IconButton(
                                      onPressed: (){setState(() {
                                        file = null;
                                        isFileOK = true;
                                      });},
                                      icon: const Icon(Icons.cancel)
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 150,
                            child: 
                            file == null 
                            ? OutlinedButton(
                              onPressed: () async {onChooseFile();},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Choose file'),
                                  SizedBox(width: 12,),
                                  FaIcon(FontAwesomeIcons.fileImport, size: 15,),
                                ],
                              ),
                            )
                            : isFileOK 
                            ? OutlinedButton(
                              onPressed: () {onSubmit();},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Submit'),
                                ],
                              ),
                            )
                            : OutlinedButton(
                              onPressed: () {onConfirm();},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Confirm'),
                                ],
                              ),
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