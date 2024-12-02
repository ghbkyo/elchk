import { useEffect, useContext } from "react";
import useState from "react-usestateref";
import { Alert, Button, Form, Modal } from "react-bootstrap";
import FeatherIcon from "feather-icons-react";
import Select from "react-select";
import { NavLink } from "react-router-dom";
import makeAnimated from "react-select/animated";
import ProgramEnrollCompanionInput from "../../../components/form/ProgramEnrollCompanionInput";
import moment from "moment";
import {
  getPaymentMethod,
  getMemberFamilyMember,
  postEnrollment,
} from "../../../services/apiCore";
import MemberContext from "../../../utils/MemberContext";
import CenterContext from "../../../utils/CenterContext";
import { isCenterContainOnlinePayment } from "../../../utils/utils";
// import { Tick } from 'react-crude-animated-tick';
import { Player, Controls } from "@lottiefiles/react-lottie-player";
import PaymentForm from "../../../components/payment/PaymentForm";
import LottieEnrollSuccess from "assets/json/LottieEnrollSuccess.json";

const ProgramEnrollmentModal = ({
  program,
  handleClose,
  show,
  sessions,
  selectedSession,
}) => {
  const [
    programEnrollCompanionInput,
    setProgramEnrollCompanionInput,
    programEnrollCompanionInputRef,
  ] = useState([]);
  const [sessionOptions, setSessionOptions] = useState(); // full list of sessions
  const [selectedSessions, setSelectedSessions] = useState({}); // selected session in input box
  const [paymentOptions, setpaymentOptions] = useState();
  const [paymentMethod, setPaymentMethod] = useState();
  const animatedComponents = makeAnimated();
  const { member } = useContext(MemberContext);
  const { center } = useContext(CenterContext);
  const [companionOptions, setCompanionOptions] = useState();
  const [rowIndex, setrowIndex] = useState(0);
  const [memberFamilyMember, setmemberFamilyMember] = useState();
  const initValues = {
    programSessionIds: [],
    // paymentMethodId: "",
    remarks: "",
    memberCompanionIds: [],
    nonMemberCompanions: [],
  };
  const [values, setValues, valuesRef] = useState(initValues);
  const [alert, setAlert] = useState({ alertType: "danger", alertMessage: "" });
  const [disableSubmit, setDisableSubmit] = useState(false);
  const [showSuccessEnrollModal, setShowSuccessEnrollModal] = useState(false);

  const initPaymentState = { paymentStatus: "default", show: false };
  const [paymentState, setPaymentState] = useState(initPaymentState);
  const [showOnlinePayment, setShowOnlinePayment] = useState(false);
  const onlinePaymentType = ["FPS", "信用卡"];

  const buildSessionObject = (item) => {
    return {
      value: item.id,
      label:
        item.venue +
        " (" +
        moment(item?.startDate).format(process.env.REACT_APP_DATETIME_FORMAT) +
        " - " +
        moment(item?.endDate).format(process.env.REACT_APP_DATETIME_FORMAT) +
        ")",
      color: "#0052CC",
    };
  };

  useEffect(() => {
    let sessionTemp = [];
    (sessions || []).map((item, index) => {
      sessionTemp.push(buildSessionObject(item));
      // sessionTemp.push({
      //   value: item.id,
      //   label:
      //     item.venue +
      //     " (" +
      //     moment(item?.startDate).format(
      //       process.env.REACT_APP_DATETIME_FORMAT
      //     ) +
      //     " - " +
      //     moment(item?.endDate).format(process.env.REACT_APP_DATETIME_FORMAT) +
      //     ")",
      //   color: "#0052CC",
      // });
    });
    setSessionOptions(sessionTemp);
    if (!!selectedSession) {
      setSelectedSessions([buildSessionObject(selectedSession)]);
    } else {
      setSelectedSessions(sessionTemp);
    }
  }, [sessions, selectedSession]);

  useEffect(() => {
    const fetchData = async () => {
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
        const params = { MemberInfoId: member?.id, IsMember: true };
        const result = await getMemberFamilyMember(params);
        setmemberFamilyMember(result.data);
        let tempCompanionOptions = [];
        (result?.data || []).map((item, index) => {
          tempCompanionOptions.push({
            value: item.familyMemberMemberInfoId,
            label: item.nameZH.fullName,
            color: "#00B8D9",
          });
        });
        setCompanionOptions(tempCompanionOptions);
      }
    };
    fetchData();
  }, [center, member]);


  const handleAddCompanion = () => {
    setProgramEnrollCompanionInput([
      ...programEnrollCompanionInput,
      <ProgramEnrollCompanionInput
        key={rowIndex}
        propsKey={rowIndex}
        handleDeleteCompanion={handleDeleteCompanion}
        textChange={handleChange}
      />,
    ]);

    const tempnonMember = values.nonMemberCompanions;
    tempnonMember.push({ id: rowIndex, name: "", telMobile: "" });
    setrowIndex(rowIndex + 1);
    setValues({ ...values, nonMemberCompanions: tempnonMember });
  };

  const handlmemberCompanionIdssChange = (e) => {
    if (e) {
      if (e.length > 0) {
        const memberArr = [];
        e.map((x) => {
          memberArr.push(x.value);
        });
        setValues({ ...values, memberCompanionIds: memberArr });
      } else {
        setValues({ ...values, memberCompanionIds: [] });
      }
    } else {
      setValues({ ...values, memberCompanionIds: [] });
    }
  };

  const handleDeleteCompanion = (rowIndex) => {
    setProgramEnrollCompanionInput(
      programEnrollCompanionInputRef.current.filter((x) => x.key != rowIndex)
    );
    setValues({
      ...values,
      nonMemberCompanions: valuesRef.current.nonMemberCompanions.filter(
        (x) => x.id != rowIndex
      ),
    });
  };

  const handleSessionChange = (e) => {
    setSelectedSessions(e);
    // if (e) {
    //   if (e.length > 0) {
    //     const sessionArr = [];
    //     e.map((x) => {
    //       sessionArr.push(x.value);
    //     });
    //     console.log("e", e)
    //     console.log("sessionArr", sessionArr)
    //     setValues({ ...values, programSessionIds: sessionArr });
    //   } else {
    //     setValues({ ...values, programSessionIds: [] });
    //   }
    // } else {
    //   setValues({ ...values, programSessionIds: [] });
    // }
  };

  const handlepaymentMethodChange = (e) => {
    if (e) {
      setValues({ ...values, paymentMethodId: e.value });
    } else {
      setValues({ ...values, paymentMethodId: "" });
    }
  };

  const handleRemarkChange = (e) => {
    if (e && e.target) {
      setValues({ ...values, remarks: e.target.value });
    } else {
      setValues({ ...values, remarks: "" });
    }
  };

  const handleChange = (rowIndex, inputname, inputvalue) => {
    const nonMemberList = valuesRef?.current?.nonMemberCompanions?.map(
      (item, index) => {
        if (item.id == rowIndex) {
          return {
            id: item.id,
            name: inputname == "name" ? inputvalue : item.name,
            telMobile: inputname == "telMobile" ? inputvalue : item.telMobile,
          };
        } else {
          return item;
        }
      }
    );

    // const nonMemberTemp = valuesRef?.current.nonMemberCompanions?.filter(
    //     (x) => x.id != rowIndex
    // )
    // const nonMemberTemp2 = valuesRef?.current.nonMemberCompanions?.filter(
    //     (x) => x.id == rowIndex
    // )
    // if (inputname == "name") {
    //     nonMemberTemp.push({
    //         id: rowIndex,
    //         name: inputvalue,
    //         telMobile: nonMemberTemp2[0].telMobile,
    //     })
    // } else if (inputname == "telMobile") {
    //     nonMemberTemp.push({
    //         id: rowIndex,
    //         name: nonMemberTemp2[0].name,
    //         telMobile: inputvalue,
    //     })
    // }
    setValues({ ...values, nonMemberCompanions: nonMemberList });
  };

  const handleAlertClose = () => {
    setAlert({ ...alert, alertMessage: "" });
  };

  const handleModalClose = () => {
    handleDisableSubmit(false);
    handleAlertClose();
    setValues(initValues);
    setProgramEnrollCompanionInput([]);
    setPaymentState(initPaymentState);
    handleClose();
  };

  const handleDisableSubmit = (bool) => {
    setDisableSubmit(bool);
  };

  const formValidation = () => {
    if (!selectedSessions.length) {
      setAlert({ alertType: "danger", alertMessage: "[場次]不能留空" });
      return false;
    }
    // if (!valuesRef.current.paymentMethodId) {
    //   setAlert({ alertType: "danger", alertMessage: "[付款方式]不能留空" });
    //   return false;
    // }
    return true;
  };

  const checkOnlinePaymentMethod = (_paymentMethod, _onlinePaymentType) => {
    for (let i = 0; i < _onlinePaymentType.length; i++) {
      if (
        (_paymentMethod || []).find((item) => {
          return String(item.id) === String(values?.paymentMethodId);
        })?.nameZN === _onlinePaymentType[i]
      ) {
        return true;
      }
    }
    return false;
  };

  const handleSubmit = async () => {
    handleDisableSubmit(true);
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
        programSessionIds: selectedSessions.map((item) => item.value),
        // paymentMethodId: values?.paymentMethodId ? values?.paymentMethodId : 0,
        memberCompanionIds: values?.memberCompanionIds,
        nonMemberCompanions: nonMemberCompanions,
      };

      try {
        const result = await postEnrollment(params);
        console.log("result", result);
        handleAlertClose();
        handleModalClose();
        setShowSuccessEnrollModal(true);

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
        handleDisableSubmit(false);
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
      handleDisableSubmit(false);
    }
  };

  return (
    <>
      {/* standard modal */}
      <Modal show={show} onHide={handleModalClose} size="lg" backdrop="static">
        <Modal.Header className="px-5" onHide={handleModalClose} closeButton>
          <Modal.Title as="h3" className="p-3">
            活動報名 - {program?.name}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body className="p-3">
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
          <Form>
            <div className="px-5">
              <h5>場次</h5>
              <Select
                name="session"
                closeMenuOnSelect={false}
                components={animatedComponents}
                isMulti
                placeholder="可多選"
                options={sessionOptions}
                value={selectedSessions}
                onChange={(e) => {
                  handleSessionChange(e);
                }}
              />

              {/* <h5 className="pt-3">付款方式</h5>
              <Select
                className="basic-single"
                classNamePrefix="select"
                name="paymentMethod"
                isDisabled={false}
                isLoading={false}
                isClearable={true}
                isRtl={false}
                isSearchable={false}
                placeholder="單選"
                options={paymentOptions}
                onChange={(e) => {
                  handlepaymentMethodChange(e);
                }}
              /> */}

              <Form.Group className="pt-3" controlId="formBasicText">
                <Form.Label>
                  <h5>備註</h5>
                </Form.Label>
                <Form.Control
                  type="text"
                  placeholder="備註"
                  value={values?.remarks ? values.remarks : ""}
                  onChange={(e) => {
                    handleRemarkChange(e);
                  }}
                />
              </Form.Group>

              {/* only show it when isCompanionAllowed = True */}
              {!!program?.programOnlineEnrollmentSetting.isCompanionAllowed && (
                <div className="pt-3">
                  <h5>同行人士 (會員)</h5>
                  <Select
                    closeMenuOnSelect={false}
                    components={animatedComponents}
                    isMulti
                    isSearchable={false}
                    placeholder="可多選"
                    options={companionOptions}
                    onChange={(e) => {
                      handlmemberCompanionIdssChange(e);
                    }}
                  />
                </div>
              )}

              {/* only show it when isCompanionAllowed = True and isCompanionMemberOnly = False */}
              {!!program?.programOnlineEnrollmentSetting?.isCompanionAllowed &&
                !program?.programOnlineEnrollmentSetting
                  ?.isCompanionMemberOnly && (
                  <div>
                    <h5 className="pt-3">其他同行人士 (非會員)</h5>
                    <Button
                      variant="success"
                      className="me-2 mb-2 mb-sm-0 btn-icon d-inline-flex"
                      onClick={handleAddCompanion}
                    >
                      <FeatherIcon icon="plus" className="icon icon-sm" />
                    </Button>
                    <div>{programEnrollCompanionInput}</div>
                  </div>
                )}
            </div>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="white" onClick={handleModalClose}>
            離開
          </Button>{" "}
          <Button onClick={handleSubmit} disabled={disableSubmit}>
            報名
          </Button>
        </Modal.Footer>
      </Modal>

      <Modal
        show={showSuccessEnrollModal}
        onHide={() => setShowSuccessEnrollModal(false)}
        size="lg"
        backdrop="static"
      >
        <Modal.Header
          className="px-5"
          onHide={() => setShowSuccessEnrollModal(false)}
          closeButton
        >
          <Modal.Title as="h3" className="py-3 w-100 text-center">
            <div>報名成功</div>
          </Modal.Title>
        </Modal.Header>
        <Modal.Body className="p-3 text-center">
          {/* <FeatherIcon icon="check-circle" className="icon icon-sm text-success" /> */}
          {/* <Tick size={200} className="text-success"/> */}
          <Player
            autoplay
            keepLastFrame
            // src="https://assets10.lottiefiles.com/packages/lf20_yom6uvgj.json"
            src={LottieEnrollSuccess}
            style={{ height: "300px", width: "300px" }}
          ></Player>

          {!!showOnlinePayment && (
            <Button>
              <NavLink
                to="/other/account/programEnrollment"
                className="text-white"
              >
                網上付款
              </NavLink>
            </Button>
          )}

          {/* {!!paymentState.show && (
            <PaymentForm
              paymentId={paymentState.id}
              programPrice={paymentState.totalAmount}
              paymentStatusProp={paymentState.paymentStatus}
            ></PaymentForm>
          )} */}
        </Modal.Body>
        <Modal.Footer className="text-center">
          <div>
            <Button
              variant="white"
              onClick={() => setShowSuccessEnrollModal(false)}
            >
              離開
            </Button>
          </div>
        </Modal.Footer>
      </Modal>
    </>
  );
};

export default ProgramEnrollmentModal;
