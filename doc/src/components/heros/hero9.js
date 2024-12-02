import { useEffect, useState } from 'react';
import { Button, Col, Container, Row } from 'react-bootstrap'
import { ParallaxBanner, ParallaxProvider } from 'react-scroll-parallax'

// images
import coworking from '../../assets/images/hero/coworking3_origin.jpeg'

const Hero9 = () => {
    const [width, setWidth] = useState(window.innerWidth)
    const [imageProps, setImageStyle] = useState({ speed: -30, style: {width: "100%"} })

    function handleWindowSizeChange() {
        setWidth(window.innerWidth)
    }

    const isMobile = width <= 768

    useEffect(() => {
        window.addEventListener('resize', handleWindowSizeChange)
        if (isMobile) {
            setImageStyle({ speed: -5, style:{...imageProps.style, height: "15vh"}})
        }
        return () => {
            window.removeEventListener('resize', handleWindowSizeChange)
        }
    }, [isMobile])

    return (
        <section className="position-relative hero-9">
            <div className="hero-top">
                <Container>
                    <Row className="py-7">
                        <Col>
                            <h1 className="hero-title fw-bold">
                                我們的使命
                            </h1>
                            <p className="mt-3 fs-17">
                                實踐耶穌基督傳揚福音和服務人群的精神。
                            </p>
                            <h1 className="hero-title fw-bold">
                                願景
                            </h1>
                            <p className="mt-3 fs-17">
                                以人為本、關心弱勢社群。 與時並進、銳意變革創新。 邁向卓越、處處顯出關懷。
                            </p>
                        </Col>
                    </Row>
                </Container>
            </div>
            <div className="position-relative">
                <div className="hero-cta">
                    <Button variant="info" className="btn-cta">
                        Let's Have Talk
                    </Button>
                </div>
            </div>
            <div className="hero-bottom">
                <ParallaxProvider>
                    <ParallaxBanner
                        layers={[
                            { image: coworking, speed: imageProps.speed, style: { backgroundSize: 'contain' } }
                        ]}
                        style={imageProps.style}
                        className="hero-image"
                    ></ParallaxBanner>
                </ParallaxProvider>
            </div>
        </section>
    );
};

export default Hero9;
