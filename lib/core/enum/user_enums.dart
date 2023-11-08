enum UserType {
  rider,
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

enum DeliveryState {
  searching,
  coming,
  picked,
  dropped;
  // factory DeliveryState.getValueFromString(String value) {
  //   for (DeliveryState element in DeliveryState.values) {
  //     if (element.name == value) {
  //       return element;
  //     }
  //   }
  //   return DeliveryState.searching;
  // }
}

extension EnumFromStringDeliveryState on DeliveryState {
  DeliveryState getValueFromString(String value) {
    for (DeliveryState element in DeliveryState.values) {
      if (element.name == value) {
        return element;
      }
    }
    return DeliveryState.searching;
  }
}
