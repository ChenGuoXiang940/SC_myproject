import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const TextStyle _boldTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextStyle _featureTextStyle = TextStyle(
    fontSize: 14,
  );

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text, style: _featureTextStyle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Center(child: Image.asset('assets/images/flutter_logo.png')),
          const SizedBox(height: 20),
          Text(localizations.appTitle, style: _boldTextStyle),
          const SizedBox(height: 20),
          Text(localizations.featuresTitle, style: _boldTextStyle),
          const SizedBox(height: 10),
          _buildFeatureItem(localizations.feature1),
          _buildFeatureItem(localizations.feature2),
          _buildFeatureItem(localizations.feature3),
          _buildFeatureItem(localizations.feature4),
          _buildFeatureItem(localizations.feature5),
          const SizedBox(height: 30),
          InkWell(
            onTap: () async {
              const url = 'https://github.com/ChenGuoXiang940/SC_myproject';
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri) && context.mounted) {
                debugPrint('URL can be launched');
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                debugPrint('Cannot launch URL');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.cannotOpenUrl)),
                );
              }
            },
            child: Text(
              localizations.githubRepository,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}