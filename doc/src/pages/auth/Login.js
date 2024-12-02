import { Alert, Button, Col, Container, Form, Row } from "react-bootstrap";
import Navbar4 from "../../components/navbars/Navbar4";
import Footer from "../../components/footer/Footer";
import PageHeading from "components/PageHeading";
import { doLogin } from "services/AuthService";
import { useEffect, useState } from "react";
import { getMemberInfo, getMemberPhoto } from "services/apiCore";

const Login = () => {

    const [ loading, setLoading ] = useState(false)
    const [ username, setUsername ] = useState('')
    const [ password, setPassword ] = useState('')
    const [ rememberMe, setRememberMe ] = useState(false);
    const [alert, setAlert] = useState({ alertType: "danger", alertMessage: "" });

    useEffect(() => {
        const rememberusername = sessionStorage.getItem('rememberusername');
        if (rememberusername) {
            setUsername(rememberusername);
            setRememberMe(true)
        }
    }, []);

    const handleAlertClose = () => {
        setAlert({ ...alert, alertMessage: "" });
    };
    const handleLogin = () => {
        handleAlertClose();
        setLoading(true)
        doLogin(username, password).then(async (res) => {
            try {
                if (rememberMe) {
                    sessionStorage.setItem('rememberusername', username);
                } else {
                    sessionStorage.removeItem('rememberusername');
                }
                const userResult = await getMemberInfo()
                const userImg = await getMemberPhoto(userResult.data[0].id)
                sessionStorage.setItem("member", JSON.stringify(userResult.data[0]))
                sessionStorage.setItem("center",  JSON.stringify(userResult.data[0].center))
                sessionStorage.setItem("userImg",  userImg.data)
                
                window.location.replace('/')
            } catch (err) {
                console.error(err)
                window.alert("登入發生錯誤, 請重新登入帳戶")
            }
        }).catch((err) => {
            if (err.error == "invalid_grant") {
                if (err.error_description == 'invalid_username_or_password') {
                    setAlert({ alertType: 'danger', alertMessage: '用戶名或密碼錯誤' })
                }
            }
        }).finally(() => setLoading(false))
    }
  return (
    <>
      <Navbar4 fixedWidth />
      <div id="main">
        <PageHeading title="會員登入" />
        
        <section className="position-relative">
          <Container className="pb-4">
            <Row className="mt-4">
                <Col lg={12}>
                    {!!alert?.alertMessage && (
                    <div className="px-5">
                    <Alert
                        variant={alert?.alertType}
                    >
                        <div>{alert?.alertMessage}</div>
                    </Alert>
                    </div>
                )}
                </Col>
            </Row>
            <Row data-aos="fade-up">
              <Col className="d-flex justify-content-center">
                <Form className="p-4 rounded" style={{
                    backgroundColor: '#58C5E6',
                    width: '350px'
                }}>
                    <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
                        <Form.Label>用戶名稱</Form.Label>
                        <Form.Control defaultValue={username} type="email" placeholder="用戶名稱" onChange={(e) => setUsername(e.target.value)} />
                    </Form.Group>
                    <Form.Group className="mb-3" controlId="exampleForm.ControlInput1">
                        <Form.Label>密碼</Form.Label>
                        <Form.Control type="password" placeholder="密碼" onChange={(e) => setPassword(e.target.value)} />
                    </Form.Group>
                    <Form.Group className="mb-3 d-flex justify-content-between">
                        <Form.Check // prettier-ignore
                            className=""
                            checked={rememberMe}
                            type='checkbox'
                            id='remember-me'
                            label='記住帳號'
                            onChange={(e) => setRememberMe(e.target.checked)}
                        />
                        <div><a href="#" style={{color: '#fff'}}>忘記密碼？</a></div>
                    </Form.Group>
                    <Form.Group className="text-center">
                        <Button disabled={loading} variant="blue" className="px-5" onClick={handleLogin}>登入</Button>
                    </Form.Group>
                </Form>
              </Col>
            </Row>
          </Container>
        </section>
      </div>
      <Footer />
    </>
  );
};

export default Login;
