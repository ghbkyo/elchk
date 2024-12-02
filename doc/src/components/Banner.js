import Carousel from "react-multi-carousel";
import "react-multi-carousel/lib/styles.css";
import { Link } from "react-router-dom";

import { Container } from "react-bootstrap";
import {
  getBanner,
  getProgramInfo,
  getProgramInfoBanner,
} from "../services/apiCore";
import { useState, useEffect } from "react";

const Banner = () => {
  const [bannerImage, setBannerImage] = useState([]);
  const responsive = {
    desktop: {
      breakpoint: { max: 3000, min: 1024 },
      items: 1,
      slidesToSlide: 1, // optional, default to 1.
    },
    tablet: {
      breakpoint: { max: 1024, min: 464 },
      items: 1,
      slidesToSlide: 1, // optional, default to 1.
    },
    mobile: {
      breakpoint: { max: 464, min: 0 },
      items: 1,
      slidesToSlide: 1, // optional, default to 1.
    },
  };

  // const refreshPrograms = async () => {
  //   const param = {
  //     pageNumber: 1,
  //     pageSize: 5,
  //     isShow: true,
  //     isBannnerShow: true,
  //     orderBy: "startDate",
  //     isOrderByAsc: false,
  //   };
  //   const result1 = await getProgramInfo(param);
  //   const programs = result1?.data?.items;
  //   for (let i = 0; i < programs.length; i++) {
  //     const bannerImage = await getProgramInfoBanner(programs[i].id);
  //     programs[i].bannerImage = bannerImage;
  //   }
  //   // dont show the program in banner if the banner image is empty
  //   setBannerImage(programs.filter((item) => item.bannerImage.data != ""));
  // };

  useEffect(() => {
    // refreshPrograms();
    (async () => {
      try {
        const bannerResult = await getBanner();
        console.log(bannerResult);
        setBannerImage(bannerResult?.data || []);
      } catch (e) {
        console.log(e);
      }
    })();
  }, []);

  try {
    return (
      <div className="top-banner">
        <Container>
          <Carousel
            swipeable={false}
            draggable={false}
            showDots={true}
            responsive={responsive}
            ssr={true} // means to render carousel on server-side.
            infinite={true}
            autoPlay={bannerImage?.length > 1}
            autoPlaySpeed={4000}
            keyBoardControl={bannerImage?.length > 1}
            emulateTouch={true}
            customTransition="transform 1000ms ease-in-out"
            transitionDuration={500}
            containerClass="carousel-container"
            removeArrowOnDeviceType={["tablet", "mobile"]}
            deviceType={"desktop"}
            dotListClass="custom-dot-list-style"
            itemClass="carousel-item-padding-40-px"
          >
            {(bannerImage || [])?.map((item) => {
              console.log(item);
              return (
                <div key={item?.name} className="text-center">
                  {/* <Link to={"/program/detail/" + item?.id}>*/}
                  <img
                    src={`data:image/jpeg;base64, ${item?.content}`}
                    className="img-fluid d-block shadow banner-img-height"
                  ></img>
                </div>
              );
            })}

            {/* <div className="text-center">
              <Link to="https://charity.elchk.org.hk" target="_blank">
                <img
                  src={Bannerimg1}
                  className="img-fluid d-block shadow rounded banner-img-height"
                ></img>
              </Link>
            </div>
            <div className="text-center">
              <Link to="https://charity.elchk.org.hk" target="_blank">
                <img
                  src={Bannerimg2}
                  className="img-fluid d-block shadow rounded banner-img-height"
                ></img>
              </Link>
            </div>
            <div className="text-center">
              <Link to="https://charity.elchk.org.hk" target="_blank">
                <img
                  src={Bannerimg3}
                  className="img-fluid d-block shadow rounded banner-img-height"
                ></img>
              </Link>
            </div> */}
          </Carousel>
        </Container>
      </div>
    );
  } catch (e) {
    console.log(e);
    return null;
  }
};

export default Banner;
