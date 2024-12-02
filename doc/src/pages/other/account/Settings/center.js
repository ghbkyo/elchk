import { Form } from "react-bootstrap";
import React, { useState, useContext, useEffect } from "react";
import { getMemberInfo, getMemberPhoto } from "../../../../services/apiCore";
import CenterContext from "../../../../utils/CenterContext";
import MemberContext from "../../../../utils/MemberContext";

const Center = () => {
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

  const { member, changeMember } = useContext(MemberContext);
  const { center, changeCenter } = useContext(CenterContext);
  const [memberList, setMemberList] = useState([]);
  const [centerList, setCenterList] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      setMemberList(await getMemberList());
      setCenterList(await getCenterList());
    };
    fetchData();
  }, []);

  const handleChange = async (e) => {
    const newMemberOptions = memberList.find(
      (member) => String(member.center.id) === String(e.target.value)
    );
    const newCenterOptions = centerList.find(
      (item) => String(item.id) === String(e.target.value)
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
      <Form>
        <Form.Label>
          <h4 className="mt-3 mt-lg-0">選擇中心:</h4>
        </Form.Label>
        <Form.Select
          aria-label="selectSize"
          onChange={handleChange}
          value={center ? center.id : ""}
        >
          {(centerList || []).map((ctr, index) => {
            return (
              <option key={ctr.id} value={ctr.id}>
                {ctr.nameZH}
              </option>
            );
          })}
        </Form.Select>
      </Form>
    </>
  );
};

export default Center;
