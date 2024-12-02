import { useEffect } from "react";
import Scheduler, {
  Editing,
  Scrolling,
  Resource,
} from "devextreme-react/scheduler";
import useState from "react-usestateref";
import { getProgramInfo } from "../../services/apiCore";
import ProgramAppointment from "../../components/program/ProgramAppointment";
import ProgramAppointmentTooltip from "../../components/program/ProgramAppointmentTooltip";
import Accordion from "react-bootstrap/Accordion";

const ProgramScheduler = (props) => {
  const { searchValues } = props;
  const [searchParams, setSearchParams] = useState(searchValues);
  const [programs, setPrograms] = useState();
  const currentDate = new Date();
  const views = ["day", "week", "month"];

  const refreshPrograms = async () => {
    if (searchParams) {
      const _result = await getProgramInfo({ ...searchParams, pageSize: 50 });
      const _programs = _result?.data?.items || [];

      // console.log("_modifiedPrograms", _modifiedPrograms);
      setPrograms(_programs);
    }
  };

  useEffect(() => {
    setSearchParams(searchValues);
  }, [searchValues]);

  useEffect(() => {
    refreshPrograms();
  }, [searchParams]);

  const onAppointmentFormOpening = (e) => {
    // e.preventDefault();
    e.cancel = true;
  };

  const handleClick = () => {
    setTimeout(() => refreshPrograms(), 300);
  };

  return (
    <>
      <Accordion>
        <Accordion.Item eventKey="0">
          <Accordion.Header onClick={handleClick}>活動日曆</Accordion.Header>
          <Accordion.Body>
            <Scheduler
              timeZone="Asia/Hong_Kong"
              dataSource={programs}
              views={views}
              // editing={false}
              // height="80vh"
              defaultCurrentView="month"
              defaultCurrentDate={currentDate}
              startDayHour={9}
              endDayHour={20}
              cellDuration={60}
              appointmentComponent={ProgramAppointment}
              appointmentTooltipComponent={ProgramAppointmentTooltip}
              onAppointmentFormOpening={onAppointmentFormOpening}
              // onAppointmentClick={handleClick}
            >
              <Editing allowAdding={false} />
              <Scrolling mode="virtual" />
            </Scheduler>
          </Accordion.Body>
        </Accordion.Item>
      </Accordion>
    </>
  );
};

export default ProgramScheduler;
