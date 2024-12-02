export const isCenterContainOnlinePayment = (centerPaymentMethod) => {
  let showOnlinePaymentButton = false;
  const onlineMethod = centerPaymentMethod.filter(
    (item) =>
      item.paymentMethodType === "FPS" ||
      item.paymentMethodType === "CreditCard"
  );
  if (onlineMethod.length > 0) {
    showOnlinePaymentButton = true;
  }
  return showOnlinePaymentButton;
};
