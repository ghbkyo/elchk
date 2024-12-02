import { useContext, useState } from "react";
import { Button, Col, Row, Alert } from "react-bootstrap";
import * as yup from "yup";
import { yupResolver } from "@hookform/resolvers/yup";

// components
import { FormInput, VerticalForm } from "../../../../components/form";
import MemberContext from "utils/MemberContext";
import { resetPassword } from "services/apiCore";
import { toast } from "react-hot-toast";

const ResetPassword = () => {
  const { member } = useContext(MemberContext);
  const [mewPw, setNewPw] = useState();
  const [alert, setAlert] = useState({
    show: false,
    variant: "success",
    message: "",
  });
  /*
    form validation schema
    */
  const schemaResolver = yupResolver(
    yup.object().shape({
      // current_password: yup.string().required('Please enter Current Password'),
      new_password: yup
        .string()
        .required("請輸入密碼")
        .matches(
          /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{0,}$/,
          "密碼最少要有一個大階英文，細階英文，數字和符號。"
        )
        .min(8, "密碼最少要有8個字。"),
      confirm_password: yup
        .string()
        .oneOf([yup.ref("new_password"), null], "請輸入相同密碼")
        .required("請輸入確認新密碼"),
    })
  );

  const handleChange = (e) => {
    setNewPw(e.target.value);
  };

  const resetPw = async (params) => {
    try {
      const _result = await resetPassword(params);
      if (_result.status === 200 || _result.status === 204) {
        toast.success("密碼已更新");
        // setAlert({ show: true, variant: "success", message: "密碼已重設" });
      }
    } catch (e) {
      toast.error("發生錯誤");
    }

    setTimeout(() => {
      setAlert({ ...alert, show: false });
    }, 5000);
  };

  /*
    handle form submission
    */
  const onSubmit = () => {
    resetPw({ id: member.id, password: mewPw });
  };

  return (
    <>
      <div
        style={{ position: "absolute", top: 0, left: 0, right: 0, zIndex: 999 }}
      >
        {/* <Alert
          show={alert.show}
          variant={alert.variant}
          onClose={() => setAlert({ ...alert, show: false })}
          dismissible
          transition
          className="text-center"
        >
          {alert.message}
        </Alert> */}
      </div>

      <h4 className="mt-3 mt-lg-0">重設密碼</h4>
      <VerticalForm
        onSubmit={onSubmit}
        resolver={schemaResolver}
        formClass="password-form mt-4"
      >
        {/* <FormInput label={'當前密碼'} type="password" name="current_password" containerClass={'mb-3'} /> */}
        <FormInput
          label={"新密碼"}
          type="password"
          name="new_password"
          containerClass={"mb-3 fs-4"}
          labelClassName={"fs-4"}
          onChange={(e) => {
            handleChange(e);
          }}
        />
        <FormInput
          label={"確認新密碼"}
          type="password"
          name="confirm_password"
          containerClass={"mb-3 fs-4"}
          labelClassName={"fs-4"}
        />

        <hr className="my-4" />

        <Row className="mt-3">
          <Col lg={12}>
            <Button type="submit" className="fs-4">
              更新密碼
            </Button>
          </Col>
        </Row>
      </VerticalForm>
    </>
  );
};

export default ResetPassword;
