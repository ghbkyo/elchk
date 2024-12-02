import React, { useEffect, useState, useContext } from "react";
import { Col, Row, Button, Container } from "react-bootstrap";
import moment from "moment";
import {
  getProgramEnrollment,
  getPaymentMethod,
} from "../../../../services/apiCore";
import EnrollmentRecordTable from "../../../../components/tables/EnrollmentRecordTable";
import { Player } from "@lottiefiles/react-lottie-player";
import LottieLoadingFile from "assets/json/LottieLoadingFile.json";
import CenterContext from "utils/CenterContext";
import { isCenterContainOnlinePayment } from "./../../../../utils/utils";
import Navbar4 from "components/navbars/Navbar4";
import Footer from "../../../../components/footer/Footer";
import PageHeading from "components/PageHeading";

const ProgramEnrollment = () => {
  const { center } = useContext(CenterContext);
  const [enrollments, setEnrollments] = useState();
  const [tableData, setTableData] = useState();
  const [pageSize, setpageSize] = useState(21);
  const [showLoading, setShowLoading] = useState(false);
  const [centerPaymentMethod, setCenterPaymentMethod] = useState([]);

  useEffect(() => {
    function adjustFontSize() {
      const textNodes = getTextNodes(document.body);
      document.body.style.setProperty("--size", localStorage.size);
      textNodes.forEach(node => {
        const orignFontSize = parseInt(window.getComputedStyle(node.parentNode).fontSize);
      if (node.parentNode.style.getPropertyValue("--sorignFontSize") == '') {
        node.parentNode.style.setProperty("--sorignFontSize", orignFontSize + "px");
        node.parentNode.style.fontSize = `calc(var(--sorignFontSize) * var(--size))`;
      }
    });
  }
  /* getnodes */
  function getTextNodes(node) {
    let textNodes = [];
    if (node.nodeType === Node.TEXT_NODE) {
      textNodes.push(node);
    } else {
      const children = node.childNodes;
      if (children) {
        for (let i = 0; i < children.length; i++) {
          textNodes = textNodes.concat(getTextNodes(children[i]));
        }
      }
    }
    return textNodes;
  }
  async function fetchDataAndAdjust() {
    await fetchData();
    setTimeout(function () {
      adjustFontSize();
    }, 1000); //await
  }
  fetchDataAndAdjust();
  }, [center]);

  useEffect(() => {
    // const showOnlinePaymentButton = isCenterContainOnlinePayment(centerPaymentMethod);
    const showOnlinePaymentButton = true;

    let data = [];
    (enrollments || []).map((item, index) => {
      data.push({
        id: item?.id,
        paymentId: item?.accountReceivable?.id + 'A' + item?.accountReceivable?.externalId,
        paymentStatus: item?.accountReceivable?.status,
        program: {
          name: item?.programInfo?.name,
          id: item?.programInfo?.id,
          center: item?.comCenter,
          venue: item?.programEnrollmentSessions[0].programSession.venue,
          startDate: item?.programEnrollmentSessions[0].programSession.startDate,
          endDate: item?.programEnrollmentSessions[0].programSession.endDate,
          programOnlineEnrollmentSetting: {
            enrollmentQuota: 0,
          }
        },
        name: item?.programInfo.name,
        programNo: item?.programInfo.programNo,
        enrollmentDate: moment(item?.enrollmentDate).format(
          process.env.REACT_APP_DATE_FORMAT
        ),
        totalAmount: item?.accountReceivable?.totalAmount,
        receivedAmount: item?.accountReceivable?.receivedAmount,
        centerId: item?.comCenter?.id,
        item: item,
        showOnlinePaymentButton: showOnlinePaymentButton,
      });
      // (item?.programEnrollmentSessions || []).map((session, sessionIndex) => {
      //   data.push({
      //     id: item?.id,
      //     paymentId: item?.accountReceivable?.id,
      //     paymentStatus: item?.paymentStatus,
      //     name: item?.programInfo.name,
      //     programNo: item?.programInfo.programNo,
      //     startDate: moment(session?.programSession?.startDate).format(
      //       process.env.REACT_APP_DATE_FORMAT
      //     ),
      //     endDate: moment(session?.programSession?.endDate).format(
      //       process.env.REACT_APP_DATE_FORMAT
      //     ),
      //     programWorkflowStatus: item?.programInfo.programWorkflowStatus,
      //     //  item?.programInfo.programWorkflowStatus == "Approved"
      //     //  ? "已完成"
      //     //   : item?.programInfo.programWorkflowStatus == "Canceled"
      //     // ? "已取消"
      //     // : "未完成",

      //     enrollmentPaymentStatus:
      //       item?.programEnrollmentWorkflowStatus +
      //       "(" +
      //       item?.paymentStatus +
      //       ")",
      //   });
      // });
    });
    console.log("data", data);
    // console.log("data?.splice(0, pageSize)", data?.splice(0, 10));
    setTableData(data);

  }, [enrollments]);

  const fetchData = async () => {
    setShowLoading(true);
    // get payment method of the center
    const _param = {
      ComCenterId: center?.id,
      BoundType: "InBound",
      IsEnabled: true,
    };
    const paymentMethodResult = await getPaymentMethod(_param);
    setCenterPaymentMethod(paymentMethodResult.data);
    // console.log("paymentMethodResult", paymentMethodResult);

    const _params = {
      PageNumber: 1,
      PageSize: pageSize,
      OrderBy: "id",
      IsOrderByAsc: false,
    };
    const _result = await getProgramEnrollment(_params);
    setEnrollments(
      _result?.data?.items
      // _result?.data?.items.filter(
      //   (item) => String(item.comCenter.id) === String(center.id)
      // )
    );
    setShowLoading(false);
  };

  const handleRefresh = () => {
    fetchData();
  };

  return (
    <>
      <Navbar4 fixedWidth />
      <div id="main">
        <PageHeading title="我的活動" icon="calendar" />

        <Container>
          {/* <div className="py-2">
            <button onClick={handleRefresh} className="btn-refresh-1">
              更新
            </button>
          </div> */}

          {!showLoading && (
            <EnrollmentRecordTable tableData={tableData}></EnrollmentRecordTable>
          )}
          {!!showLoading && (
            <Player
              autoplay
              loop
              // src="https://assets8.lottiefiles.com/private_files/lf30_fup2uejx.json"
              src={LottieLoadingFile}
              style={{ height: "280px", width: "280px" }}
              className=""
            ></Player>
          )}
        </Container>
      </div>

      <Footer aosSetting="disable" />

    </>
  );
};

export default ProgramEnrollment;
