import React, { useEffect, useRef, useContext } from "react";
import useState from "react-usestateref";
import { Col, Row, Form, Button } from "react-bootstrap";
import FeatherIcon from "feather-icons-react";
import {
  loadCaptchaEnginge,
  LoadCanvasTemplate,
  LoadCanvasTemplateNoReload,
  validateCaptcha,
} from "react-simple-captcha";
// import emailjs from "@emailjs/browser";
import CenterContext from "../../utils/CenterContext";
import Alert from "react-bootstrap/Alert";
import { postContactUs } from "services/apiCore";
import MemberContext from "utils/MemberContext";

const EnquiryForm = () => {
  const initFormField = {
    // enquiry_type: "活動",
    memberInfoId: 0,
    name: "",
    email: "",
    telMobile: "",
    content: "",
    // captcha: "",
  };
  const [captcha, setCaptcha] = useState();
  const [formField, setFormField, formFieldRef] = useState(initFormField);
  const form = useRef();
  const { member } = useContext(MemberContext);
  const { center } = useContext(CenterContext);
  const [alert, setAlert] = useState({
    show: false,
    variant: "success",
    message: "",
  });
  // const emailServiceId = "service_7wpr2h9";
  // const emailTemplateId = "template_u2rzcuu";
  // const emailPublicKey = "F5HJ8GXowFqzsc959";

  useEffect(() => {
    formField.memberInfoId = member?.memberId || 0;
    setFormField(formField);
    // console.log(formFieldRef);

    loadCaptchaEnginge(6);
  }, []);

  // useEffect(() => {
  //   const _email1 = center?.code + "@ptsa-asia.com";
  //   const _email2 = "gordon.lau@ptsa-asia.com";
  //   setFormField({
  //     ...formField,
  //     center_name: center?.nameZH,
  //     center_email: _email2,
  //   });
  // }, [center]);

  const handleChange = (e) => {
    setFormField({ ...formField, [e.target.name]: e.target.value });
  };

  const handleReset = () => {
    setFormField(initFormField);
  };

  const handleSubmit = async () => {
    try {
      // validate captcha
      // console.log("formFieldRef.current", formFieldRef.current);
      if (validateCaptcha(captcha, false)) {
        const _result = await postContactUs(formFieldRef.current);
        // console.log(_result);
        setAlert({ show: true, variant: "success", message: "查詢已經送出" });
        // emailjs
        //   .sendForm(emailServiceId, emailTemplateId, form.current, emailPublicKey)
        //   .then(
        //     (result) => {
        //       console.log(result.text);
        //       setAlert({
        //         show: true,
        //         variant: "success",
        //         message: "查詢已經送出",
        //       });
        //     },
        //     (error) => {
        //       console.log(error.text);
        //       setAlert({
        //         show: true,
        //         variant: "danger",
        //         message: "查詢送出失敗 請再嘗試",
        //       });
        //     }
        //   );
      } else {
        setAlert({
          show: true,
          variant: "danger",
          message: "安全碼不正確 請再嘗試",
        });
      }
    } catch (err) {
      setAlert({
        show: true,
        variant: "danger",
        message: "發生錯誤 請再嘗試",
      });
    }
    setTimeout(() => {
      setAlert({ ...alert, show: false });
    }, 5000);
  };

  return (
    <>
      <h4 className="mt-3 mt-lg-0">網上查詢</h4>

      <hr className="my-4" />

      <form className="account-form" ref={form}>
        <Row className="pb-3">
          <Col lg={6}>
            {/* <Form.Label className="h4">查詢分類: </Form.Label>
            <Form.Select
              aria-label="selectSize"
              name="enquiry_type"
              value={formField?.enquiry_type}
              onChange={(e) => {
                handleChange(e);
              }}
            >
              <option value="活動">活動</option>
              <option value="課程">課程</option>
              <option value="服務">服務</option>
              <option value="其他">其他</option>
            </Form.Select> */}
            <Form.Label className="h4">聯絡人姓名: </Form.Label>
            <Form.Control
              type="text"
              name="name"
              value={formField?.name}
              onChange={(e) => {
                handleChange(e);
              }}
            />
            <Form.Label className="h4">聯絡電郵: </Form.Label>
            <Form.Control
              type="text"
              name="email"
              value={formField?.email}
              onChange={(e) => {
                handleChange(e);
              }}
            />
            <Form.Label className="h4">電話: </Form.Label>
            <Form.Control
              type="text"
              name="telMobile"
              value={formField?.telMobile}
              onChange={(e) => {
                handleChange(e);
              }}
            />
            <Form.Label className="h4">安全碼: </Form.Label>
            <Form.Control
              type="text"
              name="captcha"
              value={captcha}
              onChange={(e) => {
                setCaptcha(e.target.value);
              }}
            />{" "}
            <div className="pt-2">
              {" "}
              <LoadCanvasTemplate />
            </div>
          </Col>
          <Col lg={6}>
            <Form.Label className="h4">查詢詳情: </Form.Label>
            <Form.Control
              as="textarea"
              rows={4}
              name="content"
              value={formField?.content}
              onChange={(e) => {
                handleChange(e);
              }}
            />
          </Col>
        </Row>
        <Row className="align-items-center">
          <Col className="pb-3" lg={6} md={12}>
            <Button variant="info" onClick={handleSubmit}>
              提交
              <FeatherIcon icon="user-check" className="icon icon-xs ms-2" />
            </Button>{" "}
            <Button variant="white" onClick={handleReset}>
              重填
              <FeatherIcon icon="x-circle" className="icon icon-xs ms-2" />
            </Button>
          </Col>
        </Row>
        <input
          type="hidden"
          name="memberInfoId"
          value={formField.memberInfoId}
        />
      </form>

      <div
        style={{ position: "absolute", top: 0, left: 0, right: 0, zIndex: 999 }}
      >
        <Alert
          show={alert.show}
          variant={alert.variant}
          onClose={() => setAlert({ ...alert, show: false })}
          dismissible
          transition
          className="text-center"
        >
          {alert.message}
        </Alert>
      </div>
    </>
  );
};
export default EnquiryForm;
