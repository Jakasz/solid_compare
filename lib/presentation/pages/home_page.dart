import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:solid_compare_img/data/repositories/image_fetch.dart';
import 'package:solid_compare_img/domain/usecases/get_image_usecase.dart';
import 'package:solid_compare_img/presentation/providers/comparison_provider.dart';
import 'package:validator_regex/validator_regex.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final readProvider = context.read<ComparisonProvider>();
    final textInputController1 = TextEditingController();
    final textInputController2 = TextEditingController();
    final fetchImageUseCase = GetImageUseCase(imageRepository: ImageFetch());
    final imgHeight = MediaQuery.sizeOf(context).height / 3.5;
    final imgWidth = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.5,
                    child: TextField(
                      decoration: const InputDecoration(hintText: "Enter link"),
                      controller: textInputController1,
                      onChanged: (value) {
                        textInputController1.text = value;
                      },
                    ),
                  ),
                  const Gap(10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        try {
                          if (Validator.url(textInputController1.text)) {
                            final image_1 = await fetchImageUseCase
                                .fetch(textInputController1.text);

                            readProvider.setFristImg(image_1);
                          }
                        } on Exception catch (e) {
                          print(e.toString());
                        }
                      },
                      child: const Text("Load 1")),
                ],
              ),
              const Gap(10),
              Selector<ComparisonProvider, Uint8List?>(
                  selector: (contex, imageProvider) => imageProvider.imageData1,
                  builder: (context, value, child) {
                    if (value != null) {
                      return SizedBox(
                          height: imgHeight,
                          width: imgWidth,
                          child: Image.memory(value));
                    } else {
                      return const Text("Select image");
                    }
                  }),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.5,
                    child: TextField(
                      decoration: const InputDecoration(hintText: "Enter link"),
                      controller: textInputController2,
                      onChanged: (value) {
                        textInputController2.text = value;
                      },
                    ),
                  ),
                  const Gap(10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        try {
                          if (Validator.url(textInputController2.text)) {
                            final image_2 = await fetchImageUseCase
                                .fetch(textInputController2.text);

                            readProvider.setSecondImg(image_2);
                          }
                        } on Exception catch (e) {
                          print(e.toString());
                        }
                      },
                      child: const Text("Load 2")),
                ],
              ),
              const Gap(10),
              Selector<ComparisonProvider, Uint8List?>(
                  selector: (contex, imageProvider) => imageProvider.imageData2,
                  builder: (context, value, child) {
                    if (value != null) {
                      return SizedBox(
                          height: imgHeight,
                          width: imgWidth,
                          child: Image.memory(value));
                    } else {
                      return const Text("Select image");
                    }
                  }),
              const Gap(10),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      readProvider.compareObjects();
                    },
                    child: const Text("Compare")),
              ),
              const Gap(10),
              Consumer<ComparisonProvider>(
                  builder: (context, imageProvider, child) {
                return Center(
                    child: Text(
                  "<${imageProvider.comparisonResult}>",
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                ));
              })
            ],
          ),
        ),
      )),
    );
  }
}
