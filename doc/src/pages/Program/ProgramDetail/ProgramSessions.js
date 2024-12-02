import { useState, useEffect } from "react";
import { Col, Container, Row, Form, Badge, Button } from "react-bootstrap";
import classNames from "classnames";
import moment from "moment";
import { sortBy } from "lodash";
import Accordion from "@mui/material/Accordion";
import AccordionDetails from "@mui/material/AccordionDetails";
import AccordionSummary from "@mui/material/AccordionSummary";
import Typography from "@mui/material/Typography";
import FeatherIcon from "feather-icons-react";
import Calendar from "devextreme-react/calendar";

const ProgramSessions = ({
  sessions,
  handleSelectedSession,
  selectedSession,
}) => {
  const [tableData, setTableData] = useState([]);
  const [expanded, setExpanded] = useState(false);
  const [session, setSession] = useState(false);
  const [selectedCalendarDate, setSelectedCalendarDate] = useState(new Date());
  const [selectedDateSessions, setSelectedDateSessions] = useState();
  const [calendarState, setCalendarState] = useState({
    minDateValue: new Date("2018-01-01"),
    maxDateValue: new Date("2050-12-31"),
    disabledDates: null,
    firstDay: 0,
    currentValue: new Date(),
    cellTemplate: null,
    disabled: false,
    zoomLevel: "month",
  });

  useEffect(() => {
    const newSessions = sortBy(sessions, "startDate").reverse();
    const data = (newSessions || []).map((session, index) => {
      return {
        ...session,
        startDate: moment(session?.startDate).format(
          process.env.REACT_APP_DATETIME_FORMAT
        ),
        endDate: moment(session?.endDate).format(
          process.env.REACT_APP_DATETIME_FORMAT
        ),
      };
    });
    setTableData(data);
    updateSelectedDateSessions(selectedCalendarDate);
  }, [sessions]);

  const CustomCell = (cell) => {
    return (
      <div className={getCellCssClass(cell.date, cell.view)}>{cell.text}</div>
    );
  };

  const getCellCssClass = (date1, view) => {
    let cssClass = "";
    for (let i = 0; i < sessions?.length; i++) {
      if (
        view === "month" &&
        compareDate(new Date(sessions[i].startDate), date1)
      ) {
        if (
          sessions[i].maximunNumberOfPaticipant > sessions[i].numberOfPaticipant
        ) {
          cssClass = "calendar-program-session-available";
          break;
        } else {
          cssClass = "calendar-program-session-full";
        }
      }
    }
    return cssClass;
  };

  const getLocaleTime = (date1) => {
    return new Date(date1).toLocaleTimeString([], {
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  const compareDate = (date1, date2) => {
    if (
      date1.getDate() === date2.getDate() &&
      date1.getMonth() === date2.getMonth() &&
      date1.getYear() === date2.getYear()
    ) {
      return true;
    }
    return false;
  };

  const updateSelectedDateSessions = (selectedDate) => {
    const sessionsForOneDay = (sessions || []).filter((session) => {
      return compareDate(new Date(session?.startDate), selectedDate);
    });
    setSelectedDateSessions(sessionsForOneDay);
  };

  const handleValueChanged = (e) => {
    // clear selected session
    handleSelectedSession(0);
    setSelectedCalendarDate(e.value);
    updateSelectedDateSessions(e.value);
  };

  const handleChange = (panel) => (event, isExpanded) => {
    setExpanded(isExpanded ? panel : false);
  };

  return (
    <>
      {/* <section className="position-relative p-3 bg-gradient2">
      <Container> */}
      {/* 
                    list program sessions here, in program info get api, get the key programSessions 
                    can refer to the program list in the program index page
                    show column: 場地, 開始日期/時間, 結束日期/時間, 場次最大人數, 已報名人數
                */}
      <h3 className="py-3">活動場次</h3>

      <div className="widget-container py-3">
        <Row>
          <Col xs={12} lg={4}>
            <Calendar
              id="calendar-container"
              value={calendarState.currentValue}
              min={calendarState.minDateValue}
              max={calendarState.maxDateValue}
              disabledDates={calendarState.disabledDates}
              firstDayOfWeek={calendarState.firstDay}
              disabled={calendarState.disabled}
              // zoomLevel={calendarState.zoomLevel}
              // cellRender={calendarState.cellTemplate}
              showTodayButton={true}
              cellRender={CustomCell}
              onValueChanged={handleValueChanged}
            ></Calendar>
          </Col>
          <Col xs={12} lg={8}>
            <h4 className="pb-3">
              已選擇日期:{" "}
              {moment(selectedCalendarDate).format(
                process.env.REACT_APP_DATE_FORMAT
              )}
            </h4>

            {(selectedDateSessions || []).length === 0 && (
              <div className="py-3 font-size-large">選擇日期沒有任何活動</div>
            )}
            <Form className="py-3 font-size-large">
              {(selectedDateSessions || []).map((session, index) => {
                return (
                  <Row key={index} className="py-1 center">
                    <Col xs={12} lg={4}>
                      <Form.Check type="radio">
                        <Form.Check.Input
                          type="radio"
                          id={session.id}
                          name="sessions"
                          value={session.id}
                          defaultChecked={false}
                          checked={
                            String(session.id) === String(selectedSession?.id)
                          }
                          // onClick={(e) => {
                          //   console.log("onClick", e);
                          //   handleSelectedSession(e);
                          // }}
                          onChange={(e) => {
                            // console.log("onChange", e);
                            handleSelectedSession(e.target.value);
                          }}
                        />
                        <Form.Check.Label
                          className="font-size-large cursor-pointer"
                          htmlFor={session.id}
                        >{`${getLocaleTime(
                          session.startDate
                        )} - ${getLocaleTime(
                          session.endDate
                        )} `}</Form.Check.Label>
                      </Form.Check>
                      {/* <Form.Check
                          type="radio"
                          id={session.id}
                          name="sessionGroup"
                          className="font-size-large"
                          label={`${getLocaleTime(session.startDate)} - ${getLocaleTime(
                            session.endDate
                          )} `}
                          {...(session?.maximunNumberOfPaticipant <=
                            session?.numberOfPaticipant && { disabled: true })}
                        /> */}
                    </Col>
                    <Col xs={12} lg={5}>
                      <div className="ps-4">
                        <Badge
                          bg=""
                          className={classNames("badge-soft-orange", "p-2")}
                        >
                          {session?.venue.length > 18
                            ? session?.venue.substring(0, 18) + "..."
                            : session?.venue}
                        </Badge>
                      </div>
                    </Col>
                    {session?.maximunNumberOfPaticipant >
                    session?.numberOfPaticipant ? (
                      <Col xs={12} lg={3}>
                        <div className="ps-4">
                          尚餘{" "}
                          <Badge bg="success" className="p-2">
                            {session?.maximunNumberOfPaticipant -
                              session?.numberOfPaticipant}
                          </Badge>{" "}
                          個位{" "}
                          <span className="ps-3 d-none">
                            <Button className="font-size-small">報名</Button>
                          </span>
                        </div>
                      </Col>
                    ) : (
                      <Col xs={12} lg={3}>
                        <div className="ps-4">
                          <Badge bg="danger" className="p-2">
                            額滿
                          </Badge>
                        </div>
                      </Col>
                    )}
                  </Row>
                );
              })}
            </Form>
          </Col>
        </Row>
      </div>

      {(tableData || []).map((item, index) => {
        return (
          <Row className="mb-2" key={index}>
            <Col xs={12}>
              <Accordion
                expanded={expanded === index}
                onChange={handleChange(index)}
              >
                <AccordionSummary
                  expandIcon={
                    <FeatherIcon
                      icon="chevron-down"
                      className="ms-1 icon-xxs"
                    />
                  }
                >
                  <Typography
                    component="div"
                    className="px-1"
                    sx={{ width: "52%" }}
                  >
                    <h6>
                      <FeatherIcon icon="calendar" className="icon-xxs" />{" "}
                      活動日期/時間
                    </h6>
                    <h6>
                      {item.startDate} - {item.endDate}
                    </h6>
                  </Typography>
                  <Typography component="div" className="px-1">
                    <h6>
                      <FeatherIcon icon="map" className="icon-xxs" /> 場地
                    </h6>
                    <h6>{item.venue}</h6>
                  </Typography>
                </AccordionSummary>
                <AccordionDetails>
                  <Row>
                    <Col xs={12} md={6} className="pb-2">
                      <h6>
                        <FeatherIcon icon="users" className="icon-xxs" />{" "}
                        場次最大人數
                      </h6>
                      <h6>{item.maximunNumberOfPaticipant}</h6>
                    </Col>
                    <Col xs={12} md={6}>
                      <h6>
                        <FeatherIcon icon="user" className="icon-xxs" />{" "}
                        已報名人數
                      </h6>
                      <h6>{item.numberOfPaticipant}</h6>
                    </Col>
                  </Row>
                </AccordionDetails>
              </Accordion>
            </Col>
          </Row>
        );
      })}
      {/* </Container>
    </section> */}
    </>
  );
};

export default ProgramSessions;
