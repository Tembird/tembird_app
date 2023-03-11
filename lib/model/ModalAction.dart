class ModalAction {
  final String name;
  final void Function() onPressed;
  final bool isNegative;

  ModalAction({
    required this.name,
    required this.onPressed,
    required this.isNegative,
  });
}