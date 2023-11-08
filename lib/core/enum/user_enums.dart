enum UserType {
  driver,
  customer,
  admin,
  none;
}

extension TypeFromString on UserType {
  UserType getValueFromString(String value) {
    for (UserType element in UserType.values) {
      if (element.name == value) {
        return element;
      }
    }
    return UserType.none;
  }
}

enum OrderState {
  none,
  searching,
  found,
  coming,
  picked,
  dropped;
}

extension EnumFromStringDeliveryState on OrderState {
  OrderState getValueFromString(String value) {
    for (OrderState element in OrderState.values) {
      if (element.name == value) {
        return element;
      }
    }
    return OrderState.searching;
  }
}
