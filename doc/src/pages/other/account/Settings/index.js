import { Badge, Button, Card, Col, Container, Row, Tab } from "react-bootstrap";
import { redirect, useNavigate } from "react-router-dom";

// component
import Navbar4 from "../../../../components/navbars/Navbar4";
import Footer from "../../../../components/footer/Footer";
import {
  getUserimgStorage,
  getMemberStorage,
  getCenterStorage,
} from "../../../../services/AuthService";
import AccountInformation from "./AccountInformation";
import Center from "./center";
import ResetPassword from "./ResetPassword";
import Notifications from "./Notifications";
import Program from "../../../Program";
import ProgramEnrollment from "./ProgramEnrollment";
import PaymentHistory from "./PaymentHistory";
import { useState, useContext } from "react";
import { useEffect } from "react";
import PageHeading from "components/PageHeading";
import default_img from "../../../../assets/images/avatars/default.png";
import MemberContext from "../../../../utils/MemberContext";
import CenterContext from "../../../../utils/CenterContext";
import moment from "moment";
import { getMemberInfo, getMemberPhoto } from "../../../../services/apiCore";
import QRCode from "react-qr-code";
import Barcode from 'react-barcode';
import FamilyMember from "./FamilyMember";
import Upgrade from "./Upgrade";
import Volunteer from "./Volunteer";

const Settings = ({ activityKey }) => {
  const [actKey, setActKey] = useState(activityKey ? activityKey : "home");
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
    centerId: 0,
  });
  const [img, setImg] = useState(getUserimgStorage());
  const { member, changeMember } = useContext(MemberContext);
  const { center, changeCenter } = useContext(CenterContext);
  const [memberList, setMemberList] = useState([]);
  const [centerList, setCenterList] = useState([]);

  const navigate = useNavigate();

  const getMemberList = async () => {
    const userResult = await getMemberInfo();
    return userResult.data;
  };

  const getCenterList = async () => {
    const members = await getMemberList();
    let cList = [];
    !!members &&
      members.map((member, index) => {
        cList.push(member.center);
      });
    return cList;
  };

  const reloadData = () => {
    const result = member;
    !!member &&
      setotherField({
        name: result.nameEN?.fullName,
        email: result.email,
        nameZH: result.nameZH?.fullName,
        phone: result.telHome,
        memberNo: result.memberNo,
        gender: result.gender == "M" ? "男性" : result.gender == "F" ? "女性": "不詳",
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
        centerId: result.center?.id
      });
  };

  useEffect(() => {
    const fetchData = async () => {
      setMemberList(await getMemberList());
      setCenterList(await getCenterList());
    };
    fetchData();
  }, [])

  useEffect(() => {
    reloadData();
    setImg(getUserimgStorage());
  }, [member, center]);

  // const actKey = activityKey ? activityKey : "account"
  useEffect(() => {
    setActKey(activityKey ? activityKey : "home");
  }, [activityKey]);

  const handleChange = async (id) => {
    const newMemberOptions = memberList.find(
      (member) => String(member.center.id) === String(id)
    );
    const newCenterOptions = centerList.find(
      (item) => String(item.id) === String(id)
    );

    !!newMemberOptions &&
      sessionStorage.setItem("member", JSON.stringify(newMemberOptions));
    !!newCenterOptions &&
      sessionStorage.setItem("center", JSON.stringify(newCenterOptions));

    if (!!newMemberOptions) {
      const userImg = await getMemberPhoto(newMemberOptions.id);
      !!userImg && sessionStorage.setItem("userImg", userImg.data);
    }
    !!newMemberOptions && changeMember(newMemberOptions);
    !!newCenterOptions && changeCenter(newCenterOptions);
  };
  

  return (
    <>
      {/* header */}
      <Navbar4 fixedWidth />

      <div id="main">
        <PageHeading title="用戶資料" icon="user" />
        
        <Container className="account-container">
          <div className="btns justify-content-center flex-row d-flex gap-3">
            <Button variant={actKey == 'account' ? 'pink' : 'indigo'} size="sm" onClick={() => {
              navigate('/other/account/account')
            }}>更新資料</Button>
            <Button variant={actKey == 'familyMember' ? 'pink' : 'indigo'} size="sm" onClick={() => {
              navigate('/other/account/familyMember')
            }}>設定同行者</Button>
            <Button variant={actKey == 'paymentHistory' ? 'pink' : 'indigo'} size="sm" onClick={() => {
              navigate('/other/account/paymentHistory')
            }}>交易記錄</Button>
            <Button variant={actKey == 'upgrade' ? 'pink' : 'indigo'} size="sm" onClick={() => {
              navigate('/other/account/upgrade')
            }}>會員續會</Button>
            { member.isVolunteer ?
              <Button variant={actKey == 'volunteer' ? 'pink' : 'indigo'} size="sm" onClick={() => {
                navigate('/other/account/volunteer')
              }}>義工技能</Button> : <></> }
          </div>

          <Row className="my-3">
            <Col className="gap-2 d-flex align-items-center justify-content-center">
              <span>選擇會員會籍：</span>
              {(centerList || []).map((ctr, index) => {
                return (
                  <Badge style={{cursor: 'pointer'}} bg={ctr.id == otherField.centerId?'primary':'disabled'} onClick={() => {
                    // ctr.id
                    handleChange(ctr.id)
                  }}>{ctr.nameZH}</Badge>
                );
              })}
            </Col>
          </Row>

          <div>
            <Tab.Container activeKey={actKey}>
              <Row>
                <Col lg={12}>
                  <Tab.Content className="p-0">
                    <Tab.Pane
                      eventKey="home"
                      transition
                      className="px-3">
                      <div className="program-form-box p-3 mt-3">
                        <div className="program-form-box-content">
                          <Row className="align-items-center">
                            <Col lg="2">
                              <img
                                src={img ? img : default_img}
                                className="img-fluid avatar-md rounded-circle shadow"
                                alt="..."
                              />
                            </Col>
                            <Col>
                              <div>{otherField.nameZH} ({otherField.age})</div>
                              <div>{otherField.gender}</div>

                            </Col>
                          </Row>
                        </div>
                      </div>

                      <div className="d-flex flex-column align-items-center m-5 gap-3">
                        <div className="fs-2 text-pink">現有積分：{otherField?.loyaltyPoint ? otherField?.loyaltyPoint : "0"}</div>
                        <div className="border p-3 rounded border-indigo"><QRCode
                            size={180}
                            value={otherField?.QRCode ? otherField?.QRCode : ""}
                          /></div>
                        <div>{otherField?.memberNo ? otherField?.memberNo : ""}</div>
                        <div><Barcode value={otherField?.QRCode ? otherField?.QRCode : ""} displayValue={false} /></div>
                      </div>
                    </Tab.Pane>
                    <Tab.Pane
                      eventKey="account"
                      transition
                      className="px-3"
                    >
                      <AccountInformation />
                    </Tab.Pane>
                    <Tab.Pane
                      eventKey="familyMember"
                      transition
                      className="px-3"
                    >
                      <FamilyMember />
                    </Tab.Pane>
                    <Tab.Pane
                      eventKey="programEnrollment"
                      transition
                      className="px-3"
                    >
                      <ProgramEnrollment />
                    </Tab.Pane>
                    <Tab.Pane
                      eventKey="paymentHistory"
                      transition
                      className="px-3"
                    >
                      <PaymentHistory />
                    </Tab.Pane>
                    <Tab.Pane
                      eventKey="password"
                      transition
                      className="px-3"
                      style={{ minHeight: "600px" }}
                    >
                      <ResetPassword />
                    </Tab.Pane>
                    <Tab.Pane
                      eventKey="upgrade"
                      transition
                      className="px-3"
                    >
                      <Upgrade />
                    </Tab.Pane>
                    { member.isVolunteer ? <Tab.Pane
                      eventKey="volunteer"
                      transition
                      className="px-3"
                    >
                      <Volunteer />
                    </Tab.Pane> : <></> }
                  </Tab.Content>
                </Col>
              </Row>
            </Tab.Container>
          </div>

        </Container>
      </div>

      {/* footer */}
      <Footer aosSetting="disable" />
    </>
  );
};

export default Settings;
