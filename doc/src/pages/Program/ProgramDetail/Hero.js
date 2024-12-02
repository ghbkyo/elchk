import React, { useState, useEffect, useContext, useRef } from "react";
import { useNavigate, useParams, useSearchParams } from "react-router-dom";
import { Col, Container, Row, Button, Badge, Card, Form, Alert } from "react-bootstrap";
import FeatherIcon from "feather-icons-react";
import moment from "moment";
import classNames from "classnames";
import ShareIcons from "../../../components/ShareIcons";
import ReactTooltip from "react-tooltip";
import {
  getPaymentMethod,
  getMemberFamilyMember,
  postEnrollment,
  getSingleProgramInfo,
  getMemberCompanions,
  postPayment,
  postReceivablePayment,
  getMemberInfo
} from "../../../services/apiCore";
import { isCenterContainOnlinePayment } from "../../../utils/utils";
import MemberContext from "../../../utils/MemberContext";
import CenterContext from "../../../utils/CenterContext";
import ProgramEnrollCompanionInput from "../../../components/form/ProgramEnrollCompanionInput";
import MyModal from "components/MyModal";
import BgResult from '../../../assets/images/bg-result.png'
import { isLoggedIn } from "services/AuthService";

const Hero = ({
  program,
  img,
  sessions,
}) => {
  const [
    programEnrollCompanionInput,
    setProgramEnrollCompanionInput,
  ] = useState([]);
  const programEnrollCompanionInputRef = useRef([]);
  const [rowIndex, setrowIndex] = useState(0);
  const initValues = {
    programSessionIds: [],
    // paymentMethodId: "",
    remarks: "",
    memberCompanionIds: [],
    nonMemberCompanions: [],
  };
  const [searchParams] = useSearchParams();

  const [values, setValues] = useState(initValues);
  const navigate = useNavigate();
  const [showSuccessEnroll, setShowSuccessEnroll] = useState(false);
  const [maxPerson, setmaxPerson] = useState(0);
  const [programFees, setprogramFees] = useState();
  const [showEnrollment, setShowEnrollment] = useState(false)
  const [paymentOptions, setpaymentOptions] = useState();
  const [paymentMethod, setPaymentMethod] = useState();
  const [showOnlinePayment, setShowOnlinePayment] = useState(false);

  const [windowSize, setWindowSize] = useState(window.innerWidth);
  const [isMobile, setIsMobile] = useState(window.innerWidth < 992);
  
  const { member } = useContext(MemberContext);
  const { center } = useContext(CenterContext);
  const [companionOptions, setCompanionOptions] = useState();
  const [memberFamilyMember, setmemberFamilyMember] = useState();

  const [selectedSessions, setSelectedSessions] = useState([]); // selected session in input box
  const [showConfirmation, setShowConfirmation] = useState(false);
  const [total, setTotal] = useState(0.00);
  const [show, setShow] = useState(false)
  const [show2, setShow2] = useState(false)
  const [disableSubmit, setDisableSubmit] = useState(false);
  const [alert, setAlert] = useState({ alertType: "danger", alertMessage: "" });
  const [alertContent, setAlertContent] = useState('');
  const [alertTitle, setAlertTitle] = useState('');

  const handleWindowResize = (event) => {
    setWindowSize(window.innerWidth);
    setIsMobile(window.innerWidth < 992);
  };

  useEffect(() => {
    if (searchParams && searchParams.get('auth_response') == '00') {
      setShowEnrollment(true)
      setShowSuccessEnroll(true)

      if (searchParams.get('req_reference_number') && searchParams.get('auth_amount')) {
        let rn = searchParams.get('req_reference_number').split('A');
        postReceivablePayment({
          paymentMethodId: 1,
          accountReceivableId: rn[0],
          accountReceivablePaymentItems: [{
            accountReceivableItemId: rn[1],
            amount: searchParams.get('auth_amount')
          }]
        })
      }
    }
  }, []);
  useEffect(() => {
    window.addEventListener("resize", handleWindowResize);
    return () => {
      window.removeEventListener("resize", handleWindowResize);
    };
  }, [handleWindowResize]);

  const calculateTotal = () => {
    let totalPrice = selectedSessions.reduce((acc, session) => {
      const sessionData = sessions.find(s => s.id == session.value);
      return acc + (sessionData ? (sessionData.paymentAmount || 0) : 0); // 假設每個 session 有 price 屬性
    }, 0);
    totalPrice += (values.memberCompanionIds.length + values.nonMemberCompanions.length) * totalPrice
    setTotal(totalPrice);
  };

  useEffect(() => {
    calculateTotal();
  }, [selectedSessions, values])

  const handleAddCompanion = () => {
    const newInput = (
      <ProgramEnrollCompanionInput
        key={rowIndex}
        propsKey={rowIndex}
        handleDeleteCompanion={handleDeleteCompanion}
        textChange={handleChange}
        initialName=""
        initialTelMobile=""
      />
    )
    setProgramEnrollCompanionInput((prevInputs) => {
      const updatedInputs = [...prevInputs, newInput];
      programEnrollCompanionInputRef.current = updatedInputs;
      return updatedInputs;
    });

    const tempnonMember = values.nonMemberCompanions;
    tempnonMember.push({ id: rowIndex, name: "", telMobile: "" });
    setrowIndex(rowIndex + 1);
    setValues({ ...values, nonMemberCompanions: tempnonMember });
  };

  const handleDeleteCompanion = (rowIndex) => {
    setProgramEnrollCompanionInput(prevInputs => {
      const updatedInputs = prevInputs.filter(input => input.props.propsKey !== rowIndex);
      programEnrollCompanionInputRef.current = updatedInputs;
      return updatedInputs;
    });

    setValues(current => ({
      ...current,
      nonMemberCompanions: current.nonMemberCompanions.filter(x => x.id !== rowIndex)
    }));
  };
  
  const handleChange = (rowIndex, inputname, inputvalue) => {
    setValues(current => {
      return { ...current, nonMemberCompanions: current.nonMemberCompanions.map((item, index) => {
        if (item.id == rowIndex) {
          return {
            id: item.id,
            name: inputname == "name" ? inputvalue : item.name,
            telMobile: inputname == "telMobile" ? inputvalue : item.telMobile,
          };
        } else {
          return item;
        }
      }) }
    });
  };

  const handleClose = () => {
    setShow(false)
    setShow2(false);
  };

  const handleSessionChange = (e) => {
    const value = e.target.value
    if (e.target.checked) {
      setSelectedSessions(prev => [
        ...prev,
        {
          value: value,
          label: e.target.getAttribute('label')
        }
      ])
    } else {
      setSelectedSessions(prev => prev.filter((x) => x.value != value))
    }
  };

  const handlmemberCompanionIdssChange = (item) => {
    const _memberIds = values.memberCompanionIds
    if (_memberIds.indexOf(item.value) >= 0) {
      setValues({ ...values, memberCompanionIds: _memberIds.filter(x => x != item.value) })
    } else {
      _memberIds.push(item.value)
      setValues({
        ...values,
        memberCompanionIds: _memberIds
      })
    }
  };

  const handleJoin = async () => {
    setShow(false)
    setShow2(false)
    let paymentMethodTemp = [];
    const _param = {
      ComCenterId: center?.id,
      BoundType: "InBound",
      IsEnabled: true,
    };
    const paymentMethodResult = await getPaymentMethod(_param);
    (paymentMethodResult?.data || []).map((item, index) => {
      paymentMethodTemp.push({
        value: item.id,
        label: item.nameZN,
        color: "#0052CC",
      });
    });
    setShowOnlinePayment(
      // false
      isCenterContainOnlinePayment(paymentMethodResult?.data)
    );
    setPaymentMethod(paymentMethodResult?.data);
    setpaymentOptions(paymentMethodTemp);

    if (!!member && !companionOptions) {
      const params = { memberInfoId: member?.id, programInfoId: program.id };
      const result = await getMemberCompanions(params);
      setmemberFamilyMember(result.data);
      let tempCompanionOptions = [];
      (result?.data || []).map((item, index) => {
        tempCompanionOptions.push({
          value: item.id,
          label: item.name,
          color: "#00B8D9",
        });
      });
      setCompanionOptions(tempCompanionOptions);
    }

    setShowEnrollment(true)
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

  const fetchData = async () => {
    const result = await getSingleProgramInfo({ id: program.id });
    if (!result?.data) {
      alert("沒有活動資料");
      navigate(-1);
    }

    // 判斷會員是否在此活動中心
    const userResult = await getMemberInfo();
    let hasCenter = false;
    userResult.data.map((_member, index) => {
      if (_member.center?.id == result.data.center.id) {
        hasCenter = true;
      }
    });
    if (!hasCenter) {
      setAlertContent("只供本中心會員報名")
      setAlertTitle(`注意`)
      setShow2(true);
      return;
    }

    let registered = false;
    result.data.programSessions.map((item) => {
      if (item.registered === true) {
        //  你已報名活動，是否繼續報名？
        registered = true;
      }
    })
    if (registered) {
      if (result.data.canDuplicateEnrollment) {
        setShow(true)  // 允許重複報名
      } else {
        setAlertContent("不允許重複報名！")
        setAlertTitle(`你已報名活動 (${program?.name})`)
        setShow2(true)  // 不允許重複報名
      }
    } else {
      handleJoin()
    }
    
  };

  useEffect(() => {
    let tempvalue = 0;
    program?.programSessions?.map((item) => {
      tempvalue = tempvalue + item.maximunNumberOfPaticipant;
    });
    setmaxPerson(tempvalue);
    let programFeesStr = "";
    if (program?.isFree === false) {
      program?.programFees?.map((item) => {
        if (item.memberType) {
          programFeesStr =
            programFeesStr +
            item.memberType?.nameZH +
            "$" +
            item.amount +
            ";  ";
        } else {
          programFeesStr = programFeesStr + "非會員$" + item.amount + ";  ";
        }
      });
    } else if (program?.isFree === true) {
      programFeesStr = "免費";
    } else {
      programFeesStr = "";
    }
    setprogramFees(programFeesStr);
  }, [program]);

  const handleAlertClose = () => {
    setAlert({ ...alert, alertMessage: "" });
  };

  const handleNext = async () => {
    if (!selectedSessions.length) {
      setAlert({ alertType: "danger", alertMessage: "[場次]不能留空" });
      return false;
    }
    if (values.memberCompanionIds.length + values.nonMemberCompanions.length > program.maximunNumberOfCompanions) {
      setAlert({ alertType: "danger", alertMessage: "[同行人]最多可選擇 " + program.maximunNumberOfCompanions + " 人" });
      return false;
    }
    handleAlertClose()
    setShowConfirmation(true)
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

  const formValidation = () => {
    if (!selectedSessions.length) {
      setAlert({ alertType: "danger", alertMessage: "[場次]不能留空" });
      return false;
    }
    if (values.memberCompanionIds.length + values.nonMemberCompanions.length > program.maximunNumberOfCompanions) {
      setAlert({ alertType: "danger", alertMessage: "[同行人]最多可選擇 " + program.maximunNumberOfCompanions + " 人" });
      return false;
    }
    return true;
  };

  const handleSubmit = async () => {
    setDisableSubmit(true)
    handleAlertClose();
    if (formValidation()) {
      let nonMemberCompanions = [];
      values?.nonMemberCompanions.map((x) => {
        let t = { telMobile: x.telMobile, name: x.name };
        nonMemberCompanions.push(t);
      });
      // build submit enrollment param
      let params = {
        memberInfoId: member?.id,
        programInfoId: program?.id,
        remarks: values?.remarks,
        allowPhotography: true,
        // programSessionIds: values?.programSessionIds,
        programSessionIds: selectedSessions.map((item) => parseInt(item.value)),
        // paymentMethodId: values?.paymentMethodId ? values?.paymentMethodId : 0,
        memberCompanionIds: values?.memberCompanionIds,
        nonMemberCompanions: nonMemberCompanions,
      };

      try {
        const result = await postEnrollment(params);
        handleAlertClose();
        if (result.status == 200 && result.data.result == 'OK') {
          if (program.isFree) {
            setShowSuccessEnroll(true);
          } else {
            postPayment({
              ar_Id: result.data.accountReceivableId + 'A' + result.data.accountReceivablePaymentItems[0].accountReceivableItemId,
              amount: result.data.accountReceivablePaymentItems[0].amount,
              redirect: process.env.REACT_APP_URL + '/program/detail/' + program.id
            }, member);
          }
        }

        // setShowSuccessEnrollModal(true);

        // if online payment is available for the center, need to redirect
        // if (showOnlinePayment) {
        // if (checkOnlinePaymentMethod(paymentMethod, onlinePaymentType)) {
        // const enrollmentRecords = await getAccountReceivable({
        //   TransactionReferenceId: result.data.programEnrollmentId,
        // });
        // console.log("enrollmentRecords", enrollmentRecords);
        // const matchedEnrollment = enrollmentRecords?.data?.items.find(
        //   (enrollment) => {
        //     return (
        //       String(enrollment?.accountReceivable.id) ===
        //       String(result.data.accountReceivableId)
        //     );
        //   }
        // );
        // setPaymentState({
        //   ...paymentState,
        //   id: result.data.accountReceivableId,
        //   totalAmount: matchedEnrollment.accountReceivable.totalAmount,
        //   show: true,
        // });
        // }
        // setAlert({ alertType: "success", alertMessage: "報名成功" });
      } catch (err) {
        // console.error("handleSubmit.err", err, Object.values(err));
        setDisableSubmit(false)
        handleAlertClose();
        setAlert({
          alertType: "danger",
          alertMessage:
            err.response?.status === 500
              ? "發生錯誤"
              : String(Object.values(err)),
          // alertMessage: "發生錯誤",
        });
      }
    } else {
      setDisableSubmit(false);
    }
  };

  return (
    <>
      <Row className="py-2">
        <Col lg={12}>
          { img ? 
            <figure className="figure w-100 text-center pro-img-box rounded">
              <img
                src={img}
                alt="contentImage"
                className="figure-img img-fluid rounded pro-img-max-height-width"
              />
            </figure> : <></> }
        </Col>
      </Row>

      <Row>
        <Col>
          <h1 className="hero-title">{program?.name}</h1>
        </Col>
      </Row>

      { showEnrollment ? (
      <div>
        <div className="border-top pt-2 pb-4 align-items-center mt-2 font-size-large">
          日期：
          {moment(program?.enrollmentStartDate).format(
            process.env.REACT_APP_DATE_FORMAT
          )}
          {" - "}
          {moment(program?.enrollmentEndDate).format(process.env.REACT_APP_DATE_FORMAT)}

          時間：
          {moment(program?.enrollmentStartDate).format(
            process.env.REACT_APP_TIME_FORMAT
          )}
          {"-"}
          {moment(program?.enrollmentEndDate).format(process.env.REACT_APP_TIME_FORMAT)}
        </div>
        { showSuccessEnroll ? <>
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
              { program?.registrationMethod == 'ByTime' ? (program?.isFree ? '报名成功，谢谢你的参与' : '付款成功，謝謝你的參與。') : '待職員確認，謝謝你的參與。'}
            </div>

            <Row className="mt-3">
              <Col>
                <p className="fs-16" style={{color: '#909090'}}>成功報名後，不會發放收據。<br/>如需收據，請親自到中心向職員索取。</p>
              </Col>
            </Row>

            <Row className="mt-4">
              <Col lg={12}>
                <div className="d-flex flex-row justify-content-center align-items-center gap-3">
                  <Button
                    variant="warning"
                    className="py-2 px-8"
                    size="lg"
                    onClick={() => {
                      setShowSuccessEnroll(false);
                      setShowEnrollment(false);
                      navigate('/')
                    }}
                  >
                    返回
                  </Button>
                </div>
              </Col>
            </Row>
          </div>
        </> : !showConfirmation ? (
          <>
          <div className="program-form-box p-3">
            <h3>請選擇報名的節數</h3>
            <div className="program-form-box-content">
              <div>
                {sessions.map((item, index) => (
                  <div key={index}>
                    <Form.Check type="checkbox" className={classNames(item.disabled && 'disabled')}>
                      <Form.Check.Label>
                        <Form.Check.Input type="checkbox" value={item.id} label={item.venue} 
                          disabled={item.disabled}
                          checked={selectedSessions.some(session => session.value == item.id)}
                          onChange={handleSessionChange} /> 
                        {item.venue}: {moment(item.startDate).format(process.env.REACT_APP_DATETIME_FORMAT)} - {moment(item.endDate).format(process.env.REACT_APP_DATETIME_FORMAT)}
                      </Form.Check.Label>
                    </Form.Check>
                  </div>
                ))}
              </div>
            </div>
          </div>
          
          { program?.isCompanionAllowed ? 
          <div className="program-form-box p-3 mt-3">
            <h3>請選擇同行人</h3>
            <div className="program-form-box-content">
              <div className="program-form-tags mt-3 gap-3">
                {companionOptions.map((item, index) => (
                  <div key={index} className={classNames("item", values.memberCompanionIds.indexOf(item.value) >= 0 ? 'active': '')} 
                    onClick={(e) => handlmemberCompanionIdssChange(item)}>
                    <span>{item.label}</span>
                  </div>
                ))}
              </div>
              <h4 className="mt-6">新增同行人</h4>
              <div className="mt-1">
                <Button
                  variant="success"
                  className="me-2 mb-2 mb-sm-0 btn-icon d-inline-flex"
                  onClick={handleAddCompanion}
                >
                  <FeatherIcon icon="plus" className="icon icon-sm" />
                </Button>
                <div>{programEnrollCompanionInput.map((input, index) => 
                  React.cloneElement(input, {
                    key: input.props.propsKey,
                    initialName: values.nonMemberCompanions[index]?.name,
                    initialTelMobile: values.nonMemberCompanions[index]?.telMobile,
                  })
                )}</div>
              </div>
            </div>
          </div> : <></> }
          
          <div className="program-form-box p-3 mt-3">
            <h3>總數</h3>
            <div className="program-form-box-content">
              <span className="fw-bold" style={{'--sorignFontSize': '40px', fontSize: '40px'}}>HK${total.toFixed(2)}</span>
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
              <>
                <div className="d-flex flex-row justify-content-center align-items-center gap-3">
                  <Button className="btn-icon btn-lg" onClick={() => {
                    setValues(initValues)
                    setSelectedSessions([])
                    setProgramEnrollCompanionInput([])
                    setShowEnrollment(false)
                    window.scrollTo({ top: 0, behavior: "smooth" });
                  }}>
                    <FeatherIcon
                      icon="arrow-left"
                      className="icon icon-lg p-2"
                    />
                  </Button>

                  <Button
                    variant="warning"
                    className="py-2 px-8"
                    size="lg"
                    onClick={handleNext}
                  >
                    下一步
                    {/* <FeatherIcon
                      icon="user-check"
                      className="icon icon-xs ms-2"
                    /> */}
                  </Button>
                </div>
              </>
            </Col>
          </Row>
        </>
      ) : (
        // 确认信息视图
        <div className="confirmation-view">
          <div className="program-form-box p-3 mt-3">
            <div>
              <h3>報名的節數</h3>
              <div className="program-form-box-content mt-2">
                {selectedSessions.map((session, index) => (
                  <span key={index}>
                    {session.label}
                    {(index < selectedSessions.length - 1) && '、'}
                  </span>
                ))}
              </div>
            </div>
            <hr />
            { values.memberCompanionIds.length > 0 || values.nonMemberCompanions.length > 0 ? <>
              <div>
                <h3>同行人</h3>
                <div className="program-form-box-content mt-2">
                  {values.memberCompanionIds.map((id, index) => (
                    <span key={index}>
                      {companionOptions.find(option => option.value === id)?.label}
                      {(index < values.memberCompanionIds.length - 1 || values.nonMemberCompanions.length) ? '、' : ''}
                    </span>
                  ))}
                  {values.nonMemberCompanions.map((companion, index) => (
                    <span key={index}>
                      {companion.name}
                      {(index < values.nonMemberCompanions.length - 1) ? '、' : ''}
                    </span>
                  ))}
                </div>
              </div>
              <hr />
            </>: <></> }
            <div>
              <h3>總費用</h3>
              <div className="program-form-box-content mt-2">
                <span className="fw-bold" style={{'--sorignFontSize': '40px', fontSize: '40px'}}>HK${total.toFixed(2)}</span>
              </div>
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
            <Col lg={12}>
              <div className="d-flex flex-row justify-content-center align-items-center gap-3">
              <Button className="btn-icon btn-lg" onClick={() => {
                    setShowConfirmation(false)
                    handleAlertClose()
                    window.scrollTo({ top: 0, behavior: "smooth" });
                  }}>
                    <FeatherIcon
                      icon="arrow-left"
                      className="icon icon-lg p-2"
                    />
                  </Button>
                <Button
                  variant="warning"
                  className="py-2 px-8"
                  size="lg"
                  disabled={disableSubmit}
                  onClick={() => {
                    handleSubmit()
                  }}
                >
                  確認
                </Button>
              </div>
            </Col>
          </Row>
        </div>
      )}
      </div>
      ) : (
      <div>
        <div className="border-top pt-2 pb-4 align-items-center mt-2 font-size-large">
          {
            program?.hashtags.map((tag) => {
              return <span className="px-3 py-1 tag fee me-2">
                #{tag.name}
              </span>
            })
          }
          <span className="px-1"> </span>
          <span className="px-3 py-1 tag green">
            {program?.center.nameZH}
          </span>
        </div>

        <div className="align-items-center font-size-large mt-6 mt-xs-1">
          <Row>
            <Col className="pb-3" lg={6} md={12}>
              <div>
                <FeatherIcon
                  icon="calendar"
                  size="45"
                  color='#55BDB9'
                  className="px-2 pb-2  pointer"
                  data-tip="活動日期"
                />
                活動日期：
                {moment(program?.startDate).format(
                  process.env.REACT_APP_DATE_FORMAT
                )}
                {" - "}
                {moment(program?.endDate).format(process.env.REACT_APP_DATE_FORMAT)}
              </div>
              <div>
                <FeatherIcon
                  icon="calendar"
                  size="45"
                  color='#55BDB9'
                  className="px-2 pb-2  pointer"
                  data-tip="活動時間"
                />
                活動時間：
                {moment(program?.startDate).format(
                  process.env.REACT_APP_TIME_FORMAT
                )}
                {"-"}
                {moment(program?.endDate).format(process.env.REACT_APP_TIME_FORMAT)}
              </div>
              <div>
                <FeatherIcon
                  icon="calendar"
                  size="45"
                  color='#55BDB9'
                  className="px-2 pb-2  pointer"
                  data-tip="活動對象"
                />
                活動對象：
                {program?.programObject}
              </div>
              <div>
                <FeatherIcon
                  icon="user-check"
                  size="45"
                  color='#55BDB9'
                  className="px-2 pb-2  pointer"
                  data-tip="活動人數"
                />
                活動人數：
                {program?.programOnlineEnrollmentSetting?.enrollmentQuota}
              </div>
              <div>
                <FeatherIcon
                  icon="map-pin"
                  size="45"
                  color='#55BDB9'
                  className="px-2 pb-2  pointer"
                  data-tip="活動場地"
                />
                活動場地：
                {program?.venue}
              </div>
              <div>
                <FeatherIcon
                  icon="credit-card"
                  size="45"
                  color='#55BDB9'
                  className="px-2 pb-2  pointer"
                  data-tip="負責同事"
                />
                負責同事：
                {(program?.programStaffs || []).map(
                  (item) => item.staffUser.nameZH.fullName
                )}
              </div>
              <div>
                <FeatherIcon
                  icon="dollar-sign"
                  size="45"
                  color='#55BDB9'
                  className="px-2 pb-2  pointer"
                  data-tip="費用"
                />
                費用：
                {programFees}
              </div>
              <div>
                <FeatherIcon
                  icon="bell"
                  size="45"
                  color='#55BDB9'
                  className="px-2 pb-2  pointer"
                  data-tip="報名時段"
                />
                報名時段：
                {moment(program?.enrollmentStartDate).format(
                  process.env.REACT_APP_DATE_FORMAT
                )}
                {" - "}
                {moment(program?.enrollmentEndDate).format(
                  process.env.REACT_APP_DATE_FORMAT
                )}
              </div>

            </Col>

            <Col className="pb-3" lg={6} md={12}>
              <h3 className="pro-content-title"><span>活動內容</span></h3>
              <div className="border p-2 pro-content-box">
                {program?.introduction}
              </div>
            </Col>
          </Row>
          <Row className="mt-4">
            <Col>
              <>
                {isLoggedIn() ? (
                  <div className="text-center">
                    <Button
                      variant='warning'
                      className="py-2 px-8"
                      size="lg"
                      onClick={fetchData}
                      disabled={program?.isOnline ? false : true}
                    >
                      { program?.isOnline ? '報名' : '此活動只接受於中心報名' }
                    </Button>
                  </div>
                ) : (
                  <div className="text-center">
                    { program?.isOnline ?
                      <Button
                        variant='warning'
                        className="py-2 px-8"
                        size="lg"
                        onClick={() => {
                          navigate('/login')
                        }}
                      >
                        請先登入
                      </Button> : 
                      <Button
                        variant='warning'
                        className="py-2 px-8"
                        size="lg"
                        disabled={true}
                      >
                        此活動只接受於中心報名
                      </Button>
                    }
                  </div>
                )}
              </>
            </Col>
          </Row>
        </div>
      </div>) }
      <Row className="py-2">
        <Col className="pb-1 text-end" md={12}>
          <div>
            <span className="px-2">分享</span>
            <ShareIcons />
          </div>
        </Col>
      </Row>

      <ReactTooltip />
      {/* </Container>  */}
      {/* </section> */}
      
      <MyModal show={show} onHide={handleClose} title={(
        <div>
          你已報名活動 ({program?.name})
          <br />
          日期/時間衝突
        </div>
      )} content="是否繼續報名?" onConfirm={handleJoin} />
      
      <MyModal show={show2} title={(
        <div>
          {alertTitle}
        </div>
      )} content={alertContent} onConfirm={handleClose} confirmText='確認' hideCancel={true} />
    </>
  );
};

export default Hero;
