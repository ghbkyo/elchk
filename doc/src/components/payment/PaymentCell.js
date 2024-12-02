import { postPayment } from "services/apiCore";

const PaymentCell = (cellData) => {
  let _data = { ...cellData };
  if (cellData.value === "Unpaid") {
    _data = { ..._data, valueZH: "待付款" };
  } else if (cellData.value === "Paid") {
    _data = { ..._data, valueZH: "已成功" };
  }

  const handleSubmit = () => {
    postPayment({
      amount: cellData?.data.totalAmount,
      ar_Id: cellData?.data.paymentId,
      centerId: cellData?.data.centerId,
      redirect_url: "localhost",
    });
  };

  return (
    <>
      <span className="pe-2">{_data.valueZH}</span>
      {cellData.data.showOnlinePaymentButton &&
      cellData.data.paymentStatus === "Unpaid" ? (
        <span>
          <button
            type="button"
            onClick={(e) => handleSubmit()}
            className="btn-payment-1"
          >
            付款
          </button>
        </span>
      ) : (
        <></>
      )}

      {/* {cellData.data.paymentStatus === "Unpaid" ? (
        <button onClick={handleClickPay}>付款</button>
      ) : (
        <></>
      )} */}
      {/* <PaymentModal
        paymentId={cellData?.data.paymentId}
        programPrice={cellData?.data.totalAmount}
        paymentStatusProp="default"
        showSuccessEnrollModalProp={true}
        // paymentStatusProp={paymentState?.paymentStatus}
        // showSuccessEnrollModalProp={paymentState.show}
      ></PaymentModal> */}
    </>
  );
};

export default PaymentCell;
