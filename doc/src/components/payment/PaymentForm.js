import { useState, createRef, useEffect, useRef } from "react";
import { Player } from "@lottiefiles/react-lottie-player";
import { Badge, Row, Col } from "react-bootstrap";
import { getProgramEnrollment } from "../../services/apiCore";
import moment from "moment";
import LottiePaymentInProgress from "assets/json/LottiePaymentInProgress.json"

const PaymentForm = ({
  paymentId,
  programPrice,
  paymentStatusProp,
  ...rest
}) => {
  const [payment, setPayment] = useState({ status: paymentStatusProp });
  let { paymentGatewayURL } = rest;
  const formRef = createRef();
  const submitButtonRef = useRef();

  if (!paymentGatewayURL) {
    paymentGatewayURL = `${process.env.REACT_APP_PAYMENT_GATEWAY}`;
  }

  useEffect(() => {
    payment.status === "default" &&
      setTimeout(() => {
        submitButtonRef.current.click();
      }, 2500);
  }, []);

  const handleSubmitPaymentRequest = () => {
    try {
      setPayment({ ...payment, status: "paymentInProgress" });
      formRef.current.target = "_blank";

      let cnt = 0;
      var intervalTimer = window.setInterval(() => {
        cnt++;
        if (cnt > 60 && payment.status === "paymentInProgress") {
          setPayment({ ...payment, status: "fail" });
          window.clearInterval(intervalTimer);
        } else if (checkPaymentStatus()) {
          window.clearInterval(intervalTimer);
        }
      }, 5000);
    } catch (error) {
      console.error(error);
      setPayment({ ...payment, status: "fail" });
    }
  };

  const checkPaymentStatus = () => {
    const fetchData = async () => {
      const _result = await getProgramEnrollment({
        PageNumber: 1,
        PageSize: 10,
        OrderBy: "id",
        IsOrderByAsc: false,
      });

      const _filtered_result = _result?.data?.items.find((item) => {
        return String(item.accountReceivable.id) === String(paymentId);
      });
      if (_filtered_result?.paymentStatus === "Paid") {
        // assume the latest payment is at the end of the array
        const accountReceivablePaymentsSize =
          _filtered_result.accountReceivable?.accountReceivablePayments.length -
          1;
        setPayment({
          ...payment,
          status: "success",
          paymentMethod:
            _filtered_result.accountReceivable.accountReceivablePayments[
              accountReceivablePaymentsSize
            ].paymentMethod.nameZN,
          paymentDate: moment(
            _filtered_result.accountReceivable.accountReceivablePayments[
              accountReceivablePaymentsSize
            ].paymentDate
          ).format(process.env.REACT_APP_DATETIME_FORMAT),
          receiptSerialNumber:
            _filtered_result.accountReceivable.accountReceivablePayments[
              accountReceivablePaymentsSize
            ].receiptSerialNumber,
        });
        return true;
      }
    };
    fetchData();
    return false;
  };

  return (
    <>
      {payment.status === "default" && <h5>請稍等，我們會自動轉到付款網頁</h5>}
      {payment.status === "paymentInProgress" && (
        <>
          <Player
            autoplay
            loop
            // src="https://assets3.lottiefiles.com/packages/lf20_bogmlqx0.json"
            src={LottiePaymentInProgress}
            style={{ height: "80px", width: "80px" }}
          ></Player>
          付款中
        </>
      )}
      {payment.status === "success" && (
        <>
          <h4>
            <Badge bg="success">付款成功</Badge>
          </h4>
          <Row className="pt-3">
            <Col xs={12}>
              <h6>付款方式: {payment.paymentMethod}</h6>
            </Col>
          </Row>
          <Row>
            <Col xs={12}>
              <h6>付款日期: {payment.paymentDate}</h6>
            </Col>
          </Row>
          <Row>
            <Col xs={12}>
              <h6>收據編號: {payment.receiptSerialNumber}</h6>
            </Col>
          </Row>
        </>
      )}
      {payment.status === "fail" && (
        <h4>
          <Badge bg="warning" text="danger">
            付款未完成
          </Badge>
        </h4>
      )}

      <form
        className="pt-2"
        ref={formRef}
        action={paymentGatewayURL}
        method="post"
        onSubmit={handleSubmitPaymentRequest}
      >
        <input type="hidden" name="arReference" value={paymentId} />
        <input type="hidden" name="amount" value={programPrice * 100} />
        <button
          type="submit"
          ref={submitButtonRef}
          className={`btn btn-primary ${
            (payment.status !== "fail" && payment.status !== "paymentInProgress") && "visibility-hidden"
          }`}
        >
          如未能成功付款 請按此
        </button>
      </form>
    </>
  );
};

export default PaymentForm;
