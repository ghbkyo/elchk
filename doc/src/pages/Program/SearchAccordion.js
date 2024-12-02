import { useEffect, useState } from "react";
import { Accordion, Card, Col, Row, Form, Button, Container, InputGroup, Dropdown } from "react-bootstrap";
import Select from "react-select";
import CreatableSelect from "react-select/creatable";
import { DateRangePicker } from "rsuite";
import { Slider } from "primereact/slider";
import FeatherIcon from "feather-icons-react";
import { getProgramCategory, getComCenter } from "../../services/apiCore";

import {
  timeslotOptions as d1,
  dayOfWeekOptions as d2,
  targetOptions as d3,
  feeOptions as d4,
} from "./data";
import { Input } from "react-select/animated";

const SearchAccordion = ({ handleSearch, searchValues, categories }) => {
  const initValues = {
    startDateFrom: "",
    startDateTo: "",
    endDateFrom: "",
    endDateTo: "",
    dayPeriods: [],
    dayPeriods_fieldValue: [],
    weekDays: [],
    weekDays_fieldValue: [],
    categoryIds: [],
    categoryIds_fieldValue: [],
    programObject: "",
    programObject_fieldValue: null,
    programMinFee: null,
    programMaxFee: null,
    keyword: "",
    pageSize: 6,
    centerId: 0,
    isTop: null
  };

  // values store the search criteria that pass to handleSearch in index
  const [values, setValues] = useState(initValues);
  const [timeslotOptions, setTimeslotOptions] = useState(d1);
  const [dayOfWeekOptions, setDayOfWeekOptions] = useState(d2);
  const [centerOptions, setCenterOptions] = useState([]);
  const [categoryOptions, setCategoryOptions] = useState([]);
  const [targetOptions, setTargetOptions] = useState(d3);
  const [feeOptions, setFeeOptions] = useState(d4);
  const [feeValue, setFeeValue] = useState(0);
  const [feeDisplayValues, setFeeDisplayValues] = useState("");

  useEffect(() => {

    const fetchProgramCategory = async () => {
      const category_result = await getProgramCategory();
      setCategoryOptions(category_result?.data?.MobileMenuCategory);
    };
    fetchProgramCategory();

    const fetchComCenter = async () => {
      const center_result = await getComCenter();
      setCenterOptions(center_result?.data);
    };
    fetchComCenter();

  }, []);

  useEffect(() => {
    setValues({ ...initValues, ...searchValues });
  }, [searchValues]);

  useEffect(() => {
    // console.log("values", values);
    handleSearch(values);
  }, [values]);

  const handleChange = (event, idField) => {
    // console.log("handleChange.event", event, event.value);
    if (event && event.target) {
      setValues({ ...values, [event.target.name]: event.target.value });
    } else {
      setValues({ ...values, [idField]: event });
    }
  };

  const handleChange1 = (event, idField) => {
    console.log("handleChange1.event", event);

    if (event && event.target) {
      setValues({ ...values, [event.target.name]: event.target.value });
    } else {
      setValues({
        ...values,
        [idField]: Array.isArray(event)
          ? event && event.map((item) => item.value)
          : event?.value,
        [`${idField}_fieldValue`]: Array.isArray(event) ? event : event,
      });
    }
  };

  const handleMultiSelectChange = (e, idField) => {
    console.log("handleMultiSelectChange", e);
    if (e) {
      if (e.length > 0) {
        const arr = [];
        e.map((x) => {
          arr.push(x.value);
        });
        setValues({ ...values, [idField]: arr });
      } else {
        setValues({ ...values, [idField]: [] });
      }
    } else {
      setValues({ ...values, [idField]: [] });
    }
  };

  function isNumeric(n) {
    if (!(!isNaN(parseFloat(n)) || !isFinite(n))) {
      throw "Value is not a number";
    }
    return n;
  }

  const formatDate = (dateList) => {
    // if (dateList && dateList.length == 2) {
    //     if ((new Date(dateList[0].getFullYear(), dateList[0].getMonth(), dateList[0].getDate())).getTime() == (new Date(dateList[1].getFullYear(), dateList[1].getMonth(), dateList[1].getDate())).getTime()) {
    //         console.log(1)
    //         dateList[0] = new Date(dateList[0].getFullYear(), dateList[0].getMonth(), dateList[0].getDate(), 8, 0)
    //         dateList[1] = new Date(dateList[1].getFullYear(), dateList[1].getMonth(), dateList[1].getDate(), 8, 0)
    //     } else {
    //         console.log(2)
    //         dateList[0] = new Date(dateList[0].getFullYear(), dateList[0].getMonth(), dateList[0].getDate())
    //         dateList[1] = new Date(dateList[1].getFullYear(), dateList[1].getMonth(), dateList[1].getDate())
    //     }
    // }

    const newDateList = [];
    if (dateList) {
      dateList.map((item, index) => {
        //item[index] = new Date(item.getFullYear(),item.getMonth(),item.getDate())
        // return (new Date(item.getFullYear(),item.getMonth(),item.getDate()))

        newDateList.push(
          new Date(item.getFullYear(), item.getMonth(), item.getDate())
          // ).toISOString()
        );
      });
    }
    return newDateList;
  };

  const handleDateChange = (dateList, nameList) => {
    dateList = formatDate(dateList);
    if (dateList && nameList) {
      // setValues({...values, [nameList[0]]: dateList[0].toISOString().slice(0,10), [nameList[1]]: dateList[1].toISOString().slice(0,10) })
      setValues({
        ...values,
        [nameList[0]]: dateList[0],
        [nameList[1]]: dateList[1],
      });
    } else {
      setValues({ ...values, [nameList[0]]: "", [nameList[1]]: "" });
    }
  };

  const handleReset = () => {
    setFeeDisplayValues("");
    setValues({ ...searchValues, ...initValues });
  };

  //   const getSelectedTimeslot = (id) => {
  //     const selected = timeslotOptions?.find((e) => e.value == id);
  //     return selected ? selected : null;
  //   };
  //   const getSelectedDayOfWeek = (id) => {
  //     const selected = dayOfWeekOptions?.find((e) => e.value == id);
  //     return selected ? selected : null;
  //   };
  //   const getSelectedCategory = (id) => {
  //     const selected = categoryOptions?.find((e) => e.value == id);
  //     return selected ? selected : null;
  //   };

  //   console.log("timeslotOptions", timeslotOptions);
  //   console.log("categoryOptions", categoryOptions);
  //   console.log("values", values);

  return (
    <Container className="py-4">
      <Row id="program-filters" className="align-items-center">
        <Col className="keyword">
          <InputGroup className="py-1">
            <InputGroup.Text id="basic-addon1">
              <FeatherIcon icon="search" size="20" />
            </InputGroup.Text>
            <Form.Control
              placeholder="尋找活動"
              aria-label="尋找活動"
              aria-describedby="basic-addon1"
              name="keyword"
              type="search"
              value={values.keyword}
              onChange={(e) => {
                handleChange1(e, "keyword");
              }}
            />
          </InputGroup>
        </Col>
        <Col>
          <Dropdown>
            <Dropdown.Toggle>
              活動中心
            </Dropdown.Toggle>
            <Dropdown.Menu>
              {
                centerOptions.map((item, index) => {
                  return <Dropdown.Item key={index} active={values.centerId == item.id} onClick={() => {
                    handleChange1({value: item.id}, "centerId");
                  }}>{item.nameZH}</Dropdown.Item>
                })
              }
            </Dropdown.Menu>
          </Dropdown>
        </Col>
        <Col>
          <Dropdown>
            <Dropdown.Toggle>
              活動類別
            </Dropdown.Toggle>
            <Dropdown.Menu>
              {
                categoryOptions.map((item, index) => {
                  return <Dropdown.Item key={index} active={values.categoryIds.includes(item.id)} onClick={() => {
                    handleChange1([{value: item.id}], "categoryIds");
                  }}>{item.data1ZH}</Dropdown.Item>
                })
              }
            </Dropdown.Menu>
          </Dropdown>
        </Col>
        <Col>
          <Dropdown>
            <Dropdown.Toggle>
              費用
            </Dropdown.Toggle>
            <Dropdown.Menu>
              {
                feeOptions.map((item, index) => {
                  return <Dropdown.Item key={index} active={feeValue == item.value} onClick={() => {
                    setValues(prevValues => ({
                      ...prevValues,
                      programMinFee: item.limit[0],
                      programMaxFee: item.limit[1]
                    }));
                    setFeeValue(item.value)
                  }}>{item.label}</Dropdown.Item>
                })
              }
            </Dropdown.Menu>
          </Dropdown>
        </Col>
        <Col>
          <Dropdown>
            <Dropdown.Toggle>
              參加資格
            </Dropdown.Toggle>
            <Dropdown.Menu>
              {
                targetOptions.map((item, index) => {
                  return <Dropdown.Item key={index} active={values.programObject == item.value} onClick={() => {
                    handleChange1(item, "programObject");
                  }}>{item.label}</Dropdown.Item>
                })
              }
            </Dropdown.Menu>
          </Dropdown>
        </Col>
      </Row>
      {/* <Card id="searchBoxes">
        <Card.Body>
          <Accordion id="searchBox">
            <Accordion.Item eventKey="0">
              <Accordion.Header>
                <div className="h4">進階搜索</div>
              </Accordion.Header>
              <Accordion.Body>
                <Form>
                  <Row className="">
                    <Col lg={3} className="pb-3">
                      <Form.Group>
                        <Form.Label>開始日期</Form.Label>
                        <DateRangePicker
                          size="lg"
                          block
                          // disabledDate={date => dateFns.isAfter(date, new Date())}
                          onChange={(e) => {
                            handleDateChange(e, ["startDateFrom", "startDateTo"]);
                          }}
                          placeholder="年-月-日~年-月-日"
                          value={
                            values?.startDateFrom
                              ? [
                                  new Date(values?.startDateFrom),
                                  new Date(values?.startDateTo),
                                ]
                              : []
                          }
                        />
                      </Form.Group>
                    </Col>
                    <Col lg={3} className="pb-3">
                      <Form.Group>
                        <Form.Label>結束日期</Form.Label>
                        <DateRangePicker
                          size="lg"
                          block
                          onChange={(e) => {
                            handleDateChange(e, ["endDateFrom", "endDateTo"]);
                          }}
                          placeholder="年-月-日~年-月-日"
                          value={
                            values?.endDateFrom
                              ? [
                                  new Date(values?.endDateFrom),
                                  new Date(values?.endDateTo),
                                ]
                              : []
                          }
                        />
                      </Form.Group>
                    </Col>
                    <Col lg={3}>
                      <Form.Group controlId="dayPeriods">
                        <Form.Label>時段</Form.Label>
                        <Select
                          name="dayPeriods"
                          className="z-index-3"
                          isClearable={true}
                          closeMenuOnSelect={false}
                          isMulti
                          placeholder="時段"
                          // selectOption={d1}
                          value={values.dayPeriods_fieldValue}
                          onChange={(e) => {
                            handleChange1(e, "dayPeriods");
                          }}
                          options={timeslotOptions}
                        />
                      </Form.Group>
                    </Col>
                    <Col lg={3}>
                      <Form.Group controlId="weekDays">
                        <Form.Label>星期</Form.Label>
                        <Select
                          name="weekDays"
                          isClearable={true}
                          closeMenuOnSelect={false}
                          isMulti
                          placeholder="星期"
                          value={values.weekDays_fieldValue}
                          onChange={(e) => {
                            handleChange1(e, "weekDays");
                          }}
                          options={dayOfWeekOptions}
                        />
                      </Form.Group>
                    </Col>

                    <Col lg={3} className="pb-3">
                      <Form.Group controlId="categoryIds">
                        <Form.Label>內容分類</Form.Label>
                        <Select
                          name="categoryIds"
                          isClearable={true}
                          closeMenuOnSelect={false}
                          isMulti
                          placeholder="內容分類"
                          value={values.categoryIds_fieldValue}
                          onChange={(e) => {
                            handleChange1(e, "categoryIds");
                          }}
                          options={categoryOptions}
                        />
                      </Form.Group>
                    </Col>
                    <Col lg={3}>
                      <Form.Group controlId="programObject">
                        <Form.Label>對象</Form.Label>
                        <CreatableSelect
                          name="programObject"
                          isClearable={true}
                          closeMenuOnSelect={true}
                          // isMulti
                          placeholder="對象"
                          value={values.programObject_fieldValue}
                          onChange={(e) => {
                            handleChange1(e, "programObject");
                          }}
                          options={targetOptions}
                        />
                      </Form.Group>
                    </Col>
                    <Col lg={3}>
                      <Form.Group controlId="feeId">
                        <Form.Label>費用</Form.Label>
                        <Form.Control
                          type="search"
                          value={feeDisplayValues}
                          onChange={(e) => handleFeeRangeChange(e)}
                        />
                        <Slider
                          value={feeValues}
                          onChange={(e) => handleFeeRangeChange(e)}
                          min={0}
                          max={500}
                          step={20}
                          range
                        />
                      </Form.Group>
                    </Col>
                    <Col lg={3}>
                      <Form.Group controlId="keyword">
                        <Form.Label>關鍵字</Form.Label>
                        <Form.Control
                          name="keyword"
                          type="search"
                          value={values.keyword}
                          onChange={(e) => {
                            handleChange1(e, "keyword");
                          }}
                        />
                        <Form.Text>
                          *關鍵字涵蓋活動名稱、活動內容、負責職員
                        </Form.Text>
                      </Form.Group>
                    </Col>
                  </Row>

                  <div className="d-flex justify-content-between">
                    <Button
                      variant="primary"
                      onClick={() => {
                        handleSearch(values);
                      }}
                    >
                      提交
                    </Button>
                    <Button
                      variant="white"
                      onClick={() => {
                        handleReset();
                      }}
                    >
                      重置
                    </Button>
                  </div>
                </Form>
              </Accordion.Body>
            </Accordion.Item>
          </Accordion>
        </Card.Body>
      </Card> */}
    </Container>
  );
};

export default SearchAccordion;
