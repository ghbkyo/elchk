import React, { useEffect, useState, useContext, useRef } from "react";
import { Col, Row, Button } from "react-bootstrap";
import { useNavigate } from "react-router-dom";
import moment from "moment";
import classNames from "classnames";
import LottieLoadingFile from "assets/json/LottieLoadingFile.json";
import MemberContext from "../../../../utils/MemberContext";
import CenterContext from "../../../../utils/CenterContext";
import FeatherIcon from "feather-icons-react";
import {
  getMemberCompanions,
  postCreateMemberCompanion,
  postDelMemberCompanion
} from "../../../../services/apiCore";
import ProgramEnrollCompanionInput from "../../../../components/form/ProgramEnrollCompanionInput";

const FamilyMember = () => {
  const navigate = useNavigate();
  
  const [disableSubmit, setDisableSubmit] = useState(false);
  const { member } = useContext(MemberContext);
  const { center } = useContext(CenterContext);
  const [companionOptions, setCompanionOptions] = useState();
  const [memberFamilyMember, setmemberFamilyMember] = useState();
  const [
    programEnrollCompanionInput,
    setProgramEnrollCompanionInput,
  ] = useState([]);
  const programEnrollCompanionInputRef = useRef([]);
  const [rowIndex, setrowIndex] = useState(0);
  const initValues = {
    nonMemberCompanions: [],
  };
  const [values, setValues] = useState(initValues);

  async function fetchData() {
    if (member) {
      const params = { memberInfoId: member?.id };
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

  const handleAddCompanion = () => {
    const newInput = (
      <ProgramEnrollCompanionInput
        key={rowIndex}
        propsKey={rowIndex}
        handleDeleteCompanion={handleDeleteCompanion}
        textChange={handleChange}
        initialName=""
        initialTelMobile=""
        firstText="會員姓名"
        secondText="電話號碼"
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

  const handleDelete = async (id) => {
    await postDelMemberCompanion({
      memberCompanionId: id
    })
    fetchData();
  }

  const handleSubmit = () => {
    setDisableSubmit(true);
    const maxNumber = values.nonMemberCompanions.length
    values.nonMemberCompanions.map(async (item, index) => {
      await postCreateMemberCompanion({
        memberInfoId: member?.id,
        name: item.name,
        telMobile: item.telMobile,
        gender: 'F'
      })
      handleDeleteCompanion(index);
      if (maxNumber == index + 1) {
        fetchData()
      }
    })
    setDisableSubmit(false);
  }

  return (
    <>
      <div className="program-form-box p-3 mt-3">
        <div className="program-form-box-content">
          <h4 className="mt-2">現有同行者</h4>
          <div className="program-form-tags mt-3 gap-3">
            {(companionOptions || []).map((item, index) => (
              <div key={index} className={classNames("item", 'position-relative')} 
                onClick={(e) => {}}>
                <span>{item.label}</span>
                <Button variant="danger" className="btn-icon d-inline-flex btn-sm position-absolute end-0 me-3" onClick={() => {
                  handleDelete(item.value)
                }}>
                  <FeatherIcon icon="minus" className="icon icon-xs" />
                </Button>
              </div>
            ))}
          </div>
          <h4 className="mt-6">新增同行者</h4>
          <div className="mt-1">
            <Button
              variant="success"
              className="me-2 mb-2 mb-sm-0 btn-icon d-inline-flex"
              onClick={handleAddCompanion}
            >
              <FeatherIcon icon="plus" className="icon icon-sm" />
            </Button>
            <div>{programEnrollCompanionInput.map((input, index) => {
              return React.cloneElement(input, {
                initialName: values.nonMemberCompanions[index]?.name,
                initialTelMobile: values.nonMemberCompanions[index]?.telMobile,
              })
            })}</div>
          </div>
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
            <Button variant="indigo" className="px-6" disabled={disableSubmit} onClick={() => {
              handleSubmit()
            }}>保存</Button>
          </div>
        </Col>
      </Row>
    </>
  );
};

export default FamilyMember;
