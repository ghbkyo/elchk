import React, { useEffect, useState, useContext } from "react";
import { Col, Row, Button } from "react-bootstrap";
import { useForm } from "react-hook-form";
import * as yup from "yup";
import { yupResolver } from "@hookform/resolvers/yup";
import {
  getUserimgStorage,
  getMemberStorage,
  getCenterStorage,
} from "../../../../services/AuthService";
import moment from "moment";
// components
import { FormInput } from "../../../../components/form";
import MemberContext from "../../../../utils/MemberContext";
import CenterContext from "../../../../utils/CenterContext";
import default_img from "../../../../assets/images/avatars/default.png";
import FeatherIcon from "feather-icons-react";
import { useNavigate } from "react-router-dom";
import { postMemberInfoUpdate } from "services/apiCore";

const AccountInformation = () => {
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate();
  const [otherField, setotherField] = useState({
    name: "",
    email: "",
    nameZH: "",
    phone: "",
    memberNo: "",
    gender: "",
    telMobile: "",
    age: "",
    birthdate: "",
    originCenter: "",
    center: "",
    loyaltyPoint: "0",
    QRCode: "0",
    address: "",
  });
  const [img, setImg] = useState(getUserimgStorage());
  const { member, changeMember } = useContext(MemberContext);
  const { center } = useContext(CenterContext);
  const [errors, setErrors] = useState({})
  const [updateSuccess, setUpdateSuccess] = useState(false)

  useEffect(() => {
    reloadData();
    setImg(getUserimgStorage());
  }, [member, center]);

  const handleSave = async (e) => {
    if (loading) return;
    setErrors([])
    setUpdateSuccess(false)
    setLoading(true)
    try {
      const res = await postMemberInfoUpdate({
        memberInfoId: member.id,
        firstNameZH: otherField.firstNameZH,
        lastNameZH: otherField.lastNameZH,
        email: otherField.email,
        telMobile: otherField.telMobile,
        address: otherField.address
      })
      if (res.status == 200) {
        if (res.data.result == 'OK') {
          const newMemberOptions = {
            ...member,
            email: otherField.email,
            telMobile: otherField.telMobile,
            addressRemarks: otherField.address,
            nameZH: {
              firstName: otherField.firstNameZH,
              lastName: otherField.lastNameZH,
              fullName: otherField.lastNameZH + ' ' + otherField.firstNameZH
            }
          }
          sessionStorage.setItem("member", JSON.stringify(
            newMemberOptions
          ));
          changeMember(newMemberOptions);
          setUpdateSuccess(true)
        }
      }
    } catch (err) {
      setErrors(err)
    }
    // changeMember()
    setLoading(false)
  }

  const reloadData = () => {
    const result = member;
    !!member &&
      setotherField({
        firstNameZH: result.nameZH?.firstName,
        lastNameZH: result.nameZH?.lastName,
        firstNameEN: result.nameEN?.firstName,
        lastNameEN: result.nameEN?.lastName,
        email: result.email,
        phone: result.telHome,
        memberNo: result.memberNo,
        gender: result.gender,
        telMobile: result.telMobile,
        age: result.age,
        birthdate: moment(result.birthdate).format(
          process.env.REACT_APP_DATE_FORMAT
        ),
        address: result.addressRemarks ? result.addressRemarks : "",
        originCenter: result.originCenter?.nameZH,
        center: result.center?.nameZH,
        loyaltyPoint: result.loyaltyPoint,
        QRCode: result.memberNo,
      });
  };

  return (
    <>
      <div className="program-form-box p-3 mt-3">
        <div className="program-form-box-content">
          <form className="account-form">
            <Row className="align-items-start">
              <Col xs={3}>
                <div>
                  <img
                    src={img ? img : default_img}
                    className="img-fluid avatar-md rounded-circle shadow"
                    alt="..."
                  />
                </div>
              </Col>
              <Col xs={9}>
                <Row className="align-items-center">
                  <Col lg={12}>
                    <FormInput
                      type="text"
                      label="會員編號"
                      placeholder=""
                      name="memberNo"
                      containerClass="mb-3"
                      readOnly="readonly"
                      value={otherField?.memberNo ? otherField?.memberNo : ""}
                    />
                  </Col>
                  <Col lg={12}>
                    <Row className="align-items-center">
                      <Col lg={6}>
                          <FormInput
                              type="text"
                              label="姓"
                              placeholder=""
                              name="lastNameZH"
                              containerClass="mb-3"
                              value={otherField?.lastNameZH ? otherField?.lastNameZH : ""}
                              onChange={(e) => {
                                  setotherField({ ...otherField, lastNameZH: e.target.value })
                              }}
                          />
                      </Col>
                      <Col lg={6}>
                          <FormInput
                              type="text"
                              label="名"
                              placeholder=""
                              name="firstNameZH"
                              containerClass="mb-3"
                              value={otherField?.firstNameZH ? otherField?.firstNameZH : ""}
                              onChange={(e) => {
                                  setotherField({ ...otherField, firstNameZH: e.target.value })
                              }}
                          />
                      </Col>
                    </Row>
                  </Col>
                  
                  <Col lg={12}>
                    <FormInput
                      type="email"
                      label="電郵地址"
                      placeholder=""
                      name="email"
                      containerClass="mb-3"
                      value={otherField?.email ? otherField?.email : ""}
                      onChange={(e) => {
                        setotherField({ ...otherField, email: e.target.value })
                      }}
                    />
                  </Col>
                  <Col lg={12}>
                    <FormInput
                      type="text"
                      label="手提電話"
                      placeholder=""
                      name="telMobile"
                      containerClass="mb-3"
                      value={otherField?.telMobile ? otherField?.telMobile : ""}
                      onChange={(e) => {
                        setotherField({ ...otherField, telMobile: e.target.value })
                      }}
                    />
                  </Col>

                  <Col lg={12}>
                    <FormInput
                      type="textarea"
                      label="詳細地址"
                      placeholder=""
                      name="address"
                      containerClass="mb-3"
                      value={otherField?.address ? otherField?.address : ""}
                      onChange={(e) => {
                        setotherField({ ...otherField, address: e.target.value })
                      }}
                    />
                  </Col>
                </Row>
              </Col>
            </Row>

          </form>
        </div>
      </div>

      <Row className="mt-4">
        <Col lg={12}>
          {Object.keys(errors).length > 0 && (
            <div className="error-messages">
                {Object.entries(errors).map(([key, value]) => (
                    <div key={key} className="text-danger">{value}</div>
                ))}
            </div>
          )}
          {updateSuccess && (
            <div className="success-messages">
                <div className="text-success">用戶資料已更新成功</div>
            </div>
          )}
        </Col>
        <Col lg={12}>
          <div className="d-flex flex-row align-items-center justify-content-center gap-2">
            <Button className="btn-icon" onClick={() => {
                setUpdateSuccess(false)
                navigate('/other/account/home')
              }}>
                <FeatherIcon
                  icon="arrow-left"
                  className="icon icon-lg p-2"
                />
            </Button>
            <Button variant="indigo" className="px-6" onClick={handleSave} disabled={loading}>保存</Button>
          </div>
          <div class="text-center text-gray mt-2">若希望更改其他資料，請聯絡中心職員</div>
        </Col>
      </Row>
    </>
  );
};

export default AccountInformation;
