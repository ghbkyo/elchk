import { Button, Col, Row } from 'react-bootstrap';

// components
import { FormInput } from '../../../../components/form';

const Notifications = () => {
    return (
        <>
            <h4 className="mt-3 mt-lg-0">Notifications</h4>
            <form className="password-form mt-4">
                <div className="mb-3">
                    <label htmlFor="name">Send me an email, when</label>
                    <ul className="list-unstyled">
                        <FormInput
                            type="checkbox"
                            label="Someone mentions me"
                            name="mention"
                            id="mention"
                            className="form-switch"
                            containerClass="mt-2"
                            defaultChecked
                        />
                        <FormInput
                            type="checkbox"
                            label="Someone replies to me"
                            name="replies"
                            id="replies"
                            className="form-switch"
                            containerClass="mt-2"
                        />
                        <FormInput
                            type="checkbox"
                            label="Someone shares the content"
                            name="share-content"
                            id="share-content"
                            className="form-switch"
                            containerClass="mt-2"
                            defaultChecked
                        />
                        <FormInput
                            type="checkbox"
                            label="There is a new published content"
                            name="new-content"
                            id="new-content"
                            className="form-switch"
                            containerClass="mt-2"
                        />
                    </ul>
                </div>

                <hr className="my-4" />

                <div className="mb-3">
                    <label htmlFor="name">Other Subscriptions</label>
                    <ul className="list-unstyled">
                        <FormInput
                            type="checkbox"
                            label="Weekly newsletter"
                            name="newsletter"
                            id="newsletter"
                            className="form-switch"
                            containerClass="mt-2"
                            defaultChecked
                        />
                        <FormInput
                            type="checkbox"
                            label="Weekly jobs"
                            name="weekly-jobs"
                            id="weekly-jobs"
                            className="form-switch"
                            containerClass="mt-2"
                        />
                        <FormInput
                            type="checkbox"
                            label="Events new me"
                            name="events"
                            id="events"
                            className="form-switch"
                            containerClass="mt-2"
                            defaultChecked
                        />
                    </ul>
                </div>

                <hr className="my-4" />

                <Row className="mt-3">
                    <Col lg={12}>
                        <Button type="submit">Update Preferences</Button>
                    </Col>
                </Row>
            </form>
        </>
    );
};

export default Notifications;
