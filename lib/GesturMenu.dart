void toggleMenu1(
    bool isMenu1Selected, void Function(void Function()) setStateCallback) {
  setStateCallback(() {
    isMenu1Selected = !isMenu1Selected;
  });
}

void toggleMenu2(
    bool isMenu2Selected, void Function(void Function()) setStateCallback) {
  setStateCallback(() {
    isMenu2Selected = !isMenu2Selected;
  });
}
