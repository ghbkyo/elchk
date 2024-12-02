import InfiniteScroll from "react-infinite-scroll-component";
import "react-multi-carousel/lib/styles.css";
import { useEffect } from "react";
import useState from "react-usestateref";
import { Player } from "@lottiefiles/react-lottie-player";
import ProgramPost from "./ProgramPost";
import LottieLoadingDots1 from "assets/json/LottieLoadingDots1.json";

const ProgramInfinite = (props) => {
  const { programs } = props;
  const [programsToDisplay, setProgramsToDisplay, programsRef] = useState([]);
  const [pageNum, setPageNum, pageNumRef] = useState(0);
  const [hasMore, setHasMore, hasMoreRef] = useState(true);
  const pageSize = 6;

  useEffect(() => {
    setProgramsToDisplay([]);
    setPageNum(0);
    setHasMore(true);
    fetchMoreData();
  }, [programs]);

  const fetchMoreData = async () => {
    const _programs = programs?.slice(
      pageNumRef.current * pageSize,
      pageNumRef.current * pageSize + pageSize
    );
    setPageNum(pageNumRef.current + 1);
    // const _params = {
    //   ...searchParams,
    //   PageNumber: pageNumRef.current,
    //   PageSize: pageSize,
    //   OrderBy: "id",
    //   IsOrderByAsc: false,
    // };
    // const _result = await getProgramInfo(_params);
    // const _programs = _result?.data?.items || [];
    setProgramsToDisplay(programsRef.current?.concat(_programs));

    if (!!_programs && programs?.slice((pageNumRef.current) * pageSize)?.length === 0) {
      setHasMore(false);
    }
  };

  return (
    <div>
      <InfiniteScroll
        className="program-slider-padding"
        dataLength={programsRef.current?.length || 1}
        next={fetchMoreData}
        hasMore={hasMoreRef.current}
        loader={
          <>
            <Player
              autoplay
              loop
              // src="https://assets3.lottiefiles.com/packages/lf20_p8bfn5to.json"
              src={LottieLoadingDots1}
              style={{ height: "150px", width: "150px" }}
            ></Player>
          </>
        }
      >
        <div class="program-list d-flex flex-row flex-wrap">
          {(programsRef.current || []).map((program, index) => {
            return <div className="item"><ProgramPost key={index} program={program} /></div>;
          })}
        </div>
      </InfiniteScroll>
    </div>
  );
};
export default ProgramInfinite;
