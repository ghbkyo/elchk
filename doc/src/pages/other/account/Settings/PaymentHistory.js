import React, { useEffect, useState, useContext } from "react";
import { Col, Row, Button } from "react-bootstrap";
import { useNavigate } from "react-router-dom";
import { Player } from "@lottiefiles/react-lottie-player";
import moment from "moment";
import LottieLoadingFile from "assets/json/LottieLoadingFile.json";
import { getPaymentRecord } from "../../../../services/apiCore";
import PaymentHistoryTable from "../../../../components/tables/PaymentHistoryTable";
import CenterContext from "utils/CenterContext";
import FeatherIcon from "feather-icons-react";
import MemberContext from "utils/MemberContext";

const PaymentHistory = () => {
  const navigate = useNavigate();
  const { center } = useContext(CenterContext);
  const { member } = useContext(MemberContext);
  const [enrollments, setEnrollments] = useState([]);
  const [showLoading, setShowLoading] = useState(false);
  const [type, setType] = useState(0)
  const pageSize = 99;

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
    setTimeout(function () {
      adjustFontSize();
    }, 1000); //await
  }
  fetchDataAndAdjust();
  fetchData();
  }, [center]);

  const fetchData = async () => {
    setShowLoading(true);
    const _params = {
      CenterId: center.id,
      MemberInfoId: member.id,
      PageNumber: 1,
      PageSize: pageSize,
      OrderBy: "id",
      IsOrderByAsc: false,
      PaymentType: type == 0 ? 'Point' : 'Cash'
    };
    const _result = await getPaymentRecord(_params);
    setEnrollments(
      _result?.data?.items
    );
    setShowLoading(false);
  };

  useEffect(() => {
    fetchData();
  }, [type])

  const handleChangeType = (_type) => {
    setType(_type);
  };

  return (
    <>
      <div className="program-form-box p-3 mt-3">
        <div className="program-form-box-content">
          <div className="gap-3 d-flex flex-row justify-content-center my-3">
            <Button size="sm" variant={type == 0 ? 'primary' : 'gray'} onClick={() => handleChangeType(0)}>
              積分記錄
            </Button>
            <Button size="sm" variant={type == 1 ? 'primary' : 'gray'} onClick={() => handleChangeType(1)}>
              付款記錄
            </Button>
          </div>

          {!showLoading && (
            <PaymentHistoryTable tableData={enrollments}></PaymentHistoryTable>
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
        </div>
      </div>

      <Row className="mt-4">
        <Col>
          <div className="d-flex flex-row align-items-center justify-content-center gap-2">
            <Button className="btn-icon" onClick={() => {
                navigate('/other/account/home')
              }}>
                <FeatherIcon
                  icon="arrow-left"
                  className="icon icon-lg p-2"
                />
            </Button>
          </div>
        </Col>
      </Row>
    </>
  );
};

export default PaymentHistory;
