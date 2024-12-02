import { Carousel } from "primereact/carousel";
import { useContext, useEffect, useReducer } from "react";
import ProgramPost from "./ProgramPost";
import { getProgramInfo } from "../../services/apiCore";
import useState from "react-usestateref";
import CenterContext from "../../utils/CenterContext";

const ProgramSlider = (props) => {
  const [programs, setPrograms] = useState([]);
  const [showControls, setShowControls] = useState(true)
  const [isMobile, setIsMobile] = useState(false);
  const [displayedPrograms, setDisplayedPrograms] = useState(programs);
  // const { center } = useContext(CenterContext);

  useEffect(() => {
    const handleResize = () => {
      const mobile = window.innerWidth <= 560;
      setShowControls(!mobile);
      setIsMobile(mobile);
      setDisplayedPrograms(mobile ? programs.slice(0, 3) : programs);
    };

    window.addEventListener('resize', handleResize);
    handleResize(); // 初始化時調用一次

    return () => window.removeEventListener('resize', handleResize);
  }, [programs]);

  const responsiveOptions = [
    {
      breakpoint: "1024px",
      numVisible: 3,
      numScroll: 3,
    },
    {
      breakpoint: "768px",
      numVisible: 3,
      numScroll: 3,
    },
    {
      breakpoint: "560px",
      numVisible: 3,
      numScroll: 3,
    },
  ];
  const pageSize = 16;

  const refreshPrograms = async () => {
    const param = {
      // centerId: center?.id,
      pageNumber: 1,
      pageSize: pageSize,
      // StartDateFrom: new Date(),
      isShow: true,
      isTop: null,
      orderBy: "startDate",
      isOrderByAsc: false,
      isInProgress: true
    };
    const result = await getProgramInfo(param);
    const _programs = result?.data?.items || [];
    setPrograms(_programs);
  };
  useEffect(() => {
    refreshPrograms();
  }, []);

  const itemTemplate = (program) => {
    return (
      <>
      <ProgramPost program={program} />
      </>
      
    );
  };

  return (
    <div className="feature-programs">
      {isMobile ? (
        <div className="program-list d-flex flex-row flex-wrap">
          {displayedPrograms.map((program, index) => (
            <div key={index} className="item">
              {itemTemplate(program)}
            </div>
          ))}
        </div>
      ) : (
        <Carousel
          value={displayedPrograms}
          itemTemplate={itemTemplate}
          responsiveOptions={responsiveOptions}
          showNavigators={showControls}
          showIndicators={showControls}
          numVisible={3}
          numScroll={3}
        />
      )}
        
    </div>
  );
};
export default ProgramSlider;
