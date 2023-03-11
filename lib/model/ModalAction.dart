class ModalAction {
  final String name;
  final void Function() onPressed;

  ModalAction({
    required this.name,
    required this.onPressed,
  });
}