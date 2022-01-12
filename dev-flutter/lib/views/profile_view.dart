import '../providers/auth_provider.dart';
import '../widgets/settings_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          runSpacing: 4,
          children: [
            Card(
              elevation: 1,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                        authProvider.googleUser?.photoUrl ?? '',
                        scale: 2)),
                title: Text(
                    authProvider.googleUser?.displayName ?? 'Unknown user'),
                subtitle: Text(
                    authProvider.googleUser?.email ?? 'Email not provided'),
              ),
            ),
            const Divider(),
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
            const Divider(),
            SettingsListItem(
                title: 'Log out',
                onTap: () => authProvider.firebaseSignOut(),
                colorTheme: Theme.of(context).colorScheme.error,
                iconGraph: Icons.logout_outlined),
          ],
        ),
      ),
    );
  }
}
