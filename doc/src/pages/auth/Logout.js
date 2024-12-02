import { isLoggedIn, logout } from '../../services/AuthService';

const Logout = () => {
    isLoggedIn() && logout()
    return (<></>)
}

export default Logout

