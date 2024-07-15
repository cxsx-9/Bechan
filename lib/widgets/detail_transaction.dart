import 'package:bechan/models/tag_model.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/custom_chip.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;
import 'package:intl/intl.dart';

class DetailTransaction extends StatelessWidget {
  final dynamic transaction;
  const DetailTransaction({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    List<Tag> tags = transaction.tags;
    List<int> selectedTags = [];
    if (tags != []) {
      for (var tag in tags) {
        selectedTags.add(tag.tagId);
      }
    }
    return SizedBox(
      width: 360,
      height: 415,
      child: Container(
        decoration: cardDecoration(context),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  transaction.fav == 0
                  ? Icon(
                    Icons.circle_rounded,
                    size: 15,
                    color: transaction.categorieType != 'income' ? const Color.fromRGBO(229, 101, 144, 1) : const Color.fromRGBO(0, 189, 174, 1),
                  )
                  : Icon(
                    Icons.favorite,
                    size: 15,
                    color: transaction.categorieType != 'income' ? const Color.fromRGBO(229, 101, 144, 1) : const Color.fromRGBO(0, 189, 174, 1),
                  ),
                  const SizedBox(width: 10,),
                  Text(
                    toBeginningOfSentenceCase(transaction.categorieType),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: transaction.categorieType != 'income' ? const Color.fromRGBO(229, 101, 144, 1) : const Color.fromRGBO(0, 189, 174, 1)
                    ),
                  ),
                ],
              ),
              Text(
                transaction.categorieName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30,),
              Text(
                transaction.note,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                config.NUM_FORMAT.format(transaction.amount),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 60,
                width: 270,
                child: transaction.detail != '' ? Center(
                  child: Text(
                    'note :  ${transaction.detail}',
                    textAlign: TextAlign.center,
                  )
                ) : const SizedBox(),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    children: config.TAG.tags.map((Tag tag) {
                      return selectedTags.contains(tag.tagId) ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: CustomChip(
                          text: tag.name,
                          selected: false,
                          backgroundColor: const Color.fromARGB(255, 227, 227, 227),
                          selectedColor: Colors.grey.shade600,
                        ),
                      ) : const SizedBox();
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Text(DateFormat('EEE, dd MMMM yyyy  HH:mm').format(transaction.transactionDatetime!)),
            ],
          ),
        ),
      ),
    );
  }
}