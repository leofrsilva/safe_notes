import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';

import 'register_key_controller.dart';

class RegisterKeyPage extends StatefulWidget {
  const RegisterKeyPage({Key? key}) : super(key: key);

  @override
  State<RegisterKeyPage> createState() => _RegisterKeyPageState();
}

class _RegisterKeyPageState extends State<RegisterKeyPage> {
  late RegisterKeyController controller;

  late TextEditingController _textEditingKey;
  late FocusNode _focusNode;
  bool canSend = false;

  @override
  void initState() {
    super.initState();
    controller = Modular.get<RegisterKeyController>();
    _textEditingKey = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance?.addPostFrameCallback((timings) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textEditingKey.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        backgroundColor: ColorPalettes.black54,
        body: SizedBox(
          height: Sizes.height(context),
          child: Stack(
            children: [
              SizedBox(
                width: Sizes.width(context),
                height: Sizes.height(context) * 0.925,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 330.0,
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        right: 20.0,
                        bottom: 8.0,
                      ),
                      margin: const EdgeInsets.only(bottom: 12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextFieldWithHint(
                            controller: _textEditingKey,
                            title: 'Chave de acesso as Notas',
                            hint: '###########',
                            focusNode: _focusNode,
                            onChanged: (String key) {
                              if (key.isEmpty) {
                                setState(() => canSend = false);
                              } else {
                                if (canSend != true) {
                                  setState(() => canSend = true);
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 15.0),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 5.0,
                                    ),
                                    child: Text(
                                      'Enviar',
                                      style: TextStyles.textButton(context)
                                          .copyWith(
                                        color: canSend
                                            ? Theme.of(context).primaryColor
                                            : ColorPalettes.grey,
                                      ),
                                    ),
                                  ),
                                  onPressed: canSend
                                      ? () {
                                          FocusScope.of(context).unfocus();
                                          controller.sendKey(
                                            context,
                                            _textEditingKey.text,
                                          );
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
