import { Badge, Button, Col, Container, Row } from "react-bootstrap";
import { useContext, useEffect, useReducer } from "react";
import { orderBy } from "lodash";
import useState from "react-usestateref";
import { getProgramInfo } from "../../services/apiCore";
import ProgramSlider from "./ProgramSlider";
import CenterContext from "../../utils/CenterContext";
import ProgramInfinite from "./ProgramInfinite";
import { NavLink } from "react-router-dom";

const PublicProgram = ({ showTag, startDateFrom }) => {
  const [programs, setPrograms] = useState();
  const [programsToDisplay, setProgramsToDisplay] = useState();
  const [selectedTag, setSelectedTag] = useState({ categoryId: false });
  const [categories, setCategories] = useState();
  // const { center } = useContext(CenterContext);
  const pageSize = 100;

  const [windowSize, setWindowSize] = useState(window.innerWidth);

  const handleWindowResize = (event) => {
    setWindowSize(window.innerWidth);
  };

  useEffect(() => {
    window.addEventListener("resize", handleWindowResize);
    return () => {
      window.removeEventListener("resize", handleWindowResize);
    };
  }, [handleWindowResize]);

  useEffect(() => {
    refreshPrograms();
  }, []);

  useEffect(() => {
    let _ = programs;
    if (!!selectedTag["categoryId"]) {
      _ = frontEndFilterProgramByCategoryId(_, selectedTag["categoryId"]);
    }
    setProgramsToDisplay(_);
  }, [selectedTag]);

  const refreshPrograms = async () => {
    const param = {
      // centerId: center?.id,
      pageNumber: 1,
      pageSize: pageSize,
      // StartDateFrom: new Date(),
      isShow: true,
      orderBy: "startDate",
      isOrderByAsc: false,
      isNotProgress: true
    };
    console.log(startDateFrom)
    if (startDateFrom) {
      param['StartDateFrom'] = startDateFrom
    }
    const result = await getProgramInfo(param);
    const _programs = result?.data?.items || [];
    // console.log("refreshProgram", result, _programs);
    setPrograms(_programs);
    setProgramsToDisplay(_programs);

    const _cat = getCategoryFromProgram(_programs);
    !categories && setCategories(_cat);
  };

  const getCategoryFromProgram = (_programs) => {
    let _temp_cat_list = [];
    if (!!_programs) {
      // add count to the category object
      for (let i = 0; i < _programs.length; i++) {
        if (_programs[i]?.programOnlineEnrollmentSetting?.categoryId) {
          if (
            _temp_cat_list.length === 0 ||
            !_temp_cat_list.find(
              (_cat) =>
                _cat.id ===
                _programs[i].programOnlineEnrollmentSetting.categoryId
            )
          ) {
            _temp_cat_list.push({
              ..._programs[i].programOnlineEnrollmentSetting.category,
              count: 1,
            });
          } else {
            _temp_cat_list.map((_cat) => {
              if (
                _cat.id ===
                _programs[i].programOnlineEnrollmentSetting.categoryId
              ) {
                return {
                  ..._programs[i].programOnlineEnrollmentSetting.category,
                  count: ++_cat.count,
                };
              }
            });
          }
        }
      }
    }
    _temp_cat_list = orderBy(_temp_cat_list, "count", "desc");
    return _temp_cat_list;
  };

  // const getCategoryCountFromProgram = (_programs) => {
  //   let _categoryCount = {};
  //   for (let i = 0; i < _programs.length; i++) {
  //     let _count =
  //       _categoryCount[
  //         _programs[i].programOnlineEnrollmentSetting.category.id
  //       ] || 0;
  //     _count++;
  //     _categoryCount = {
  //       ..._categoryCount,
  //       [_programs[i].programOnlineEnrollmentSetting.category.id]: _count,
  //     };
  //   }
  //   return _categoryCount;
  // };

  const handleTagClick = (e, tagType, tagId) => {
    if (selectedTag[tagType] === tagId) {
      setSelectedTag({ ...selectedTag, [tagType]: false });
    } else {
      setSelectedTag({ ...selectedTag, [tagType]: tagId });
    }
  };

  const frontEndFilterProgramByCategoryId = (programsInput, tagId) => {
    return programsInput?.filter((program) => {
      return program?.programOnlineEnrollmentSetting?.categoryId === tagId;
    });
  };

  return (
    <>
      <Container id="programContainer">
        <Row className="justify-content-lg-between">
          {showTag && (
            <Col lg={12}>
              <div className="d-flex align-items-center mb-3">
                <h5 className="me-2 fw-medium">標籤:</h5>
                <div className="d-inline-block">
                  {(categories || [])?.map((category, index) => {
                    return (
                      <Button
                        variant={
                          selectedTag.categoryId == category.id
                            ? "info"
                            : "outline-info"
                        }
                        key={index}
                        className="mb-1 me-1"
                        onClick={(e) =>
                          handleTagClick(e, "categoryId", category.id)
                        }
                      >
                        {category.data1ZH}{" "}
                        <Badge pill bg="info">
                          {category.count}
                        </Badge>
                      </Button>
                    );
                  })}
                </div>
              </div>
            </Col>
          )}

          {/* <Col lg={12} className="center">
            <h5 className="pb-3">
              * 要參加以下活動必須先成為該中心會員才能報名{" "}
              <NavLink to="/user-guide">用戶指南</NavLink> *
            </h5>
          </Col> */}

          <Col lg={12}>
            <ProgramInfinite programs={programsToDisplay}></ProgramInfinite>
          </Col>
        </Row>
      </Container>
    </>
  );
};

export default PublicProgram;
