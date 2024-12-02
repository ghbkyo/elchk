import React, { useEffect, useState, useContext, useRef } from "react";
import { Col, Row, Button, Form, Alert } from "react-bootstrap";
import { useNavigate, useSearchParams } from "react-router-dom";
import moment from "moment";
import classNames from "classnames";
import LottieLoadingFile from "assets/json/LottieLoadingFile.json";
import MemberContext from "../../../../utils/MemberContext";
import CenterContext from "../../../../utils/CenterContext";
import FeatherIcon from "feather-icons-react";
import {
  getMemberRenewInfo,
  postPayment,
  postUpgradeMember,
  postReceivablePayment,
  getMemberInfo,
  getMemberPhoto
} from "../../../../services/apiCore";
import BgResult from '../../../../assets/images/bg-result.png'

const Upgrade = () => {
  const navigate = useNavigate();
  
  const [disableSubmit, setDisableSubmit] = useState(false);
  const { member, changeMember } = useContext(MemberContext);
  const { center } = useContext(CenterContext);
  const [ renewInfo, setRenewInfo ] = useState()
  const [ selectedMemberType, setSelectedMemberType ] = useState();
  const [alert, setAlert] = useState({ alertType: "danger", alertMessage: "" });
  const [ showSuccess, setShowSuccess ] = useState(false);
  
  const [searchParams] = useSearchParams();

  const handleAlertClose = () => {
    setAlert({ ...alert, alertMessage: "" });
  };

  const getMemberList = async () => {
    const userResult = await getMemberInfo();
    return userResult.data;
  };

  useEffect(() => {
    if (searchParams && searchParams.get('auth_response') == '00') {
      setShowSuccess(true)
      if (searchParams.get('req_reference_number') && searchParams.get('auth_amount')) {
        let rn = searchParams.get('req_reference_number').split('A');
        postReceivablePayment({
          paymentMethodId: 1,
          accountReceivableId: rn[0],
          accountReceivablePaymentItems: [{
            accountReceivableItemId: rn[1],
            amount: searchParams.get('auth_amount')
          }]
        }).then(async () => {
          // 更新會員中心資料
          const memberList = await getMemberList();

          const newMemberOptions = memberList.find(
            (member) => String(member.center.id) === String(center.id)
          );
      
          !!newMemberOptions &&
            sessionStorage.setItem("member", JSON.stringify(newMemberOptions));
      
          if (!!newMemberOptions) {
            const userImg = await getMemberPhoto(newMemberOptions.id);
            !!userImg && sessionStorage.setItem("userImg", userImg.data);
          }
          !!newMemberOptions && changeMember(newMemberOptions);
        })
      }
    }
  }, []);

  async function fetchData() {
    if (member) {
      const params = { memberInfoId: member?.id, CenterId: center.id };
      const result = await getMemberRenewInfo(params);
      if (result.status == 200) {
        setRenewInfo(result.data)
      }
    }
  }

  useEffect(async () => {
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

    await fetchData();

    async function fetchDataAndAdjust() {
      
      setTimeout(function () {
        adjustFontSize();
      }, 1000); //await
    }
    fetchDataAndAdjust();
  }, [center, member]);

  const handleSubmit = () => {
    handleAlertClose()
    if (selectedMemberType) {
      setDisableSubmit(true)
      postUpgradeMember({
        memberInfoId: member.id,
        memberTypeId: selectedMemberType.memberType.id,
        startDate: renewInfo.startDate,
        expiryDate: renewInfo.expiryDate,
        startChargeDate: renewInfo.startChargeDate
      }).then((res) => {
        if (res && res.status == 200) {
          if (res.data.status == true) {
            postPayment({
              amount: res.data.accountReceivablePaymentItems[0].amount,
              ar_Id: res.data.accountReceivableId + 'A' + res.data.accountReceivablePaymentItems[0].accountReceivableItemId,
              redirect: process.env.REACT_APP_URL + '/other/account/upgrade'
            }, member);
          }
        } else {
          setAlert({ alertType: "danger", alertMessage: "系統出錯，請稍候再試" })
        }
      }).catch((err) => {
        if (err.response?.data?.errors) {
          setAlert({ alertType: "danger", alertMessage: "錯誤：" + Object.values(err.response.data.errors).join('; ') })
        } else {
          setAlert({ alertType: "danger", alertMessage: "系統出錯，請稍候再試" })
        }
      }).finally(() => {
        setDisableSubmit(false);
      })
    }
  }

  return (
    <>
    { showSuccess ? <>
        <div className="d-flex justify-content-center flex-column align-items-center">
          <div className="mb-6 pt-8 container-fluid text-center" style={{
            backgroundImage: 'url(' + BgResult + ')',
            backgroundRepeat: 'no-repeat',
            backgroundSize: '100% auto',
            backgroundPosition: 'top center'
          }}>
            <FeatherIcon icon='check-circle' size={80} color='#58C5E6' />
          </div>
          <div className="fs-16" style={{color: '#909090'}}>
            付款成功，謝謝你的參與。
          </div>

          <Row className="mt-4">
            <Col lg={12}>
              <div className="d-flex flex-row justify-content-center align-items-center gap-3">
                <Button
                  variant="warning"
                  className="py-2 px-8"
                  size="lg"
                  onClick={() => {
                    setShowSuccess(false);
                    navigate('/other/account/home')
                  }}
                >
                  返回
                </Button>
              </div>
            </Col>
          </Row>
        </div>
      </> : 
      <>
        <div className="program-form-box p-3 mt-3">
          <div className="program-form-box-content">
            { renewInfo?.memberTypes ? <>
              <h2 style={{
                fontSize: '28px'
              }}>{renewInfo?.memberTypes[0]?.comCenter.nameZH}</h2>
              <div className="text-pink fs-18">
                會籍到期日：{moment(member.expiryDate).format(process.env.REACT_APP_DATE2_FORMAT)}
                { !renewInfo?.isCanRenew && member?.memberType?.id ? <div style={{fontWeight: 'bold', color: member.memberType.colour}}>{member.memberType.nameZH}</div> : <></> }
              </div>
              <div className="fs-18 text-gray">
                { renewInfo?.memberTypes?.map((item, index) => {
                  return <span className="fs-18" key={index}>
                      { item.memberType.nameZH }(每年 ${ item.fee }) { index < renewInfo.memberTypes.length - 1 ? <span style={{
                        margin: '0 10px'
                      }}>|</span> : '' }
                  </span>
                }) }
              </div>
              <div className="mt-2">
                { renewInfo?.memberTypes?.map((item, index) => {
                  return <div key={index}>
                    <Form.Check type='radio' 
                      name="memberType"
                      style={{
                        fontSize: '18px'
                      }}
                      className="member-type-checkbox"
                      id={`memberType-${item.id}`}
                      onChange={(e) => {
                        setSelectedMemberType(item)
                      }}
                      label={`${item.memberType.nameZH}會籍：更新至 ${moment(renewInfo.expiryDate).format(process.env.REACT_APP_DATE2_FORMAT)}`} />
                  </div>
                }) }
              </div>
            </> : <></> }
          </div>
        </div>

        <Row className="mt-4">
          <Col lg={12}>
              {!!alert?.alertMessage && (
              <div className="px-5">
                <Alert
                  variant={alert?.alertType}
                  dismissible
                  onClose={() => handleAlertClose()}
                >
                  <div>{alert?.alertMessage}</div>
                </Alert>
              </div>
            )}
          </Col>
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
              <Button variant="indigo" className="px-6" disabled={disableSubmit} onClick={() => {
                handleSubmit()
              }}>確認及前往付款</Button>
            </div>
          </Col>
        </Row>
      </> }
    </>
  );
};

export default Upgrade;
