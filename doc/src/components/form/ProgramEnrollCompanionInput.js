import { Form, Col, Row, Button, Card } from 'react-bootstrap'
import FeatherIcon from 'feather-icons-react'
import useState from 'react-usestateref'
import { useEffect } from 'react'
const ProgramEnrollCompanionInput = ({propsKey, firstText, secondText, handleDeleteCompanion,textChange, initialName, initialTelMobile }) => {
    const initValuesChild = {
        name:'',
        telMobile: "",
      }
    const [ valuesChild, setinitValuesChild ] = useState(initValuesChild)
    useEffect(() => {
        setinitValuesChild({...valuesChild, name: initialName, telMobile: initialTelMobile})
    }, [initialName, initialTelMobile])
    const handelChange=(e)=>
    {
        if (e && e.target) {
            setinitValuesChild({...valuesChild, [e.target.name]:e.target.value})
            textChange(propsKey,e.target.name,e.target.value)
        }
        else
        {
            setinitValuesChild({...valuesChild, [e.target.name]:''})
            textChange(propsKey,e.target.name,'')
        }
    
    }
      
    return (
        <Card className="m-0 ">
            <Row>
                
                <Col lg={5}>
                    <Form.Group className="my-3" controlId="formCompanionName">
                        <Form.Control type="text" placeholder={firstText?firstText:'姓名'} name="name" value={valuesChild?.name?valuesChild.name:''} onChange={(e) => {handelChange(e)}}/>
                    </Form.Group>
                </Col>
                <Col lg={5}>
                    <Form.Group className="my-3" controlId="formCompanionMobile">
                        <Form.Control type="text" placeholder={secondText?secondText:'手提電話'} name="telMobile" value={valuesChild?.telMobile?valuesChild.telMobile:''} onChange={(e) => {handelChange(e)}}/>
                    </Form.Group>
                </Col>
                <Col lg={2}>
                    <Form.Group className="my-3" controlId="formBasicText">
                        <Button variant="danger" className="me-2 mb-2 mb-sm-0 btn-icon d-inline-flex"  onClick={()=> handleDeleteCompanion(propsKey)}>
                            <FeatherIcon icon="minus" className="icon icon-sm" />
                        </Button>
                    </Form.Group>
                </Col>
            </Row>
        </Card>
    )
}

export default ProgramEnrollCompanionInput


