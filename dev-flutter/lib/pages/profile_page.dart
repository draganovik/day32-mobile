import 'package:day32/providers/app_settings_provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/settings_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          runSpacing: 4,
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withAlpha(40),
                      width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      authProvider.googleUser?.photoUrl ?? '',
                      scale: 2)),
              title:
                  Text(authProvider.googleUser?.displayName ?? 'Unknown user'),
              subtitle:
                  Text(authProvider.googleUser?.email ?? 'Email not provided'),
            ),
            SettingsListItem(
                title: 'My public events',
                onTap: () {},
                iconGraph: Icons.person_add_alt),
            SettingsListItem(
                title: 'Calendar settings',
                onTap: () {},
                iconGraph: Icons.event_note_outlined),
            SettingsListItem(
                title: 'Import events (.ical)',
                onTap: () {},
                iconGraph: Icons.merge_type_rounded),
            SettingsListItem(
                title: 'Log out',
                onTap: () {
                  settingsProvider
                      .clearCache()
                      .then((_) => authProvider.firebaseSignOut());
                },
                colorTheme: Theme.of(context).colorScheme.error,
                iconGraph: Icons.logout_outlined),
          ],
        ),
      ),
    );
  }
}
