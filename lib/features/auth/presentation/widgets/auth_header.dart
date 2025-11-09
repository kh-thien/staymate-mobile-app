import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/logo_app.dart';

class AuthHeader extends StatelessWidget {
  final bool isDark;

  const AuthHeader({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
      child: Column(
        children: [
          // Logo
          Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset(
              LogoApp.logo,
              fit: BoxFit.contain,
             
            ),
          ),
       
          
          // Logo Text - Tăng size lên
          SizedBox(
            height: 56,
            child: SvgPicture.asset(
              LogoApp.logoText,
              fit: BoxFit.contain,
              colorFilter: isDark
                  ? const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    )
                  : null,
              placeholderBuilder: (context) => const Text(
                'StayMate',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
               
          // Description text
          Text(
            'Ứng dụng theo dõi phòng trọ tiện lợi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : Colors.grey[600],
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
              height: 1.4,
            ),
          ),
           Text(
            'dành riêng cho người thuê',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : Colors.grey[600],
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

