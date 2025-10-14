import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/utils/enums/floating_animation_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingCompareButton extends StatefulWidget {
  const FloatingCompareButton({
    super.key,
    required this.onTap,
    this.size = 60.0,
    this.iconSize = 28.0,
    this.animationType = FloatingAnimationType.float,
  });

  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final FloatingAnimationType animationType;

  @override
  State<FloatingCompareButton> createState() => _FloatingCompareButtonState();
}

class _FloatingCompareButtonState extends State<FloatingCompareButton>
    with TickerProviderStateMixin {

  late AnimationController _primaryController;
  late AnimationController _pulseController;
  late Animation<double> _primaryAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override void initState() {
    // TODO: implement initState
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    //Primary animation controller
    _primaryController = AnimationController(
        duration: _getAnimationDuration(),
        vsync: this,
    );

    //Pulse animation controller
    _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
    );

    switch (widget.animationType) {
      case FloatingAnimationType.float:
        _primaryAnimation = Tween<double>(
          begin: 0.0,
          end: 8.0,
        ).animate(CurvedAnimation(
            parent: _primaryController,
            curve: Curves.easeInOut,)
        );
        break;
      case FloatingAnimationType.bounce:
        _primaryAnimation = Tween<double>(
          begin: 0.0,
          end: 12.0,
        ).animate(CurvedAnimation(
            parent: _primaryController, curve: Curves.bounceInOut,)
        );
        break;
      case FloatingAnimationType.scale:
        _scaleAnimation = Tween<double>(
          begin: 1.0,
          end: 1.1,
        ).animate(CurvedAnimation(parent: _primaryController, curve: Curves.easeInOut,)
        );
        break;
      case FloatingAnimationType.pulse:
        _pulseAnimation = Tween<double>(
          begin: 1.0,
          end: 1.2,
        ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut,)
        );
        break;
    }
  }

  Duration _getAnimationDuration() {
    switch (widget.animationType) {
      case FloatingAnimationType.float:
        return const Duration(seconds: 2);
      case FloatingAnimationType.bounce:
        return const Duration(milliseconds: 1200);
      case FloatingAnimationType.scale:
        return const Duration(milliseconds: 1500);
      case FloatingAnimationType.pulse:
        return const Duration(milliseconds: 1000);
    }
  }

  void _startAnimations() {
    switch (widget.animationType) {
      case FloatingAnimationType.float:
      case FloatingAnimationType.bounce:
      case FloatingAnimationType.scale:
        _primaryController.repeat(reverse: true);
        break;
      case FloatingAnimationType.pulse:
        _pulseController.repeat(reverse: true);
        break;
    }
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animationType == FloatingAnimationType.pulse
        ? _pulseController
        : _primaryController,
        builder: (context, child) {
          Widget button = GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colours.lightThemePrimaryColour,
                    Colours.darkThemeDarkNavBarColour,
                  ],
                ),
                borderRadius: BorderRadius.circular(widget.size / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colours.lightThemePrimaryColour.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.size / 2),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      //Company Logo goes here
                      Icon(
                        Icons.business_center,
                        color: Colors.white,
                        size: widget.iconSize,
                      ),
                      //Compare indicator
                      Positioned(
                        bottom: 2,
                          right: 2,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.compare_arrows_outlined,
                              color: Colours.lightThemePrimaryColour,
                              size: 8,
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          //Applying transformation type
          switch(widget.animationType) {
            case FloatingAnimationType.float:
            case FloatingAnimationType.bounce:
              return Transform.translate(offset: Offset(0, -_primaryAnimation.value),
                child: button,
              );
            case FloatingAnimationType.scale:
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: button,
              );
            case FloatingAnimationType.pulse:
              return Stack(
                alignment: Alignment.center,
                children: [
                  //Pulse ring effect
                  Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: widget.size + 20,
                        height: widget.size + 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular((widget.size + 20) / 2),
                        border: Border.all(
                          color: Colours.lightThemePrimaryColour.withOpacity(
                              1.0 - (_pulseAnimation.value - 1.0) / 0.2,
                          ),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  button,
                ],
              );
          }
        },
    );
  }
}


// // Alternative version with image support for company logo
// class FloatingCompareButtonWithLogo extends StatefulWidget {
//   const FloatingCompareButtonWithLogo({
//     super.key,
//     required this.onTap,
//     this.logoAssetPath,
//     this.logoWidget,
//     this.size = 60.0,
//     this.animationType = FloatingAnimationType.float,
//   });
//
//   final VoidCallback onTap;
//   final String? logoAssetPath;
//   final Widget? logoWidget;
//   final double size;
//   final FloatingAnimationType animationType;
//
//   @override
//   State<FloatingCompareButtonWithLogo> createState() => _FloatingCompareButtonWithLogoState();
// }
//
// class _FloatingCompareButtonWithLogoState extends State<FloatingCompareButtonWithLogo>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//
//     _animation = Tween<double>(
//       begin: 0.0,
//       end: 8.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _animationController.repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, -_animation.value),
//           child: GestureDetector(
//             onTap: widget.onTap,
//             child: Container(
//               width: widget.size,
//               height: widget.size,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Colours.lightThemePrimaryColour,
//                     Color(0xFF1565C0),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(widget.size / 2),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colours.lightThemePrimaryColour.withOpacity(0.4),
//                     blurRadius: 15,
//                     offset: const Offset(0, 8),
//                     spreadRadius: 2,
//                   ),
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(widget.size / 2),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.3),
//                     width: 1.5,
//                   ),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(widget.size / 2 - 1.5),
//                   child: Center(
//                     child: widget.logoWidget ??
//                         (widget.logoAssetPath != null
//                             ? Image.asset(
//                           widget.logoAssetPath!,
//                           width: widget.size * 0.6,
//                           height: widget.size * 0.6,
//                           fit: BoxFit.contain,
//                         )
//                             : const Icon(
//                           Icons.business,
//                           color: Colors.white,
//                           size: 28,
//                         )),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }