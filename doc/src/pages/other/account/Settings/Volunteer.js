import React, { useEffect, useState, useContext, useRef } from "react";
import { Col, Row, Button, Alert } from "react-bootstrap";
import { useNavigate } from "react-router-dom";
import moment from "moment";
import classNames from "classnames";
import LottieLoadingFile from "assets/json/LottieLoadingFile.json";
import MemberContext from "../../../../utils/MemberContext";
import CenterContext from "../../../../utils/CenterContext";
import FeatherIcon from "feather-icons-react";
import {
  getMemberVolunteerSkill,
  getSkillDropdown,
  updateMemberVolunteerSkill,
} from "../../../../services/apiCore";
import { FormInput } from "components/form";

const Volunteer = () => {
  const navigate = useNavigate();
  
  const [disableSubmit, setDisableSubmit] = useState(false);
  const { member } = useContext(MemberContext);
  const { center } = useContext(CenterContext);
  const [ skillList, setSkillList ] = useState();
  const [ memberSkill, setMemberSkill ] = useState()
  const [ changeSkill, setChangeSkill ] = useState()
  const [ updateSuccess, setUpdateSuccess ] = useState(false)
  const [errors, setErrors] = useState({})

  const skillKeys = [
    { key: 'ChineseDialect', name: "中國方言"}, 
    { key: 'VolunteerExperienceHouseKeeping', name: '家政'}, 
    { key: 'VolunteerExperienceMedical', name: '醫療護理'}, 
    { key: 'VolunteerExperienceTechnical', name: '專業技術/專業資格'},
    { key: 'Motion', name: '運動'}, 
    { key: 'OfficaAffairs', name: '辦公室事務'}, 
    { key: 'ArtDesign', name: '美術設計'}, 
    { key: 'MusicType', name: '舞蹈'}, 
    { key: 'EducationType', name: '音樂'}
  ]

  async function fetchData() {
    if (member) {
      getSkillDropdown({
        ComCenterId: center.id
      }).then((res) => {
        if (res.status == 200) {
          setSkillList(res.data)
        }
      });
      const params = { MemberInfoId: member?.id };
      getMemberVolunteerSkill(params).then((res) => {
        if (res.status == 200) {
          setMemberSkill(res.data)
        }
      });
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
  }, [center]);

  const handleSubmit = () => {
    if (disableSubmit) return;
    setDisableSubmit(true)
    setErrors([])
    setUpdateSuccess(false)
    if (changeSkill) {
      const data = {
        memberInfoId: member.id,
        comCodeCategoriesToUpdate: [],
        memberVolunteerComCodes: []
      }
      for (let key of Object.keys(changeSkill)) {
        data['comCodeCategoriesToUpdate'].push(key)
        for (let item of changeSkill[key]) {
          data['memberVolunteerComCodes'].push({
            comCodeId: item['value'],
            remark: ''
          })
        }
      }
      updateMemberVolunteerSkill(member.id, data).then((res) => {
        setUpdateSuccess(true)
      }).catch((err) => {
        setErrors(err)
      })
    } else {

    }
    setDisableSubmit(false);
  }

  return (
    <>
      <div className="program-form-box p-3 mt-3">
        <div className="program-form-box-content">
          { !skillList || !memberSkill ? <></> :
          <Row className="align-items-center">
            { skillKeys.map((_key, _index) => {
              return skillList[_key.key] ? <Col lg={12}>
                <FormInput
                  type="select-multi"
                  label={_key.name}
                  placeholder=""
                  name={_key.key}
                  containerClass="mb-3"
                  rows={ skillList[_key.key].map((item) => {
                    return { value: item.id, label: item.data1ZH}
                  }) }
                  defaultValue={ memberSkill[_key.key].map((item) => {
                    return { value: item.comCode.id, label: item.comCode.data1ZH}
                  }) }
                  onChange={(e) => {
                    setChangeSkill((_rows) => {
                      return {
                        ..._rows,
                        ChineseDialect: e
                      }
                    })
                  }}
                />
              </Col> : <></>
            })}
          </Row> }
        </div>
      </div>

      <Row className="mt-4">
        <Col lg={12}>
          {Object.keys(errors).length > 0 && (
            <Alert
              variant='danger'
            >
              <div>
                {Object.entries(errors).map(([key, value]) => (
                    <div key={key}>{value}</div>
                ))}
              </div>
            </Alert>
          )}
          {updateSuccess && (
            <Alert
              variant='success'
            >
              <div>
                義工技能更新成功
              </div>
            </Alert>
          )}
        </Col>
        <Col lg={12}>
          <div className="d-flex flex-row align-items-center justify-content-center gap-2">
            <Button className="btn-icon" onClick={() => {
                setErrors([])
                setUpdateSuccess(false);
                navigate('/other/account/home')
              }}>
                <FeatherIcon
                  icon="arrow-left"
                  className="icon icon-lg p-2"
                />
            </Button>
            <Button variant="indigo" className="px-6" disabled={disableSubmit} onClick={() => {
              handleSubmit()
            }}>保存</Button>
          </div>
        </Col>
      </Row>
    </>
  );
};

export default Volunteer;
