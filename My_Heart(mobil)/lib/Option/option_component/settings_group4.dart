import 'package:my_heart/Option/option_component/settings_item.dart';
import 'package:my_heart/Option/option_component/settings_screen_utils.dart';
import 'package:flutter/material.dart';


class SettingsGroup extends StatelessWidget {
  final String? settingsGroupTitle;
  final TextStyle? settingsGroupTitleStyle;
  final List<SettingsItem> items;
  final EdgeInsets? margin;
  // Icons size
  final double? iconItemSize;

  SettingsGroup(
      {this.settingsGroupTitle,
        this.settingsGroupTitleStyle,
        required this.items,
        this.margin,
        this.iconItemSize = 25});

  @override
  Widget build(BuildContext context) {
    if (this.iconItemSize != null)
      SettingsScreenUtils.settingsGroupIconSize = iconItemSize;

    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The title
          (settingsGroupTitle != null)
              ? Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              settingsGroupTitle!,
              style: (settingsGroupTitleStyle == null)
                  ? TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                  : settingsGroupTitleStyle,
            ),
          )
              : Container(),
          // The SettingsGroup sections
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return items[index];
              },
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: ScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
