import React from "react";
import moment from "moment";

const ProgramAppointment = (model) => {
  const { targetedAppointmentData } = model.data;

  return (
    <div className="showtime-preview">
      <div>{targetedAppointmentData.name}</div>
      <div>
        {moment(targetedAppointmentData.startDate).format(
          process.env.REACT_APP_TIME_FORMAT
        )}
        -
        {moment(targetedAppointmentData.endDate).format(
          process.env.REACT_APP_TIME_FORMAT
        )}
      </div>
    </div>
  );
};

export default ProgramAppointment;
